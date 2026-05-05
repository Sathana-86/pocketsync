import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    //if (kIsWeb) {
     // return web;
   // }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
     // case TargetPlatform.macOS:
       // return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }


  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbEY-C8pjn2hcgwa7g-SPeQmBhMjOO4fw',
    appId: '1:218855473584:android:1aeaffc0f96b0d94a9d675',
    messagingSenderId: '218855473584',
    projectId: 'pocketsync-notes',
    storageBucket: 'pocketsync-notes.firebasestorage.app',
    databaseURL: 'https://pocketsync-notes-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: 'pocketsync-notes.firebasestorage.app',
    iosClientId: 'Y',
    iosBundleId: 'com.example.pocketsync',
  );
}
