import 'property_detail_response_model.dart';

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
      pageCount = json['pageCount'];
      documentCount = json['documentCount'];
      support =
          json['support'] != null ? Support.fromJson(json['support']) : null;
    }
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
  bool? isApproved;
  String? country;
  String? city;
  bool? isDeleted;
  bool? isSoldOut;
  Area? area;
  AlternateContactNumber? alternateContactNumber;
  AlternateContactNumber? contactNumber;
  dynamic rating;
  List<String>? videoLink;
  List<String>? propertyFiles;
  List<String>? neighborhoodType;
  PropertyLocation? propertyLocation;
  List<LivingSpace>? livingSpace;
  List<String>? amenities;
  bool? underConstruction;
  bool? createdByBank;
  String? furnishedType;
  String? thumbnail;
  String? virtualTour;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<PropertyAmenitiesData>? propertyAmenitiesData;
  FurnishedData? furnishedData;
  List<LivingSpaceData>? livingSpaceData;
  List<NeighbourHoodTypeData>? neighbourHoodTypeData;
  CategoryData? categoryData;
  bool? favorite;
  CreatedByData? createdByData;
  bool? isLocked;
  String? lockExpiresAt;
  String? lockOwnerId;
  bool? isLockedByMe;
  PropertyOfferData? offerData;

  PropertyData(
      {this.sId,
      this.createdBy,
      this.title,
      this.price,
      this.description,
      this.categoryId,
      this.isApproved,
      this.country,
      this.city,
      this.isDeleted,
      this.isSoldOut,
      this.area,
      this.alternateContactNumber,
      this.contactNumber,
      this.rating,
      this.videoLink,
      this.propertyFiles,
      this.neighborhoodType,
      this.propertyLocation,
      this.livingSpace,
      this.amenities,
      this.underConstruction,
      this.createdByBank,
      this.furnishedType,
      this.thumbnail,
      this.virtualTour,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.propertyAmenitiesData,
      this.furnishedData,
      this.livingSpaceData,
      this.neighbourHoodTypeData,
      this.categoryData,
      this.favorite,
      this.createdByData,
      this.isLocked,
      this.lockExpiresAt,
      this.lockOwnerId,
      this.isLockedByMe,
      this.offerData});

  PropertyData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdBy = json['createdBy'];
    title = json['title'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    description = json['description'];
    categoryId = json['categoryId'];
    isApproved = json['isApproved'];
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
    videoLink = (json['videoLink'] as List?)?.cast<String>() ?? [];
    propertyFiles = (json['propertyFiles'] as List?)?.cast<String>() ?? [];
    neighborhoodType =
        (json['neighborhoodType'] as List?)?.cast<String>() ?? [];
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
    virtualTour = json['virtualTour'];
    thumbnail = json['thumbnail'];
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
    favorite = json['favorite'];
    createdByData = json['createdByData'] != null
        ? CreatedByData.fromJson(json['createdByData'])
        : null;
    isLocked = json['isLocked'] ?? json['is_locked'];
    lockExpiresAt = json['lock_expires_at'];
    lockOwnerId = json['lock_owner_id'];
    isLockedByMe = json['isLockedByMe'];
    offerData = json['offerData'] != null
        ? PropertyOfferData.fromJson(json['offerData'])
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
    data['isApproved'] = isApproved;
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
    data['videoLink'] = videoLink;
    data['propertyFiles'] = propertyFiles;
    data['neighborhoodType'] = neighborhoodType;
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
    data['virtualTour'] = virtualTour;
    data['thumbnail'] = thumbnail;
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
    data['favorite'] = favorite;
    if (createdByData != null) {
      data['createdByData'] = createdByData!.toJson();
    }
    data['is_locked'] = isLocked;
    data['lock_expires_at'] = lockExpiresAt;
    data['lock_owner_id'] = lockOwnerId;
    data['isLockedByMe'] = isLockedByMe;
    if (offerData != null) {
      data['offerData'] = offerData!.toJson();
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

  AlternateContactNumber({this.phoneCode, this.contactNumber, this.emoji});

  AlternateContactNumber.fromJson(Map<String, dynamic> json) {
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
