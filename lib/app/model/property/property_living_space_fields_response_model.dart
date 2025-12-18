import 'package:mashrou3/app/model/property/property_detail_response_model.dart';

class PropertyLivingSpaceFieldsResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<CategoryData>? data;

  PropertyLivingSpaceFieldsResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  PropertyLivingSpaceFieldsResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
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

