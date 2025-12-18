import 'package:mashrou3/app/model/offers/my_offers_list_response_model.dart';

class OfferDetailDataResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  OfferData? data;

  OfferDetailDataResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  OfferDetailDataResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? OfferData.fromJson(json['data']) : null;
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
