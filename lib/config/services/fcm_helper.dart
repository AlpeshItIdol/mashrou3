import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/config/services/push_notification_service.dart';
import 'package:mashrou3/config/utils.dart';

import '../../app/navigation/app_router.dart';
import '../../app/ui/owner_screens/visit_requests_list/cubit/visit_requests_list_cubit.dart';
import '../resources/app_constants.dart';
import 'model/notification_payload.dart';

class FCMHelper {
  static Set<String> processedIds = {};

  static final FCMHelper _instance = FCMHelper._internal();

  static FCMHelper get instance => _instance;

  factory FCMHelper() => _instance;

  FCMHelper._internal();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setupNotification(Function() onFirebaseInitialised) async {
    try {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (Platform.isIOS) {
        String? apnsToken = await firebaseMessaging.getAPNSToken();
      }

      if ((settings.authorizationStatus == AuthorizationStatus.authorized) ||
          (settings.authorizationStatus == AuthorizationStatus.provisional)) {
        firebaseMessaging.getInitialMessage().then((value) async {
          if (value != null) {
            await Future.delayed(const Duration(seconds: 1));
            _onMessageOpened(value);
          }
        });

        firebaseMessaging.onTokenRefresh.listen((newToken) async {
          if (newToken.isNotEmpty) {
            await GetIt.I<AppPreferences>().setFCMTokenUpdate(false);
            await GetIt.I<AppPreferences>().saveFCMToken(newToken);
            onFirebaseInitialised();
          }
        });

        await enableForegroundNotifications();

        await registerNotificationListeners();

        final token = await getFcmToken();

        if (token != '') {
          await GetIt.I<AppPreferences>().saveFCMToken(token);
        }
        onFirebaseInitialised();

        try {
          FirebaseMessaging.onBackgroundMessage(FCMHelper.onBackgroundMessage);
        } catch (ex) {
          printf(ex.toString());
        }

        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          _onMessageOpened(message);
        });
      }

      await NotificationService().init();
    } on Exception catch (e) {
      dev.log('::==>> FCM setupNotification exception :: $e');
    }
  }

  enableForegroundNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  registerNotificationListeners() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      showBadge: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      defaultPresentBadge: false,
      notificationCategories: [
        DarwinNotificationCategory(
          'PROPERTY_REQUEST', // This must match with category in APNs payload if used
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
    var initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (message) async {
        final actionId = message.actionId;
        if ((actionId ?? "").isNotEmpty) {
          if (actionId == 'ACCEPT_ACTION') {
            // Handle Accept tap
            VisitRequestsCubit? cubit =
                AppConstants.appContext?.read<VisitRequestsCubit>();
            if (cubit != null) {
              FCMNotificationPayload notificationPayload =
                  FCMNotificationPayload.fromJson(
                      json.decode(message.payload ?? ""));
              cubit.approveVisitRequest(
                requestId: notificationPayload.referenceId ?? "",
              );
            }
          } else if (actionId == 'REPLY_ACTION') {
            final replyText = message.input;

            VisitRequestsCubit? cubit =
                AppConstants.appContext?.read<VisitRequestsCubit>();
            if (cubit != null) {
              FCMNotificationPayload notificationPayload =
                  FCMNotificationPayload.fromJson(
                      json.decode(message.payload ?? ""));
              cubit.rejectVisitRequest(
                  requestId: notificationPayload.referenceId ?? "",
                  requestMessage: replyText ?? "");
            }
          }
        } else {
          if ((message.payload ?? "").isNotEmpty) {
            FCMNotificationPayload notificationPayload =
                FCMNotificationPayload.fromJson(
                    json.decode(message.payload ?? ""));
            handleMessage(notificationPayload);
          }
        }
      },
    );
    flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (Platform.isAndroid) {
      FirebaseMessaging.onMessage.listen(_onMessage);
    }
  }

  Future<NotificationSettings> requestPermissionFirebaseMessaging() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings;
  }

  FutureOr<String> getFcmToken() async {
    try {
      String token = await firebaseMessaging.getToken() ?? '';
      return token;
    } on FirebaseException catch (e) {
      return '';
    }
  }

  static void _onMessage(RemoteMessage message) async {
    final isProcessed = _isMessageAlreadyProcessed(
        message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString());
    if (!isProcessed) {
      _markMessageAsProcessed(message.messageId ?? "");

      NotificationService().showNotification(
          title: message.data['title'] ?? message.notification?.title ?? "",
          body: message.data['body'] ?? message.notification?.body ?? "",
          notificationId: message.messageId ?? "",
          apnsCategory: message.data['apns_category'],
          payload: json.encode(message.data));
    }
  }

  static bool _isMessageAlreadyProcessed(String messageId) {
    return processedIds.contains(messageId);
  }

  static void _markMessageAsProcessed(String messageId) {
    processedIds.add(messageId);
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessage(RemoteMessage? message) async {
    if (message != null) {
      FirebaseMessaging.onMessageOpenedApp.listen((event) async {
        await _onMessageOpened(message);
      });
    }
  }

  static Future<void> _onMessageOpened(RemoteMessage message) async {
    await Future.delayed(const Duration(seconds: 1));
    FCMNotificationPayload notificationPayload =
        FCMNotificationPayload.fromJson(message.data);
    handleMessage(notificationPayload);
    print('notificationPayload==> ${notificationPayload.notificationData}');
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        showBadge: true,
      );

  Future<void> logout() async {
    await firebaseMessaging.deleteToken();
  }

  static void handleMessage(FCMNotificationPayload payload) {
    if (payload.module == "visitRequest") {
      AppRouter.goToVisitRequests(
          isOwner: payload.notificationType == "requestCreated");
      return;
    }
    if (payload.module == "offerReviewRequest") {
      Uri uri = Uri.parse(payload.mobileRedirect ?? "");
      final isVendor =
          uri.path.toLowerCase().contains(AppConstants.vendor.toLowerCase());
      if (isVendor) {
        String offerId = uri.path.split("/").last;
        AppRouter.goToOffer(
            offerId: offerId,
            isRejected: payload.notificationType == "rejected");
        return;
      }
    }
    if (payload.module == "finance") {
      if (payload.notificationType == "vendorFinance") {
        AppRouter.goToVendorFinanceRequests();
        return;
      }
    }
    if ((payload.mobileRedirect ?? "").isNotEmpty) {
      Uri uri = Uri.parse(payload.mobileRedirect ?? "");

      // Navigate to property details.
      if (uri.path
          .toLowerCase()
          .contains(AppConstants.viewProperty.toLowerCase())) {
        String propertyId = uri.path.split("/").last;
        final isOwner =
            uri.path.toLowerCase().contains(AppConstants.owner.toLowerCase());
        final isReview = payload.notificationType == "rejected";
        AppRouter.goToPropertyDetail(
            propertyID: propertyId, isOwner: isOwner, isForReview: isReview);
        return;
      }
    }
  }
}
