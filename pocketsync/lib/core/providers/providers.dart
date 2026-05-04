import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/note_repository.dart';
import '../services/sync_service.dart';
import '../models/note.dart';
import '../models/sync_action.dart';

final noteRepositoryProvider = Provider((ref) => NoteRepository());

final syncServiceProvider = Provider((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  final service = SyncService(repository);
  ref.onDispose(() => service.dispose());
  return service;
});

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  final syncService = ref.watch(syncServiceProvider);
  return NotesNotifier(repository, syncService);
});

class NotesNotifier extends StateNotifier<List<Note>> {
  final NoteRepository _repository;
  final SyncService _syncService;

  NotesNotifier(this._repository, this._syncService) : super([]) {
    _loadNotes();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await _repository.syncRemoteToLocal(user.uid);
        await _loadNotes();
      }
    });
  }

  Future<void> _loadNotes() async {
    state = await _repository.getAllNotesLocally();
  }

  Future<void> refreshFromFirebase() async {
    final userId = _repository.currentUserId;
    if (userId != null) {
      await _repository.syncRemoteToLocal(userId);
      await _loadNotes();
    }
  }

  Future<void> addNote(String title, String content, String userId) async {
    final note = Note.create(title: title, content: content, userId: userId);

    await _repository.saveNoteLocally(note);
    state = [note, ...state];

    final action = SyncAction.create(
      type: ActionType.create,
      data: note.toJson(),
    );
    await _repository.queueSyncAction(action);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await _syncService.startSync();
    }
  }

  Future<void> toggleLike(Note note) async {
    final updatedNote = note.copyWith(isLiked: !note.isLiked);

    await _repository.saveNoteLocally(updatedNote);
    final index = state.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      state = [...state]..[index] = updatedNote;
    }

    final action = SyncAction.create(
      type: ActionType.like,
      data: {'id': note.id, 'isLiked': updatedNote.isLiked},
    );
    await _repository.queueSyncAction(action);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await _syncService.startSync();
    }
  }

  Future<void> updateNote(Note note, String newTitle, String newContent) async {
    final updatedNote = note.copyWith(
      title: newTitle,
      content: newContent,
    );

    await _repository.saveNoteLocally(updatedNote);
    final index = state.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      state = [...state]..[index] = updatedNote;
    }

    final action = SyncAction.create(
      type: ActionType.update,
      data: updatedNote.toJson(),
    );
    await _repository.queueSyncAction(action);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await _syncService.startSync();
    }
  }

  Future<void> deleteNote(Note note) async {
    state = state.where((n) => n.id != note.id).toList();

    await _repository.deleteNoteLocally(note.id);
    await _repository.queueDeleteAction(note.id);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await _syncService.startSync();
    }
  }
}

final syncQueueProvider = StateNotifierProvider<SyncQueueNotifier, List<SyncAction>>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return SyncQueueNotifier(repository);
});

class SyncQueueNotifier extends StateNotifier<List<SyncAction>> {
  final NoteRepository _repository;

  SyncQueueNotifier(this._repository) : super([]) {
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    state = await _repository.getPendingActions();
  }

  Future<void> refresh() async {
    await _loadQueue();
  }
}

final syncStatsProvider = StreamProvider<Map<String, int>>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.stats;
});

final syncLogsProvider = StreamProvider<List<String>>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.logs.map((log) => [log]).handleError((_) => <String>[]);
});