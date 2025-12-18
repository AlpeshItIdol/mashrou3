import '../../../../model/property/property_detail_response_model.dart';

class RecentlyVisitedListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  RecentlyVisitedList? data;

  RecentlyVisitedListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  RecentlyVisitedListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? RecentlyVisitedList.fromJson(json['data'])
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

class RecentlyVisitedList {
  List<PropertyDetailData>? recentViewedData;
  int? pageCount;
  int? documentCount;

  RecentlyVisitedList(
      {this.recentViewedData, this.pageCount, this.documentCount});

  RecentlyVisitedList.fromJson(Map<String, dynamic> json) {
    if (json['recentViewedData'] != null) {
      recentViewedData = <PropertyDetailData>[];
      json['recentViewedData'].forEach((v) {
        recentViewedData!.add(new PropertyDetailData.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recentViewedData != null) {
      data['recentViewedData'] =
          this.recentViewedData!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = this.pageCount;
    data['documentCount'] = this.documentCount;
    return data;
  }
}
