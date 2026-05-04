import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'core/models/note.dart';
import 'core/models/sync_action.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/providers.dart';
import 'presentation/screens/signin_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'core/models/note_adapter.dart';
import 'core/models/sync_action_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);


  await Hive.initFlutter();

  // REGISTER ADAPTERS FIRST
  print('Registering adapters...');
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(SyncActionAdapter());
  print('✅ Adapters registered');

  // THEN OPEN BOXES
  print('Opening boxes...');
  await Hive.openBox<Note>('notes');
  await Hive.openBox<SyncAction>('sync_queue');
  await Hive.openBox('settings');
  print('✅ Boxes opened');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // Check if user is already logged in
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'NoteSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: user != null ? const HomeScreen() : const SignInScreen(),
    );
  }
}