import '../../../app/model/notification/notification_response_model.dart';

class FCMNotificationPayload {
  String? module;
  String? screenName;
  String? referenceId;
  String? notificationType;
  String? mobileRedirect;
  String? apnsCategory;
  NotificationData? notificationData;

  FCMNotificationPayload.fromJson(Map<String, dynamic> json) {
    module = json['moduleName'];
    screenName = json['screenName'];
    referenceId = json['dataReference'];
    apnsCategory = json['apns_category'];
    notificationType = json['notificationType'];
    mobileRedirect = json['mobileRedirect'];
    notificationData = json['notificationData'] is Map<String, dynamic>
        ? NotificationData.fromJson(json['notificationData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['moduleName'] = module;
    data['screenName'] = screenName;
    data['dataReference'] = referenceId;
    data['mobileRedirect'] = mobileRedirect;
    data['apns_category'] = apnsCategory;
    data['notificationType'] = notificationType;
    if (notificationData != null) {
      data['notificationData'] = notificationData!.toJson();
    }
    return data;
  }
}
