import 'package:mashrou3/utils/string_utils.dart';

class AddressLocationResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  AddressLocationData? data;

  AddressLocationResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory AddressLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressLocationResponseModel(
      statusCode: json['statusCode'] as int?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? AddressLocationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class AddressLocationData {
  List<AddressLocationItem>? locationData;
  int? pageCount;
  int? documentCount;
  int? page;

  AddressLocationData({
    this.locationData,
    this.pageCount,
    this.documentCount,
    this.page,
  });

  factory AddressLocationData.fromJson(Map<String, dynamic> json) {
    return AddressLocationData(
      locationData: (json['locationData'] as List<dynamic>?)
          ?.map((item) =>
              AddressLocationItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      pageCount: json['pageCount'] as int?,
      documentCount: json['documentCount'] as int?,
      page: json['page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationData': locationData?.map((item) => item.toJson()).toList(),
      'pageCount': pageCount,
      'documentCount': documentCount,
      'page': page,
    };
  }
}

class AddressLocationItem {
  String? sId;
  /// Raw API value: can be a plain String or a multilingual map {"en": "...", "ar": "..."}.
  /// Use [text] getter for display (resolved to current app language with fallbacks).
  dynamic textRaw;
  String? status;
  String? userId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? v;

  /// Display text resolved for the current app language (with fallback to en, then ar).
  String? get text => StringUtils.getLocalizedValue(textRaw);

  AddressLocationItem({
    this.sId,
    dynamic text,
    this.status,
    this.userId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  }) : textRaw = text;

  factory AddressLocationItem.fromJson(Map<String, dynamic> json) {
    return AddressLocationItem(
      sId: json['_id'] as String?,
      text: json['text'],
      status: json['status'] as String?,
      userId: json['userId'] as String?,
      deletedAt: json['deletedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'text': textRaw,
      'status': status,
      'userId': userId,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

