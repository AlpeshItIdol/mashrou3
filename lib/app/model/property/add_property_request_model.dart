import 'package:mashrou3/app/model/contact_number_model.dart';
import 'package:mashrou3/app/model/property/property_detail_response_model.dart';

class AddPropertyRequestModel {
  String? title;
  Price? price;
  String? description;
  String? categoryId;
  String? country;
  String? city;
  Area? area;
  int? furnishedType;
  bool? underConstruction;
  String? virtualTour;
  ContactNumberModel? contactNumber;
  ContactNumberModel? alternateContactNumber;
  List<String>? videoLink;
  List<String>? propertyFiles;
  List<String>? neighborhoodType;
  PropertyLocation? propertyLocation;
  List<LivingSpace>? livingSpace;
  List<String>? amenities;

  AddPropertyRequestModel(
      {this.title,
      this.price,
      this.description,
      this.categoryId,
      this.country,
      this.city,
      this.area,
      this.furnishedType,
      this.underConstruction,
      this.virtualTour,
      this.contactNumber,
      this.alternateContactNumber,
      this.videoLink,
      this.propertyFiles,
      this.neighborhoodType,
      this.propertyLocation,
      this.livingSpace,
      this.amenities});

  AddPropertyRequestModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    description = json['description'];
    categoryId = json['categoryId'];
    country = json['country'];
    city = json['city'];
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    furnishedType = json['furnishedType'];
    underConstruction = json['underConstruction'];
    virtualTour = json['virtualTour'];
    contactNumber = json['contactNumber'] != null
        ? ContactNumberModel.fromJson(json['contactNumber'])
        : null;
    alternateContactNumber = json['alternateContactNumber'] != null
        ? ContactNumberModel.fromJson(json['alternateContactNumber'])
        : null;
    videoLink = (json['videoLink'] as List?)?.cast<String>() ?? [];
    propertyFiles = (json['propertyFiles'] as List?)?.cast<String>() ?? [];
    neighborhoodType = (json['neighborhoodType'] as List?)?.cast<String>() ?? [];
    propertyLocation = json['propertyLocation'] != null
        ? PropertyLocation.fromJson(json['propertyLocation'])
        : null;
    if (json['livingSpace'] != null) {
      livingSpace = <LivingSpace>[];
      json['livingSpace'].forEach((v) {
        livingSpace!.add(LivingSpace.fromJson(v));
      });
    }
      amenities = (json['amenities'] as List?)?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['description'] = description;
    data['categoryId'] = categoryId;
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
    data['furnishedType'] = furnishedType;
    data['underConstruction'] = underConstruction;
    data['virtualTour'] = virtualTour;
    data['propertyFiles'] = propertyFiles;
    data['neighborhoodType'] = neighborhoodType;
    if (propertyLocation != null) {
      data['propertyLocation'] = propertyLocation!.toJson();
    }
    if (livingSpace != null) {
      data['livingSpace'] = livingSpace!.map((v) => v.toJson()).toList();
    }
    data['amenities'] = amenities;
    return data;
  }
}

class Country {
  String? countryId;
  String? countryName;

  Country({this.countryId, this.countryName});

  Country.fromJson(Map<String, dynamic> json) {
    countryId = json['countryId'];
    countryName = json['countryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryId'] = countryId;
    data['countryName'] = countryName;
    return data;
  }
}

class City {
  String? cityId;
  String? cityName;

  City({this.cityId, this.cityName});

  City.fromJson(Map<String, dynamic> json) {
    cityId = json['cityId'];
    cityName = json['cityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    return data;
  }
}

class LivingSpace {
  String? livingSpaceId;
  String? value;

  LivingSpace({this.livingSpaceId, this.value});

  LivingSpace.fromJson(Map<String, dynamic> json) {
    livingSpaceId = json['livingSpaceId'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['livingSpaceId'] = livingSpaceId;
    data['value'] = value;
    return data;
  }
}
