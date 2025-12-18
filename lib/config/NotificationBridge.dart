import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/services/model/notification_payload.dart';

import '../app/db/app_preferences.dart';
import '../app/ui/owner_screens/visit_requests_list/cubit/visit_requests_list_cubit.dart';

class NotificationBridge {
  static const MethodChannel _platformChannel = MethodChannel('custom_notification_channel');

  static void setupNotificationMethodChannel() {
    _platformChannel.setMethodCallHandler(_handlePlatformCall);
  }

  static Future<dynamic> _handlePlatformCall(MethodCall call) async {
    switch (call.method) {
      case "handleAcceptAction":
        final Map<String, dynamic> payload = Map<String, dynamic>.from(call.arguments);
        _handleAcceptAction(payload);

        break;
      case "handleRejectAction":
        final Map<String, dynamic> payload = Map<String, dynamic>.from(call.arguments);
        _handleRejectAction(payload);
        break;

      case "getAuthToken":
        AppPreferences appPreferences = AppPreferences();
        final token = await appPreferences.getApiToken();
        return token;

      default:
        debugPrint("Unknown method called from native: ${call.method}");
    }
  }

  static void _handleAcceptAction(Map<String, dynamic> payloadJson) {
    try {
      final payload = FCMNotificationPayload.fromJson(payloadJson);
      final cubit = AppConstants.appContext?.read<VisitRequestsCubit>();
      cubit?.approveVisitRequest(requestId: payload.referenceId ?? "");
    } catch (e) {
      debugPrint("❌ Error parsing payload or calling cubit: $e");
    }
  }

  static void _handleRejectAction(Map<String, dynamic> payloadJson) {
    try {
      final payload = FCMNotificationPayload.fromJson(Map<String, dynamic>.from(payloadJson['payload']));

      final cubit = AppConstants.appContext?.read<VisitRequestsCubit>();
      cubit?.rejectVisitRequest(requestId: payload.referenceId ?? "", requestMessage: payloadJson['userInput']);
    } catch (e) {
      debugPrint("❌ Error parsing payload or calling cubit: $e");
    }
  }
}
