import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../models/sync_action.dart';

class NoteRepository {
  static const String notesBox = 'notes';
  static const String syncBox = 'sync_queue';

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Box<Note> get _notesBox => Hive.box<Note>(notesBox);
  Box<SyncAction> get _syncBox => Hive.box<SyncAction>(syncBox);

  String? get currentUserId => _auth.currentUser?.uid;

  Future<User?> signIn(String email, String password) async {
    try {
      print('📝 Signing in: $email');

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        try {
          await _database.child('users').child(user.uid).update({
            'lastLogin': DateTime.now().toIso8601String(),
          });
        } catch (dbError) {
          print('Database update error (non-critical): $dbError');
        }
      }

      print('✅ Sign in successful: ${user?.uid}');
      return user;

    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('⚠️ Non-critical error during sign in: $e');
      final user = _auth.currentUser;
      if (user != null && user.email == email) {
        print('✅ User is actually signed in despite error: ${user.uid}');
        return user;
      }
      return null;
    }
  }

  Future<void> deleteNoteLocally(String noteId) async {
    await _notesBox.delete(noteId);
    print('🗑️ Note deleted locally: $noteId');
  }

  Future<void> queueDeleteAction(String noteId) async {
    final action = SyncAction.create(
      type: ActionType.delete,
      data: {'id': noteId},
    );
    await _syncBox.put(action.id, action);
    print('📤 Delete action queued for note: $noteId');
  }

  Future<User?> signUp(String email, String password, String firstName, String lastName) async {
    try {
      print('📝 Starting sign up for: $email');

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      print('✅ User created in Auth: ${user?.uid}');

      final fullName = '$firstName $lastName';
      await user?.updateDisplayName(fullName);
      await user?.reload();

      print('✅ Display name updated: $fullName');

      if (user != null) {
        try {
          final userRef = _database.child('users').child(user.uid);
          await userRef.set({
            'email': email,
            'displayName': fullName,
            'firstName': firstName,
            'lastName': lastName,
            'createdAt': DateTime.now().toIso8601String(),
            'lastLogin': DateTime.now().toIso8601String(),
          });
          print('✅ User data stored in Realtime Database');
        } catch (dbError) {
          print('Database storage error (non-critical): $dbError');
        }
      }

      print('🎉 Sign up completed successfully!');
      return user;

    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('⚠️ Non-critical error during sign up: $e');
      final user = _auth.currentUser;
      if (user != null && user.email == email) {
        print('✅ User was actually created successfully: ${user.uid}');
        return user;
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _notesBox.clear();
    await _syncBox.clear();
    print('👋 User signed out');
  }

  Future<void> saveNoteLocally(Note note) async {
    await _notesBox.put(note.id, note);
    print('💾 Note saved locally: ${note.title}');
  }

  Future<List<Note>> getAllNotesLocally() async {
    final userId = currentUserId;
    if (userId == null) return [];

    final allNotes = _notesBox.values.toList();
    final userNotes = allNotes.where((note) => note.userId == userId).toList();
    userNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    print('📱 Found ${userNotes.length} notes for user $userId');
    return userNotes;
  }

  Future<void> queueSyncAction(SyncAction action) async {
    print('=== QUEUE DEBUG ===');
    print('Action ID: ${action.id}');
    print('Action Type: ${action.type}');
    print('Queue box is open: ${_syncBox.isOpen}');
    print('Queue box name: ${_syncBox.name}');
    print('Current queue size BEFORE: ${_syncBox.values.length}');

    try {
      await _syncBox.put(action.id, action);
      print('✅ Action saved to queue');
      print('Current queue size AFTER: ${_syncBox.values.length}');

      final saved = _syncBox.get(action.id);
      if (saved != null) {
        print('✅ Verified action exists in queue');
      } else {
        print('❌ Action NOT found after save!');
      }
    } catch (e) {
      print('❌ Error saving to queue: $e');
    }
  }

  Future<List<SyncAction>> getPendingActions() async {
    print('=== GET PENDING ACTIONS ===');
    print('Queue box is open: ${_syncBox.isOpen}');
    print('Total items in box: ${_syncBox.values.length}');

    final actions = _syncBox.values
        .where((a) => a.status == SyncStatus.pending || a.status == SyncStatus.retrying)
        .toList();

    print('Found ${actions.length} pending actions');
    for (var a in actions) {
      print('  - ${a.type.name}: ${a.data['title']}');
    }

    return actions;
  }

  Future<void> updateSyncActionStatus(String id, SyncStatus status, {String? error}) async {
    final action = _syncBox.get(id);
    if (action != null) {
      final updated = action.copyWith(status: status, errorMessage: error);
      await _syncBox.put(id, updated);
    }
  }

  Future<void> removeSyncAction(String id) async {
    await _syncBox.delete(id);
  }

  Future<bool> syncAction(SyncAction action) async {
    if (currentUserId == null) return false;

    try {
      print('🔄 Syncing action: ${action.type.name}');

      final snapshot = await _database
          .child('users')
          .child(currentUserId!)
          .child('synced_actions')
          .child(action.idempotencyKey)
          .get();

      if (snapshot.exists) {
        print('⚠️ Action already synced (idempotency check)');
        await removeSyncAction(action.id);
        return true;
      }

      await _database
          .child('users')
          .child(currentUserId!)
          .child('synced_actions')
          .child(action.idempotencyKey)
          .set({
        'actionId': action.id,
        'processedAt': DateTime.now().toIso8601String(),
        'type': action.type.name,
        'status': 'processing',
      });

      switch (action.type) {
        case ActionType.create:
        case ActionType.update:
          final noteData = action.data;
          await _database
              .child('users')
              .child(currentUserId!)
              .child('notes')
              .child(noteData['id'])
              .set(noteData);
          print('✅ Note synced: ${noteData['title']}');
          break;
        case ActionType.like:
          await _database
              .child('users')
              .child(currentUserId!)
              .child('notes')
              .child(action.data['id'])
              .update({
            'isLiked': action.data['isLiked'],
            'updatedAt': DateTime.now().toIso8601String(),
          });
          print('✅ Like synced for note: ${action.data['id']}');
          break;
        case ActionType.delete:
          await _database
              .child('users')
              .child(currentUserId!)
              .child('notes')
              .child(action.data['id'])
              .remove();
          print('✅ Delete synced for note: ${action.data['id']}');
          break;
      }

      await _database
          .child('users')
          .child(currentUserId!)
          .child('synced_actions')
          .child(action.idempotencyKey)
          .update({
        'status': 'completed',
      });

      await removeSyncAction(action.id);
      return true;
    } catch (e) {
      print('❌ Sync error: $e');
      return false;
    }
  }

  Future<void> syncRemoteToLocal(String userId) async {
    try {
      print('📡 Fetching notes from Firebase for user: $userId');

      final snapshot = await _database
          .child('users')
          .child(userId)
          .child('notes')
          .get();

      if (snapshot.exists) {
        final notesMap = snapshot.value as Map<dynamic, dynamic>?;
        if (notesMap != null) {
          print('📦 Found ${notesMap.length} notes in Firebase');

          for (var entry in notesMap.entries) {
            try {
              final noteData = Map<String, dynamic>.from(entry.value);
              final remoteNote = Note.fromJson(noteData);
              await _notesBox.put(remoteNote.id, remoteNote);
              print('✅ Saved note to local: ${remoteNote.title}');
            } catch (e) {
              print('❌ Error parsing note: $e');
            }
          }
          print('✅ Successfully synced ${notesMap.length} notes from Firebase');
        }
      } else {
        print('📭 No notes found in Firebase for user: $userId');
      }
    } catch (e) {
      print('❌ Error syncing from remote: $e');
    }
  }

  int getPendingCount() => _syncBox.values.where((a) =>
  a.status == SyncStatus.pending || a.status == SyncStatus.retrying
  ).length;

  int getCompletedCount() => _syncBox.values.where((a) =>
  a.status == SyncStatus.completed
  ).length;

  int getFailedCount() => _syncBox.values.where((a) =>
  a.status == SyncStatus.failed
  ).length;
}