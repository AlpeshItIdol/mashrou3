import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/db/app_preferences.dart';
import 'app/db/session_tracker.dart';
import 'application.dart';
import 'config/NotificationBridge.dart';
import 'config/firebase/auth_credentials.dart';
import 'config/flavor_config.dart';
import 'config/network/network_constants.dart';

void main() async {
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.black,
      values: FlavorValues(baseUrl: NetworkConstants.kDevelopment));
  // FlavorConfig(
  //     flavor: Flavor.PRODUCTION,
  //     color: Colors.black,
  //     values: FlavorValues(baseUrl: NetworkConstants.kDevelopment));

  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.instance.getIsLoggedIn(); // preload
  await SessionTracker().init();

  NotificationBridge.setupNotificationMethodChannel();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: AuthCredentials.kAndroidAPIKey,
            appId: AuthCredentials.kAndroidAppId,
            messagingSenderId: AuthCredentials.kMessagingSenderId,
            projectId: AuthCredentials.kProjectId));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: AuthCredentials.kiOSApiKey,
            appId: AuthCredentials.kiOSAppId,
            messagingSenderId: AuthCredentials.kMessagingSenderId,
            projectId: AuthCredentials.kProjectId));
  }
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  runApp(const Application());
}
