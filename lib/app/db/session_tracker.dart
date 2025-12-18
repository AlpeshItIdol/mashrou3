import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mashrou3/config/services/analytics_service.dart';

import '../../config/resources/app_constants.dart';
import 'app_preferences.dart';

class SessionTracker with WidgetsBindingObserver {
  static final SessionTracker _instance = SessionTracker._internal();

  factory SessionTracker() => _instance;

  SessionTracker._internal();

  DateTime? _startTime;
  bool _isLoggedIn = false;

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    _isLoggedIn = await AppPreferences.instance.getIsLoggedIn();
    if (_isLoggedIn) {
      _startTime = DateTime.now(); // Set initial time when app starts
    }
  }

  Future<void> onLogout() async {
    if (_isLoggedIn && _startTime != null) {
      _logSessionTime(); // Log time immediately on logout
    }
    _startTime = null;
    _isLoggedIn = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _isLoggedIn = await AppPreferences.instance.getIsLoggedIn();
        if (_isLoggedIn) _startTime = DateTime.now();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (_isLoggedIn && _startTime != null) {
          _logSessionTime();
          _startTime = null;
        }
        break;
      default:
        break;
    }
  }

  Future<void> _logSessionTime() async {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!);
    final totalSeconds = duration.inSeconds;

    final userId = await AppPreferences.instance.getUserID();
    final userType = await AppPreferences.instance.getUserRole(); // Assuming this is your user_type

    AnalyticsService.logEvent(eventName: "user_spent_time", parameters: {
      AppConstants.analyticsIdOfUserKey: userId,
      AppConstants.analyticsUserTypeKey: userType,
      AppConstants.analyticsTimeKey: totalSeconds
    });
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
