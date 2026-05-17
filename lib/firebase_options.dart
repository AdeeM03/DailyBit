import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this platform. '
      'Please run `flutterfire configure` to set up Android/iOS.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDLgSsr7F7bvhANGCtHifEuyw4P1cwrATw',
    appId: '1:899681256715:web:da711a6594d1e1b8498e0e',
    messagingSenderId: '899681256715',
    projectId: 'dailybit-867ad',
    authDomain: 'dailybit-867ad.firebaseapp.com',
    storageBucket: 'dailybit-867ad.firebasestorage.app',
    measurementId: 'G-C2KTMR54D2',
  );
}
