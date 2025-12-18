import 'package:mashrou3/config/utils.dart';

class FilterRequestModel {
  String? category;
  String? isSoldOut;
  String? isSold;
  String? nearest;
  String? farthest;
  String? longitude;
  String? latitude;
  String? selectRadius;
  String? underConstruction;
  String? leasingCompany;
  String? furnished;
  String? virtualTour;
  String? country;
  String? city;
  String? currencyCode;
  List<String>? neighborhood;
  List<String>? locationKeys;
  List<String>? subCategoryId;
  List<String>? floors;
  List<String>? bedrooms;
  List<String>? bathrooms;
  List<String>? amenities;
  List<String>? facade;
  List<String>? furnishedType;
  List<String>? buildingAge;
  List<String>? mortgaged;
  MinMaxModel? price;
  MinMaxModel? area;

  FilterRequestModel(
      {this.category,
      this.isSoldOut,
      this.isSold,
      this.nearest,
      this.farthest,
      this.longitude,
      this.latitude,
      this.selectRadius,
      this.underConstruction,
      this.leasingCompany,
      this.furnished,
      this.virtualTour,
      this.country,
      this.city,
      this.currencyCode,
      this.neighborhood,
      this.locationKeys,
      this.subCategoryId,
      this.floors,
      this.bedrooms,
      this.bathrooms,
      this.amenities,
      this.facade,
      this.furnishedType,
      this.buildingAge,
      this.mortgaged,
      this.price,
      this.area});

  FilterRequestModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    isSoldOut = json['isSoldOut'];
    isSold = json['isSold'];
    nearest = json['nearest'];
    farthest = json['farthest'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    selectRadius = json['selectRadius'];
    underConstruction = json['underConstruction'];
    leasingCompany = json['createdByBank'];
    furnished = json['furnished'];
    virtualTour = json['virtualTour'];
    country = json['country'];
    city = json['city'];
    currencyCode = json['currencyCode'];
    if (json['neighborhood'] != null) {
      neighborhood = List<String>.from(json['neighborhood']);
    }
    if (json['locationKeys'] != null) {
      locationKeys = List<String>.from(json['locationKeys']);
    }
    if (json['subCategoryId'] != null) {
      subCategoryId = List<String>.from(json['subCategoryId']);
    }
    if (json['floors'] != null) {
      floors = List<String>.from(json['floors']);
    }
    if (json['bedrooms'] != null) {
      bedrooms = List<String>.from(json['bedrooms']);
    }
    if (json['bathrooms'] != null) {
      bathrooms = List<String>.from(json['bathrooms']);
    }
    if (json['amenities'] != null) {
      amenities = List<String>.from(json['amenities']);
    }
    if (json['facade'] != null) {
      facade = List<String>.from(json['facade']);
    }
    if (json['furnishedType'] != null) {
      furnishedType = List<String>.from(json['furnishedType']);
    }
    if (json['buildingAge'] != null) {
      buildingAge = List<String>.from(json['buildingAge']);
    }
    if (json['mortgaged'] != null) {
      mortgaged = List<String>.from(json['mortgaged']);
    }
    price = json['price'] != null ? MinMaxModel.fromJson(json['price']) : null;
    area = json['area'] != null ? MinMaxModel.fromJson(json['area']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (category != null && category!.trim().isNotEmpty) {
      data['category'] = category;
      printf("toJson: Adding category to data: $category");
    } else {
      printf("toJson: Category not added - category is null or empty. Value: $category");
    }
    if (isSoldOut != null) data['isSoldOut'] = isSoldOut;
    if (isSold != null) data['isSold'] = isSold;
    if (nearest != null) data['nearest'] = nearest;
    if (farthest != null) data['farthest'] = farthest;
    if (longitude != null) data['longitude'] = longitude;
    if (latitude != null) data['latitude'] = latitude;
    if (selectRadius != null) data['selectRadius'] = selectRadius;
    if (underConstruction != null) {
      data['underConstruction'] = underConstruction;
    }
    if (furnished != null) data['furnished'] = furnished;
    if (leasingCompany != null) data['createdByBank'] = leasingCompany;
    if (virtualTour != null) data['virtualTour'] = virtualTour;
    if (country != null) data['country'] = country;
    if (city != null) data['city'] = city;
    if (currencyCode != null) data['currencyCode'] = currencyCode;
    if (neighborhood != null && neighborhood!.isNotEmpty) {
      data['neighborhood'] = neighborhood;
    }
    if (locationKeys != null && locationKeys!.isNotEmpty) {
      data['locationKeys'] = locationKeys;
    }
    if (subCategoryId != null && subCategoryId!.isNotEmpty) {
      data['subCategoryId'] = subCategoryId;
    }
    if (floors != null && floors!.isNotEmpty) {
      data['floors'] = floors;
    }
    if (bedrooms != null && bedrooms!.isNotEmpty) {
      data['bedrooms'] = bedrooms;
    }
    if (bathrooms != null && bathrooms!.isNotEmpty) {
      data['bathrooms'] = bathrooms;
    }
    if (amenities != null && amenities!.isNotEmpty) {
      data['amenities'] = amenities;
    }
    if (facade != null && facade!.isNotEmpty) {
      data['facade'] = facade;
    }
    if (furnishedType != null && furnishedType!.isNotEmpty) {
      data['furnishedType'] = furnishedType;
    }
    if (buildingAge != null && buildingAge!.isNotEmpty) {
      data['buildingAge'] = buildingAge;
    }
    if (mortgaged != null && mortgaged!.isNotEmpty) {
      data['mortgaged'] = mortgaged;
    }
    if (price != null) data['price'] = price!.toJson();
    if (area != null) data['area'] = area!.toJson();

    return data;
  }

  bool isEmpty() {
    return category == null &&
        isSoldOut == null &&
        isSold == null &&
        nearest == null &&
        farthest == null &&
        longitude == null &&
        latitude == null &&
        selectRadius == null &&
        underConstruction == null &&
        leasingCompany == null &&
        furnished == null &&
        virtualTour == null &&
        country == null &&
        city == null &&
        currencyCode == null &&
        (neighborhood == null || neighborhood!.isEmpty) &&
        (locationKeys == null || locationKeys!.isEmpty) &&
        (subCategoryId == null || subCategoryId!.isEmpty) &&
        (floors == null || floors!.isEmpty) &&
        (bedrooms == null || bedrooms!.isEmpty) &&
        (bathrooms == null || bathrooms!.isEmpty) &&
        (amenities == null || amenities!.isEmpty) &&
        (facade == null || facade!.isEmpty) &&
        (furnishedType == null || furnishedType!.isEmpty) &&
        (buildingAge == null || buildingAge!.isEmpty) &&
        (mortgaged == null || mortgaged!.isEmpty) &&
        (price == null || price!.isEmpty()) &&
        (area == null || area!.isEmpty());
  }
}

class MinMaxModel {
  String? min;
  String? max;

  MinMaxModel({this.min, this.max});

  MinMaxModel.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    return data;
  }

  bool isEmpty() {
    return min == null && max == null;
  }
}
