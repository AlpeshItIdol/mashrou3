import '../property/property_detail_response_model.dart';

class MyOffersListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  MyOffersData? data;

  MyOffersListResponseModel({this.statusCode, this.success, this.message, this.data});

  MyOffersListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? MyOffersData.fromJson(json['data']) : null;
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

class SingleOfferResponse {
  int? statusCode;
  bool? success;
  String? message;
  OfferData? data;

  SingleOfferResponse({this.statusCode, this.success, this.message, this.data});

  SingleOfferResponse.fromJson(Map<String, dynamic> json) {
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

class MyOffersData {
  List<OfferData>? offerData;
  int? pageCount;
  int? documentCount;

  MyOffersData({this.offerData, this.pageCount, this.documentCount});

  MyOffersData.fromJson(Map<String, dynamic> json) {
    if (json['offerData'] != null) {
      offerData = <OfferData>[];
      json['offerData'].forEach((v) {
        offerData!.add(OfferData.fromJson(v));
      });
    }
    if (json['offerReqData'] != null) {
      offerData = <OfferData>[];
      json['offerReqData'].forEach((v) {
        offerData!.add(OfferData.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (offerData != null) {
      data['offerData'] = offerData!.map((v) => v.toJson()).toList();
      data['offerReqData'] = offerData!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    data['documentCount'] = documentCount;
    return data;
  }
}

class OfferData {
  String? sId;
  Price? price;
  String? title;
  String? arTitle;
  String? description;
  String? arDescription;
  bool? isDeleted;
  List<String>? documents;
  String? vendorId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isResponded;
  String? reqStatus;
  String? reqDenyReasons;
  String? companyLogo;

  OfferData({
    this.sId,
    this.price,
    this.title,
    this.arTitle,
    this.description,
    this.arDescription,
    this.isDeleted,
    this.documents,
    this.vendorId,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.isResponded,
    this.reqStatus,
    this.reqDenyReasons,
    this.companyLogo,
  });

  OfferData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    title = json['title'];
    arTitle = json['arTitle'];
    description = json['description'];
    arDescription = json['arDescription'];
    isDeleted = json['isDeleted'];
    documents =
        json['documents'] != null ? List<String>.from(json['documents']) : null;
    vendorId = json['vendorId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isResponded = json['isResponded'];
    reqStatus = json['reqStatus'];
    companyLogo = json['companyLogo'];
    reqDenyReasons = json['reqDenyReasons'];
  }
  // OfferData.fromJson(Map<String, dynamic> json) {
  //   sId = json['_id'];
  //   price = json['price'] != null ? Price.fromJson(json['price']) : null;
  //   title = json['title']?['en'] ?? ( json['title'] ?? '' );// json['title'] != null ? json['title']['en'] ?? '' : '';//json['title'];
  //   arTitle = json['title']?['ar'] ?? ( json['title'] ?? '' );//json['arTitle'];
  //   description = json['description']?['en'] ?? ( json['description'] ?? '' );//json['description'] != null ? json['description']['en'] ?? '' : '';//json['description'];
  //   arDescription =json['description']?['ar'] ?? ( json['description'] ?? '' );// json['arDescription'];
  //   isDeleted = json['isDeleted'];
  //   documents =
  //   json['documents'] != null ? List<String>.from(json['documents']) : null;
  //   vendorId = json['vendorId'] ?? null;
  //   createdAt = json['createdAt'] ?? null;
  //   updatedAt = json['updatedAt'] ?? null;
  //   iV = json['__v'] ?? null;
  //   isResponded = json['isResponded'] ?? null;
  //   reqStatus = json['reqStatus'] ?? null;
  //   companyLogo = json['companyLogo'] ?? null;
  //   reqDenyReasons = json['reqDenyReasons'] ?? null;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['title'] = title;
    data['arTitle'] = arTitle;
    data['description'] = description;
    data['arDescription'] = arDescription;
    data['isDeleted'] = isDeleted;
    data['documents'] = documents;
    data['vendorId'] = vendorId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['isResponded'] = isResponded;
    data['reqStatus'] = reqStatus;
    data['companyLogo'] = companyLogo;
    data['reqDenyReasons'] = reqDenyReasons;
    return data;
  }
}
