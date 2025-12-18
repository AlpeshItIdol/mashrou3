import '../../../../model/property/property_detail_response_model.dart';

class PropertiesWithOffersListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  PropertiesWithOffersData? data;

  PropertiesWithOffersListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  PropertiesWithOffersListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? new PropertiesWithOffersData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PropertiesWithOffersData {
  List<PropertyDetailData>? offerAppliedProperty;
  int? pageCount;
  int? documentCount;

  PropertiesWithOffersData(
      {this.offerAppliedProperty, this.pageCount, this.documentCount});

  PropertiesWithOffersData.fromJson(Map<String, dynamic> json) {
    if (json['offerAppliedProperty'] != null) {
      offerAppliedProperty = <PropertyDetailData>[];
      json['offerAppliedProperty'].forEach((v) {
        offerAppliedProperty!.add(new PropertyDetailData.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.offerAppliedProperty != null) {
      data['offerAppliedProperty'] =
          this.offerAppliedProperty!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = this.pageCount;
    data['documentCount'] = this.documentCount;
    return data;
  }
}
