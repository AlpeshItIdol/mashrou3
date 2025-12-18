import 'package:mashrou3/app/model/property/property_detail_response_model.dart';

class PropertyReviewDetailResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  PropertyReviewDetailData? data;

  PropertyReviewDetailResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  PropertyReviewDetailResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? PropertyReviewDetailData.fromJson(json['data'])
        : null;
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

class PropertyReviewDetailData {
  String? sId;
  String? propertyId;
  String? createdBy;
  String? reqModuleType;
  String? reqEditType;
  bool? isResponded;
  bool? isDeleted;
  String? sendTo;
  PropertyDetailData? propertyEditedData;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PropertyReviewDetailData(
      {this.sId,
      this.propertyId,
      this.createdBy,
      this.reqModuleType,
      this.reqEditType,
      this.isResponded,
      this.isDeleted,
      this.sendTo,
      this.propertyEditedData,
      this.createdAt,
      this.updatedAt,
      this.iV});

  PropertyReviewDetailData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    propertyId = json['propertyId'];
    createdBy = json['createdBy'];
    reqModuleType = json['reqModuleType'];
    reqEditType = json['reqEditType'];
    isResponded = json['isResponded'];
    isDeleted = json['isDeleted'];
    sendTo = json['sendTo'];
    propertyEditedData = json['propertyEditedData'] != null
        ? PropertyDetailData.fromJson(json['propertyEditedData'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['propertyId'] = propertyId;
    data['createdBy'] = createdBy;
    data['reqModuleType'] = reqModuleType;
    data['reqEditType'] = reqEditType;
    data['isResponded'] = isResponded;
    data['isDeleted'] = isDeleted;
    data['sendTo'] = sendTo;
    if (propertyEditedData != null) {
      data['propertyEditedData'] = propertyEditedData!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
