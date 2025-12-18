import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'auth_credentials.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  ///-----------------------  Web --------------------
  static const FirebaseOptions web = FirebaseOptions(
      apiKey: AuthCredentials.kAndroidAPIKey,
      appId: AuthCredentials.kAndroidAppId,
      messagingSenderId: AuthCredentials.kMessagingSenderId,
      projectId: AuthCredentials.kProjectId);

  ///-----------------------  Android --------------------
  static const FirebaseOptions android = FirebaseOptions(
      apiKey: AuthCredentials.kAndroidAPIKey,
      appId: AuthCredentials.kAndroidAppId,
      messagingSenderId: AuthCredentials.kMessagingSenderId,
      projectId: AuthCredentials.kProjectId);

  ///----------------------- ios --------------------
  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: AuthCredentials.kiOSApiKey,
      appId: AuthCredentials.kiOSAppId,
      messagingSenderId: AuthCredentials.kMessagingSenderId,
      projectId: AuthCredentials.kProjectId);
}
