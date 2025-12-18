import 'package:mashrou3/app/model/property/property_detail_response_model.dart';

class PropertyAmenitiesResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<PropertyAmenitiesData>? data;

  PropertyAmenitiesResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory PropertyAmenitiesResponseModel.fromJson(Map<String, dynamic> json) {
    return PropertyAmenitiesResponseModel(
      statusCode: json['statusCode'] as int?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) =>
          PropertyAmenitiesData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

