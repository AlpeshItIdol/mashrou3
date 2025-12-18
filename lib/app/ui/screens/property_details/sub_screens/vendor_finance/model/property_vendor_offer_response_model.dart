import 'package:mashrou3/app/model/offers/my_offers_list_response_model.dart';

class PropertyVendorOfferResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<OfferData>? data;

  PropertyVendorOfferResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  PropertyVendorOfferResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OfferData>[];
      json['data'].forEach((v) {
        data!.add(OfferData.fromJson(v));
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
