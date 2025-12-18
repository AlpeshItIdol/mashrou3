import 'package:mashrou3/app/model/property/property_category_response_model.dart';

class FurnishedStatusResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<PropertyCategoryData>? data;

  FurnishedStatusResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  FurnishedStatusResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PropertyCategoryData>[];
      json['data'].forEach((v) {
        data!.add(PropertyCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}