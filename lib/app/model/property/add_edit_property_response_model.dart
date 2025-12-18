import 'package:mashrou3/app/model/property/property_detail_response_model.dart';

class AddEditPropertyResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  Data? data;

  AddEditPropertyResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  AddEditPropertyResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? createdBy;
  String? title;
  Price? price;
  String? description;
  String? categoryId;
  String? subCategoryId;
  String? country;
  String? city;
  Area? area;
  ContactNumber? alternateContactNumber;
  ContactNumber? contactNumber;
  List<String>? videoLink;
  List<String>? propertyFiles;
  PropertyLocation? propertyLocation;
  List<NeighborLocation>? neighborLocation;
  List<String>? amenities;
  bool? isDeleted;
  String? virtualTour;
  List<String>? favorites;
  String? rating;
  String? floors;
  String? furnishedType;
  String? bedrooms;
  String? bathrooms;
  String? buildingAge;
  String? facade;
  bool? mortgaged;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.createdBy,
      this.title,
      this.price,
      this.description,
      this.categoryId,
      this.subCategoryId,
      this.country,
      this.city,
      this.area,
      this.alternateContactNumber,
      this.contactNumber,
      this.videoLink,
      this.propertyFiles,
      this.propertyLocation,
      this.neighborLocation,
      this.amenities,
      this.isDeleted,
      this.virtualTour,
      this.favorites,
      this.rating,
      this.floors,
      this.furnishedType,
      this.bedrooms,
      this.bathrooms,
      this.buildingAge,
      this.facade,
      this.mortgaged,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    title = json['title'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    description = json['description'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    country = json['country'];
    city = json['city'];
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    alternateContactNumber = json['alternateContactNumber'] is Map<String,dynamic>? json['alternateContactNumber'] != null
        ? ContactNumber.fromJson(json['alternateContactNumber'])
        : null:json['alternateContactNumber'] ;
    contactNumber = json['contactNumber'] != null
        ? ContactNumber.fromJson(json['contactNumber'])
        : null;
    rating = json['rating'];
    videoLink = (json['videoLink'] as List?)?.cast<String>() ?? [];
    propertyFiles = (json['propertyFiles'] as List?)?.cast<String>() ?? [];
    propertyLocation = json['propertyLocation'] != null
        ? PropertyLocation.fromJson(json['propertyLocation'])
        : null;
    if (json['neighborLocation'] != null) {
      neighborLocation = <NeighborLocation>[];
      json['neighborLocation'].forEach((v) {
        neighborLocation!.add(NeighborLocation.fromJson(v));
      });
    }
    amenities = (json['amenities'] as List?)?.cast<String>() ?? [];
    isDeleted = json['isDeleted'];
    virtualTour = json['virtualTour'];
    favorites = (json['favorites'] as List?)?.cast<String>() ?? [];
    rating = json['rating'];
    floors = json['floors'];
    furnishedType = json['furnishedType'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    buildingAge = json['buildingAge'];
    facade = json['facade'];
    mortgaged = json['mortgaged'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdBy'] = createdBy;
    data['title'] = title;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['description'] = description;
    data['categoryId'] = categoryId;
    data['subCategoryId'] = subCategoryId;
    data['country'] = country;
    data['city'] = city;
    if (area != null) {
      data['area'] = area!.toJson();
    }

    if (contactNumber != null) {
      data['contactNumber'] = contactNumber!.toJson();
    }
    if (alternateContactNumber != null) {
      data['alternateContactNumber'] = alternateContactNumber!.toJson();
    }
    data['videoLink'] = videoLink;
    data['propertyFiles'] = propertyFiles;
    if (propertyLocation != null) {
      data['propertyLocation'] = propertyLocation!.toJson();
    }
    if (neighborLocation != null) {
      data['neighborLocation'] =
          neighborLocation!.map((v) => v.toJson()).toList();
    }
    data['amenities'] = amenities;
    data['isDeleted'] = isDeleted;
    data['virtualTour'] = virtualTour;
    data['favorites'] = favorites;
    data['rating'] = rating;
    data['floors'] = floors;
    data['furnishedType'] = furnishedType;
    data['bedrooms'] = bedrooms;
    data['bathrooms'] = bathrooms;
    data['buildingAge'] = buildingAge;
    data['facade'] = facade;
    data['mortgaged'] = mortgaged;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ContactNumber {
  String? phoneCode;
  String? contactNumber;
  String? emoji;
  String? countryCode;

  ContactNumber(
      {this.phoneCode, this.contactNumber, this.emoji, this.countryCode});

  ContactNumber.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'];
    contactNumber = json['contactNumber'];
    emoji = json['emoji'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneCode'] = phoneCode;
    data['contactNumber'] = contactNumber;
    data['emoji'] = emoji;
    data['countryCode'] = countryCode;
    return data;
  }
}

class NeighborLocation {
  double? latitude;
  double? longitude;
  String? address;
  String? neighborhoodType;

  NeighborLocation(
      {this.latitude, this.longitude, this.address, this.neighborhoodType});

  NeighborLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    neighborhoodType = json['neighborhoodType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['neighborhoodType'] = neighborhoodType;
    return data;
  }
}
