class NotificationResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  Data? data;

  NotificationResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<NotificationList>? notificationList;
  int? unReadCount;
  int? pageCount;
  int? documentCount;

  Data(
      {this.notificationList,
      this.unReadCount,
      this.pageCount,
      this.documentCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notificationList'] != null) {
      notificationList = <NotificationList>[];
      json['notificationList'].forEach((v) {
        notificationList!.add(new NotificationList.fromJson(v));
      });
    }
    unReadCount = json['unReadCount'];
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notificationList != null) {
      data['notificationList'] =
          notificationList!.map((v) => v.toJson()).toList();
    }
    data['unReadCount'] = unReadCount;
    data['pageCount'] = pageCount;
    data['documentCount'] = documentCount;
    return data;
  }
}

class NotificationList {
  String? sId;
  CreatedBy? createdBy;
  String? sendTo;
  bool? isRead;
  String? message;
  String? moduleName;
  String? dataReference;
  String? notificationType;
  String? mobileRedirect;
  String? webRedirect;
  String? createdAt;
  String? updatedAt;
  String? notificationImage;
  NotificationData? notificationData;
  int? iV;

  NotificationList(
      {this.sId,
      this.createdBy,
      this.sendTo,
      this.isRead,
      this.message,
      this.moduleName,
      this.dataReference,
      this.notificationType,
      this.mobileRedirect,
      this.webRedirect,
      this.createdAt,
      this.notificationImage,
      this.updatedAt,
      this.notificationData,
      this.iV});

  NotificationList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdBy = json['createdBy'] is Map<String, dynamic>
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    notificationData = json['notificationData'] is Map<String, dynamic>
        ? NotificationData.fromJson(json['notificationData'])
        : null;
    sendTo = json['sendTo'];
    isRead = json['isRead'];
    message = json['message'];
    moduleName = json['moduleName'];
    dataReference = json['dataReference'];
    notificationType = json['notificationType'];
    mobileRedirect = json['mobileRedirect'];
    webRedirect = json['webRedirect'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    notificationImage = json['notificationImage'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['createdBy'] = createdBy;
    data['sendTo'] = sendTo;
    data['isRead'] = isRead;
    data['message'] = message;
    data['moduleName'] = moduleName;
    data['dataReference'] = dataReference;
    data['notificationType'] = notificationType;
    data['mobileRedirect'] = mobileRedirect;
    data['webRedirect'] = webRedirect;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['notificationImage'] = notificationImage;
    data['__v'] = iV;
    return data;
  }
}

class CreatedBy {
  String? sId;
  String? firstName;
  String? lastName;
  String? companyName;

  CreatedBy({
    this.sId,
    this.firstName,
    this.lastName,
    this.companyName,
  });

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['companyName'] = companyName;
    return data;
  }
}

class NotificationData {
  String? imageUrl;
  String? thumbnailImage;
  String? title;
  String? financeOfferId;

  NotificationData({
    this.title,
    this.imageUrl,
    this.thumbnailImage,
    this.financeOfferId,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    imageUrl = json['imageUrl'];
    thumbnailImage = json['thumbnailImage'];
    financeOfferId = json['financeOfferId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    data['thumbnailImage'] = thumbnailImage;
    data['financeOfferId'] = financeOfferId;
    return data;
  }

  String? get effectiveImageUrl {
    if (thumbnailImage != null && thumbnailImage!.isNotEmpty) {
      return thumbnailImage;
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl;
    }
    return "";
  }
}
