import 'package:mashrou3/app/model/property/property_category_response_model.dart';

class InReviewListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  InReviewListData? data;

  InReviewListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  InReviewListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? InReviewListData.fromJson(json['data']) : null;
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

class InReviewListData {
  List<PropertyReqData>? propertyReqData;
  int? pageCount;
  int? documentCount;

  InReviewListData({this.propertyReqData, this.pageCount, this.documentCount});

  InReviewListData.fromJson(Map<String, dynamic> json) {
    if (json['propertyReqData'] != null) {
      propertyReqData = <PropertyReqData>[];
      json['propertyReqData'].forEach((v) {
        propertyReqData!.add(PropertyReqData.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (propertyReqData != null) {
      data['propertyReqData'] =
          propertyReqData!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    data['documentCount'] = documentCount;
    return data;
  }
}

class PropertyReqData {
  String? sId;
  String? propertyId;
  String? createdBy;
  String? reqStatus;
  String? title;
  Price? price;
  String? categoryId;
  String? country;
  String? city;
  Area? area;
  ContactNumber? contactNumber;
  List<String>? videoLinks;
  List<String>? propertyFiles;
  PropertyLocation? propertyLocation;
  bool? underConstruction;
  String? furnishedType;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;
  PropertyCategoryData? categoryData;

  PropertyReqData(
      {this.sId,
      this.propertyId,
      this.createdBy,
      this.reqStatus,
      this.title,
      this.price,
      this.categoryId,
      this.country,
      this.city,
      this.area,
      this.contactNumber,
      this.videoLinks,
      this.propertyFiles,
      this.thumbnail,
      this.propertyLocation,
      this.underConstruction,
      this.furnishedType,
      this.createdAt,
      this.updatedAt,
      this.categoryData});

  PropertyReqData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    propertyId = json['propertyId'];
    createdBy = json['createdBy'];
    reqStatus = json['reqStatus'];
    title = json['title'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    categoryId = json['categoryId'];
    country = json['country'];
    city = json['city'];
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    contactNumber = json['contactNumber'] != null
        ? ContactNumber.fromJson(json['contactNumber'])
        : null;
    videoLinks = (json['videoLinks'] as List?)?.cast<String>() ?? [];
    propertyFiles = (json['propertyFiles'] as List?)?.cast<String>() ?? [];
    propertyLocation = json['propertyLocation'] != null
        ? PropertyLocation.fromJson(json['propertyLocation'])
        : null;
    underConstruction = json['underConstruction'];
    thumbnail = json['thumbnail'];
    furnishedType = json['furnishedType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    categoryData = json['categoryData'] != null
        ? PropertyCategoryData.fromJson(json['categoryData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['propertyId'] = propertyId;
    data['createdBy'] = createdBy;
    data['reqStatus'] = reqStatus;
    data['title'] = title;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['categoryId'] = categoryId;
    data['country'] = country;
    data['city'] = city;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    if (contactNumber != null) {
      data['contactNumber'] = contactNumber!.toJson();
    }
    data['videoLinks'] = videoLinks;
    data['thumbnail'] = thumbnail;
    data['propertyFiles'] = propertyFiles;
    if (propertyLocation != null) {
      data['propertyLocation'] = propertyLocation!.toJson();
    }
    data['underConstruction'] = underConstruction;
    data['furnishedType'] = furnishedType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (categoryData != null) {
      data['categoryData'] = categoryData!.toJson();
    }
    return data;
  }
}

class Price {
  dynamic amount;
  String? currencyCode;
  String? currencySymbol;

  Price({this.amount, this.currencyCode, this.currencySymbol});

  Price.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    return data;
  }
}

class Area {
  String? unit;
  dynamic amount;

  Area({this.unit, this.amount});

  Area.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit'] = unit;
    data['amount'] = amount;
    return data;
  }
}

class ContactNumber {
  String? phoneCode;
  String? contactNumber;
  String? emoji;

  ContactNumber({this.phoneCode, this.contactNumber, this.emoji});

  ContactNumber.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'];
    contactNumber = json['contactNumber'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneCode'] = phoneCode;
    data['contactNumber'] = contactNumber;
    data['emoji'] = emoji;
    return data;
  }
}

class PropertyLocation {
  double? latitude;
  double? longitude;
  String? address;

  PropertyLocation({this.latitude, this.longitude, this.address});

  PropertyLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    return data;
  }
}
