class PropertyListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  PropertyListData? data;

  PropertyListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  PropertyListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? PropertyListData.fromJson(json['data']) : null;
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

class PropertyListData {
  List<PropertyData>? propertyData;
  int? pageCount;
  int? documentCount;
  Support? support;

  PropertyListData({this.propertyData, this.pageCount, this.documentCount});

  PropertyListData.fromJson(Map<String, dynamic> json) {
    if (json['propertyData'] != null) {
      propertyData = <PropertyData>[];
      json['propertyData'].forEach((v) {
        propertyData!.add(PropertyData.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
    support =
        json['support'] != null ? Support.fromJson(json['support']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (propertyData != null) {
      data['propertyData'] = propertyData!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    data['documentCount'] = documentCount;
    if (support != null) {
      data['support'] = support!.toJson();
    }
    return data;
  }
}

class PropertyData {
  String? sId;
  String? createdBy;
  String? title;
  Price? price;
  String? description;
  String? categoryId;
  String? subCategoryId;
  bool? isApproved;
  bool? isActive;
  String? country;
  String? city;
  bool? isDeleted;
  bool? isSoldOut;
  Area? area;
  AlternateContactNumber? alternateContactNumber;
  AlternateContactNumber? contactNumber;
  dynamic rating;
  int? totalRatings;
  dynamic videoLink;
  String? locationKeys;
  List<String>? propertyFiles;
  List<String>? neighborhoodType;
  List<NeighborLocation>? neighborLocation;
  PropertyLocation? propertyLocation;
  List<LivingSpace>? livingSpace;
  List<String>? amenities;
  bool? underConstruction;
  bool? createdByBank;
  String? furnishedType;
  String? floors;
  String? bedrooms;
  String? bathrooms;
  String? buildingAge;
  String? facade;
  bool? mortgaged;
  String? companyName;
  String? companyLogo;
  String? thumbnail;
  String? virtualTour;
  String? shareLink;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<PropertyAmenitiesData>? propertyAmenitiesData;
  FurnishedData? furnishedData;
  List<LivingSpaceData>? livingSpaceData;
  List<NeighbourHoodTypeData>? neighbourHoodTypeData;
  CategoryData? categoryData;
  BuildingAgeData? buildingAgeData;
  bool? favorite;
  bool? isLocked;
  bool? isLockedByMe;
  double? priceAsNumber;
  double? AreaAsNumber;
  String? lowerCaseTitle;
  PropertyOfferData? offerData;
  CreatedByData? createdByData;

  PropertyData(
      {this.sId,
      this.createdBy,
      this.title,
      this.price,
      this.description,
      this.categoryId,
      this.subCategoryId,
      this.isApproved,
      this.isActive,
      this.country,
      this.city,
      this.isDeleted,
      this.isSoldOut,
      this.area,
      this.alternateContactNumber,
      this.contactNumber,
      this.rating,
      this.totalRatings,
      this.videoLink,
      this.locationKeys,
      this.propertyFiles,
      this.neighborhoodType,
      this.neighborLocation,
      this.propertyLocation,
      this.livingSpace,
      this.amenities,
      this.underConstruction,
      this.createdByBank,
      this.furnishedType,
      this.floors,
      this.bedrooms,
      this.bathrooms,
      this.buildingAge,
      this.facade,
      this.mortgaged,
      this.companyName,
      this.companyLogo,
      this.thumbnail,
      this.virtualTour,
      this.shareLink,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.propertyAmenitiesData,
      this.furnishedData,
      this.livingSpaceData,
      this.neighbourHoodTypeData,
      this.categoryData,
      this.buildingAgeData,
      this.favorite,
      this.isLocked,
      this.isLockedByMe,
      this.priceAsNumber,
      this.AreaAsNumber,
      this.lowerCaseTitle,
      this.offerData,
      this.createdByData});

  PropertyData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdBy = json['createdBy'];
    title = json['title'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    description = json['description'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    isApproved = json['isApproved'];
    isActive = json['isActive'];
    country = json['country'];
    city = json['city'];
    isDeleted = json['isDeleted'];
    isSoldOut = json['isSoldOut'];
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    alternateContactNumber = json['alternateContactNumber'] != null
        ? AlternateContactNumber.fromJson(json['alternateContactNumber'])
        : null;
    contactNumber = json['contactNumber'] != null
        ? AlternateContactNumber.fromJson(json['contactNumber'])
        : null;
    rating = json['rating'] is int ? json['rating'].toString() : json['rating'];
    totalRatings = json['totalRatings'] is int ? json['totalRatings'] : (json['totalRatings'] is String ? int.tryParse(json['totalRatings']) : null);
    // Handle videoLink as string or list for backward compatibility
    if (json['videoLink'] != null) {
      if (json['videoLink'] is String) {
        videoLink = json['videoLink'];
      } else if (json['videoLink'] is List) {
        videoLink = (json['videoLink'] as List).cast<String>();
      }
    }
    locationKeys = json['locationKeys'] is String ? json['locationKeys'] : null;
    propertyFiles = (json['propertyFiles'] as List?)?.cast<String>() ?? [];
    neighborhoodType =
        (json['neighborhoodType'] as List?)?.cast<String>() ?? [];
    if (json['neighborLocation'] != null) {
      neighborLocation = <NeighborLocation>[];
      json['neighborLocation'].forEach((v) {
        neighborLocation!.add(NeighborLocation.fromJson(v));
      });
    }
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
    underConstruction = json['underConstruction'];
    createdByBank = json['createdByBank'];
    furnishedType = json['furnishedType'];
    floors = json['floors'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    buildingAge = json['buildingAge'];
    facade = json['facade'];
    mortgaged = json['mortgaged'];
    companyName = json['companyName'];
    companyLogo = json['companyLogo'];
    virtualTour = json['virtualTour'];
    thumbnail = json['thumbnail'];
    shareLink = json['shareLink'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['propertyAmenitiesData'] != null) {
      propertyAmenitiesData = <PropertyAmenitiesData>[];
      json['propertyAmenitiesData'].forEach((v) {
        propertyAmenitiesData!.add(PropertyAmenitiesData.fromJson(v));
      });
    }
    furnishedData = json['furnishedData'] != null
        ? FurnishedData.fromJson(json['furnishedData'])
        : null;
    if (json['livingSpaceData'] != null) {
      livingSpaceData = <LivingSpaceData>[];
      json['livingSpaceData'].forEach((v) {
        livingSpaceData!.add(LivingSpaceData.fromJson(v));
      });
    }
    if (json['neighbourHoodTypeData'] != null) {
      neighbourHoodTypeData = <NeighbourHoodTypeData>[];
      json['neighbourHoodTypeData'].forEach((v) {
        neighbourHoodTypeData!.add(NeighbourHoodTypeData.fromJson(v));
      });
    }
    categoryData = json['categoryData'] != null
        ? CategoryData.fromJson(json['categoryData'])
        : null;
    buildingAgeData = json['buildingAgeData'] != null
        ? BuildingAgeData.fromJson(json['buildingAgeData'])
        : null;
    favorite = json['favorite'];
    isLocked = json['isLocked'];
    isLockedByMe = json['isLockedByMe'];
    priceAsNumber = json['priceAsNumber'] is int 
        ? (json['priceAsNumber'] as int).toDouble() 
        : (json['priceAsNumber'] is double ? json['priceAsNumber'] : null);
    AreaAsNumber = json['AreaAsNumber'] is int 
        ? (json['AreaAsNumber'] as int).toDouble() 
        : (json['AreaAsNumber'] is double ? json['AreaAsNumber'] : null);
    lowerCaseTitle = json['lowerCaseTitle'];
    offerData = json['offerData'] != null
        ? PropertyOfferData.fromJson(json['offerData'])
        : null;
    createdByData = json['createdByData'] != null
        ? CreatedByData.fromJson(json['createdByData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['createdBy'] = createdBy;
    data['title'] = title;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['description'] = description;
    data['categoryId'] = categoryId;
    data['subCategoryId'] = subCategoryId;
    data['isApproved'] = isApproved;
    data['isActive'] = isActive;
    data['country'] = country;
    data['city'] = city;
    data['isDeleted'] = isDeleted;
    data['isSoldOut'] = isSoldOut;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    if (alternateContactNumber != null) {
      data['alternateContactNumber'] = alternateContactNumber!.toJson();
    }
    if (contactNumber != null) {
      data['contactNumber'] = contactNumber!.toJson();
    }
    data['rating'] = rating;
    data['totalRatings'] = totalRatings;
    data['videoLink'] = videoLink;
    data['locationKeys'] = locationKeys;
    data['propertyFiles'] = propertyFiles;
    data['neighborhoodType'] = neighborhoodType;
    if (neighborLocation != null) {
      data['neighborLocation'] = neighborLocation!.map((v) => v.toJson()).toList();
    }
    if (propertyLocation != null) {
      data['propertyLocation'] = propertyLocation!.toJson();
    }
    if (livingSpace != null) {
      data['livingSpace'] = livingSpace!.map((v) => v.toJson()).toList();
    }
    data['amenities'] = amenities;
    data['underConstruction'] = underConstruction;
    data['createdByBank'] = createdByBank;
    data['furnishedType'] = furnishedType;
    data['floors'] = floors;
    data['bedrooms'] = bedrooms;
    data['bathrooms'] = bathrooms;
    data['buildingAge'] = buildingAge;
    data['facade'] = facade;
    data['mortgaged'] = mortgaged;
    data['companyName'] = companyName;
    data['companyLogo'] = companyLogo;
    data['virtualTour'] = virtualTour;
    data['thumbnail'] = thumbnail;
    data['shareLink'] = shareLink;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (propertyAmenitiesData != null) {
      data['propertyAmenitiesData'] =
          propertyAmenitiesData!.map((v) => v.toJson()).toList();
    }
    if (furnishedData != null) {
      data['furnishedData'] = furnishedData!.toJson();
    }
    if (livingSpaceData != null) {
      data['livingSpaceData'] =
          livingSpaceData!.map((v) => v.toJson()).toList();
    }
    if (neighbourHoodTypeData != null) {
      data['neighbourHoodTypeData'] =
          neighbourHoodTypeData!.map((v) => v.toJson()).toList();
    }
    if (categoryData != null) {
      data['categoryData'] = categoryData!.toJson();
    }
    if (buildingAgeData != null) {
      data['buildingAgeData'] = buildingAgeData!.toJson();
    }
    data['favorite'] = favorite;
    data['isLocked'] = isLocked;
    data['isLockedByMe'] = isLockedByMe;
    data['priceAsNumber'] = priceAsNumber;
    data['AreaAsNumber'] = AreaAsNumber;
    data['lowerCaseTitle'] = lowerCaseTitle;
    if (offerData != null) {
      data['offerData'] = offerData!.toJson();
    }
    if (createdByData != null) {
      data['createdByData'] = createdByData!.toJson();
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
    amount = json['amount'].toString();
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

class AlternateContactNumber {
  dynamic phoneCode;
  dynamic contactNumber;
  String? emoji;
  String? countryCode;

  AlternateContactNumber({this.phoneCode, this.contactNumber, this.emoji, this.countryCode});

  AlternateContactNumber.fromJson(Map<String, dynamic> json) {
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

class PropertyLocation {
  double? latitude;
  double? longitude;
  String? address;
  List<double>? coordinates;

  PropertyLocation({this.latitude, this.longitude, this.address, this.coordinates});

  PropertyLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    coordinates = json['coordinates'] != null
        ? (json['coordinates'] as List).map((v) => (v is int ? v.toDouble() : v as double)).toList().cast<double>()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    if (coordinates != null) {
      data['coordinates'] = coordinates;
    }
    return data;
  }
}

class LivingSpace {
  String? livingSpaceId;
  dynamic value;

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

class PropertyAmenitiesData {
  String? sId;
  String? amenityIcon;
  String? name;

  PropertyAmenitiesData({this.sId, this.amenityIcon, this.name});

  PropertyAmenitiesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    amenityIcon = json['amenityIcon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['amenityIcon'] = amenityIcon;
    data['name'] = name;
    return data;
  }
}

class FurnishedData {
  String? sId;
  String? name;

  FurnishedData({this.sId, this.name});

  FurnishedData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class LivingSpaceData {
  LivingSpaceId? livingSpaceId;
  String? value;
  String? sId;

  LivingSpaceData({this.livingSpaceId, this.value, this.sId});

  LivingSpaceData.fromJson(Map<String, dynamic> json) {
    livingSpaceId = json['livingSpaceId'] != null
        ? LivingSpaceId.fromJson(json['livingSpaceId'])
        : null;
    value = json['value'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (livingSpaceId != null) {
      data['livingSpaceId'] = livingSpaceId!.toJson();
    }
    data['value'] = value;
    data['_id'] = sId;
    return data;
  }
}

class LivingSpaceId {
  String? sId;
  String? livingSpaceIcon;
  String? name;

  LivingSpaceId({this.sId, this.livingSpaceIcon, this.name});

  LivingSpaceId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    livingSpaceIcon = json['livingSpaceIcon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['livingSpaceIcon'] = livingSpaceIcon;
    data['name'] = name;
    return data;
  }
}

class NeighbourHoodTypeData {
  NeighborhoodType? neighborhoodType;
  double? longitude;
  double? latitude;
  String? address;
  String? sId;

  NeighbourHoodTypeData(
      {this.neighborhoodType,
      this.longitude,
      this.latitude,
      this.address,
      this.sId});

  NeighbourHoodTypeData.fromJson(Map<String, dynamic> json) {
    neighborhoodType = json['neighborhoodType'] != null
        ? NeighborhoodType.fromJson(json['neighborhoodType'])
        : null;
    longitude = json['longitude'];
    latitude = json['latitude'];
    address = json['address'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (neighborhoodType != null) {
      data['neighborhoodType'] = neighborhoodType!.toJson();
    }
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['address'] = address;
    data['_id'] = sId;
    return data;
  }
}

class NeighborhoodType {
  String? sId;
  String? neighbourHoodIcon;
  String? name;

  NeighborhoodType({this.sId, this.neighbourHoodIcon, this.name});

  NeighborhoodType.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    neighbourHoodIcon = json['neighbourHoodIcon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['neighbourHoodIcon'] = neighbourHoodIcon;
    data['name'] = name;
    return data;
  }
}

class CategoryData {
  String? sId;
  String? name;

  CategoryData({this.sId, this.name});

  CategoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class CreatedByData {
  String? firstName;
  String? lastName;
  String? createdAt;
  String? companyLogo;

  CreatedByData(
      {this.firstName, this.lastName, this.createdAt, this.companyLogo});

  CreatedByData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    createdAt = json['createdAt'];
    companyLogo = json['companyLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['createdAt'] = createdAt;
    data['companyLogo'] = companyLogo;
    return data;
  }
}

class NeighborLocation {
  double? latitude;
  double? longitude;
  String? address;
  String? neighborhoodType;

  NeighborLocation({this.latitude, this.longitude, this.address, this.neighborhoodType});

  NeighborLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] is int ? (json['latitude'] as int).toDouble() : json['latitude'];
    longitude = json['longitude'] is int ? (json['longitude'] as int).toDouble() : json['longitude'];
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

class BuildingAgeData {
  String? sId;
  LocalizedName? name;

  BuildingAgeData({this.sId, this.name});

  BuildingAgeData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? LocalizedName.fromJson(json['name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (name != null) {
      data['name'] = name!.toJson();
    }
    return data;
  }
}

class LocalizedName {
  String? en;
  String? ar;

  LocalizedName({this.en, this.ar});

  LocalizedName.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['ar'] = ar;
    return data;
  }
}

class PropertyOfferData {
  String? sId;
  List<String>? offersIds;
  String? propertyId;
  String? vendorId;
  String? vendorCategoryId;
  String? offerType;
  String? status;
  PropertyOfferPropertiesData? propertiesData;
  PropertyOfferFinalSum? finalSum;
  bool? isAllProperties;
  List<String>? excludedPropertyIds;
  int? iV;
  String? createdAt;
  String? updatedAt;

  PropertyOfferData({
    this.sId,
    this.offersIds,
    this.propertyId,
    this.vendorId,
    this.vendorCategoryId,
    this.offerType,
    this.status,
    this.propertiesData,
    this.finalSum,
    this.isAllProperties,
    this.excludedPropertyIds,
    this.iV,
    this.createdAt,
    this.updatedAt,
  });

  PropertyOfferData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    offersIds = json['offersIds'] != null ? List<String>.from(json['offersIds']) : null;
    propertyId = json['propertyId'];
    vendorId = json['vendorId'];
    vendorCategoryId = json['vendorCategoryId'];
    offerType = json['offerType'];
    status = json['status'];
    propertiesData = json['propertiesData'] != null
        ? PropertyOfferPropertiesData.fromJson(json['propertiesData'])
        : null;
    finalSum = json['finalSum'] != null
        ? PropertyOfferFinalSum.fromJson(json['finalSum'])
        : null;
    isAllProperties = json['isAllProperties'];
    excludedPropertyIds = json['excludedPropertyIds'] != null
        ? List<String>.from(json['excludedPropertyIds'])
        : null;
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['offersIds'] = offersIds;
    data['propertyId'] = propertyId;
    data['vendorId'] = vendorId;
    data['vendorCategoryId'] = vendorCategoryId;
    data['offerType'] = offerType;
    data['status'] = status;
    if (propertiesData != null) {
      data['propertiesData'] = propertiesData!.toJson();
    }
    if (finalSum != null) {
      data['finalSum'] = finalSum!.toJson();
    }
    data['isAllProperties'] = isAllProperties;
    data['excludedPropertyIds'] = excludedPropertyIds;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PropertyOfferPropertiesData {
  String? propertyId;
  double? pricing;
  PropertyOfferRate? timedRate;
  PropertyOfferRate? lifetimeRate;
  double? originalAmount;
  bool? isAllProperty;
  String? sId;

  PropertyOfferPropertiesData({
    this.propertyId,
    this.pricing,
    this.timedRate,
    this.lifetimeRate,
    this.originalAmount,
    this.isAllProperty,
    this.sId,
  });

  PropertyOfferPropertiesData.fromJson(Map<String, dynamic> json) {
    propertyId = json['propertyId'];
    pricing = json['pricing'] is int ? (json['pricing'] as int).toDouble() : json['pricing'];
    timedRate = json['timed_rate'] != null
        ? PropertyOfferRate.fromJson(json['timed_rate'])
        : null;
    lifetimeRate = json['lifetime_rate'] != null
        ? PropertyOfferRate.fromJson(json['lifetime_rate'])
        : null;
    originalAmount = json['originalAmount'] is int
        ? (json['originalAmount'] as int).toDouble()
        : json['originalAmount'];
    isAllProperty = json['isAllProperty'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = propertyId;
    data['pricing'] = pricing;
    if (timedRate != null) {
      data['timed_rate'] = timedRate!.toJson();
    }
    if (lifetimeRate != null) {
      data['lifetime_rate'] = lifetimeRate!.toJson();
    }
    data['originalAmount'] = originalAmount;
    data['isAllProperty'] = isAllProperty;
    data['_id'] = sId;
    return data;
  }
}

class PropertyOfferRate {
  String? amount;
  String? currencyCode;
  String? currencySymbol;

  PropertyOfferRate({this.amount, this.currencyCode, this.currencySymbol});

  PropertyOfferRate.fromJson(Map<String, dynamic> json) {
    amount = json['amount']?.toString();
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

class PropertyOfferFinalSum {
  dynamic amount;
  String? currencyCode;
  String? currencySymbol;
  String? sId;

  PropertyOfferFinalSum({this.amount, this.currencyCode, this.currencySymbol, this.sId});

  PropertyOfferFinalSum.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] is int ? (json['amount'] as int).toDouble() : json['amount'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    data['_id'] = sId;
    return data;
  }
}

class Support {
  String? email;
  String? phone;
  License? license;

  Support({this.email, this.phone, this.license});

  Support.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    license =
        json['license'] != null ? License.fromJson(json['license']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    if (license != null) {
      data['license'] = license!.toJson();
    }
    return data;
  }
}

class License {
  String? url;

  License({this.url});

  License.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}
