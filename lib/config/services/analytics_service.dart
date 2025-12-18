import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mashrou3/config/resources/app_constants.dart';

class AnalyticsService {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /// Logs an event with dynamic parameters
  static Future<void> logEvent({
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    final enrichedParams = await _addCommonParameters(parameters);

    debugPrint("Analytics event: $eventName, parameters: $enrichedParams");

    await analytics.logEvent(
      name: eventName,
      parameters: enrichedParams.map((key, value) => MapEntry(key, value as Object)),
    );
  }

  /// Adds platform and device type to the event parameters
  static Future<Map<String, dynamic>> _addCommonParameters(Map<String, dynamic> params) async {
    final Map<String, dynamic> commonParams = {
      AppConstants.analyticsPlatformKey: AppConstants.analyticsPlatformValue,
      AppConstants.analyticsDeviceTypeKey: await _getDeviceType(),
    };

    return {
      ...params,
      ...commonParams,
    };
  }

  static Future<String> _getDeviceType() async {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'MacOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}
