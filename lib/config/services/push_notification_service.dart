import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../app/ui/owner_screens/visit_requests_list/cubit/visit_requests_list_cubit.dart';
import '../resources/app_constants.dart';
import 'fcm_helper.dart';
import 'model/notification_payload.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('drawable/ic_notification_icon');
    // Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'VISIT_REQUEST_CREATED', // This must match with category in APNs payload if used
          actions: [
            DarwinNotificationAction.plain(
              'ACCEPT_ACTION',
              'Accept',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.text(
              'REPLY_ACTION',
              'Reject',
              buttonTitle: "Submit",
              placeholder: "Reason for reject",
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
          ],
          options: const {
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
            DarwinNotificationCategoryOption.hiddenPreviewShowSubtitle,
          },
        ),
      ],
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        debugPrint("Notification Response: ${notificationResponse.actionId}");

        final actionId = notificationResponse.actionId;
        if ((actionId ?? "").isNotEmpty) {
          if (notificationResponse.actionId == 'REPLY_ACTION') {
            final userInput = notificationResponse.input;
            debugPrint("User replied: $userInput");
            VisitRequestsCubit? cubit = AppConstants.appContext?.read<VisitRequestsCubit>();
            if (cubit != null) {
              FCMNotificationPayload notificationPayload = FCMNotificationPayload.fromJson(json.decode(notificationResponse.payload ?? ""));
              cubit.rejectVisitRequest(requestId: notificationPayload.referenceId ?? "", requestMessage: userInput ?? "");
            }
            // Handle reply
          } else if (notificationResponse.actionId == 'ACCEPT_ACTION') {
            // Handle mark as read
            debugPrint("User  Accepted");
            VisitRequestsCubit? cubit = AppConstants.appContext?.read<VisitRequestsCubit>();
            if (cubit != null) {
              FCMNotificationPayload notificationPayload = FCMNotificationPayload.fromJson(json.decode(notificationResponse.payload ?? ""));
              cubit.approveVisitRequest(
                requestId: notificationPayload.referenceId ?? "",
              );
            }
          }
        } else {
          if (notificationResponse.notificationResponseType == NotificationResponseType.selectedNotification) {
            if ((notificationResponse.payload ?? "").isNotEmpty) {
              selectNotificationStream.add(notificationResponse.payload);
              notificationTapBackground(notificationResponse);
            }
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _configureSelectNotificationSubject();
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static void notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped:'
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    FCMNotificationPayload notificationPayload = FCMNotificationPayload.fromJson(jsonDecode(notificationResponse.payload ?? ""));
    print("fcm_helper notificationTapBackground");

    FCMHelper.handleMessage(notificationPayload);
  }

  Future<void> showNotification(
      {required String title,
        required String body,
        String? payload,
        String notificationId = "",
        String largeIcon = "",
        String? apnsCategory,
        String channelId = 'default_channel'}) async {
    String channelId = "Personal Chat";
    String channelName = "Private Chat";
    String channelDescription = "Private Chat";

    Random random = Random();
    int randomNumber = random.nextInt(100);

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );

    final badgeCount = (await _flutterLocalNotificationsPlugin.getActiveNotifications() ?? []).length;

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(
          categoryIdentifier: apnsCategory,
          badgeNumber: badgeCount + 1,
        ));
    await _flutterLocalNotificationsPlugin.show(randomNumber, title, body, notificationDetails, payload: payload);
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      FCMNotificationPayload notificationPayload = FCMNotificationPayload.fromJson(json.decode(payload ?? ""));
      print("push_notification_service _configureSelectNotificationSubject");

      FCMHelper.handleMessage(notificationPayload);
    });
  }

  Future<ui.Image> fetchImage(String url) async {
    // Fetch image bytes from the URL
    final response = await Dio().get(url);
    if (response.statusCode == 200) {
      // Decode image bytes into a ui.Image
      final Uint8List bytes = response.data;
      final Completer<ui.Image> completer = Completer();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        completer.complete(img);
      });
      return completer.future;
    } else {
      throw Exception('Failed to load image from URL');
    }
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
