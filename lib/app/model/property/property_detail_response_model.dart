// import '../offers/my_offers_list_response_model.dart';

import '../../ui/screens/dashboard/sub_screens/add_offer/model/add_vendor_response_model.dart';
import 'property_list_response_model.dart';

class PropertyDetailsResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  PropertyDetailData? data;

  PropertyDetailsResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  PropertyDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? PropertyDetailData.fromJson(json['data']) : null;
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

class PropertyDetailData {
  String? sId;
  String? createdBy;
  String? reqDenyReasons;
  String? title;
  Price? price;
  String? description;
  String? categoryId;
  String? subCategoryId;
  bool? isApproved;
  bool? createdByBank;
  String? country;
  String? city;
  bool? isDeleted;
  bool? isSoldOut;
  bool? isReviewed;
  bool? isVisitRequest;
  Area? area;
  AlternateContactNumber? alternateContactNumber;
  AlternateContactNumber? contactNumber;
  dynamic rating;
  dynamic totalRatings;
  List<String>? videoLink;
  List<String>? locationKeys;
  List<String>? propertyFiles;
  List<String>? neighborhoodType;
  PropertyLocation? propertyLocation;
  String? furnishedType;
  String? floors;
  String? bedrooms;
  String? bathrooms;
  String? buildingAge;
  String? facade;
  String? virtualTour;
  String? createdAt;
  String? updatedAt;
  String? shareLink;
  String? thumbnail;
  bool? mortgaged;
  CategoryData? subCategoryData;
  CategoryData? furnishedData;
  CategoryData? bedroomData;
  CategoryData? bathroomData;
  CategoryData? buildingAgeData;
  CategoryData? facadeData;
  CategoryData? floorsData;
  List<PropertyAmenitiesData>? propertyAmenitiesData;
  List<NeighbourHoodTypeData>? neighbourHoodTypeData;
  List<OfferData>? offers;
  CategoryData? categoryData;
  bool? favorite;
  bool? bankOffer;
  bool? vendorOffer;
  bool? isLocked;
  bool? isLockedByMe;
  PropertyOfferData? offerData;
  int? iV;
  String? propertyIdForPropertiesWithOffers;
  CreatedByData? createdByData;
  String? lockExpiresAt;
  String? lockOwnerId;

  PropertyDetailData(
      {this.sId,
      this.createdBy,
      this.reqDenyReasons,
      this.title,
      this.price,
      this.description,
      this.categoryId,
      this.subCategoryId,
      this.isApproved,
      this.createdByBank,
      this.country,
      this.city,
      this.isDeleted,
      this.isSoldOut,
      this.area,
      this.isReviewed,
      this.isVisitRequest,
      this.alternateContactNumber,
      this.contactNumber,
      this.rating,
      this.totalRatings,
      this.locationKeys,
      this.videoLink,
      this.propertyFiles,
      this.neighborhoodType,
      this.propertyLocation,
      this.furnishedType,
      this.floors,
      this.bedrooms,
      this.bathrooms,
      this.buildingAge,
      this.facade,
      this.mortgaged,
      this.virtualTour,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.shareLink,
      this.thumbnail,
      this.propertyAmenitiesData,
      this.furnishedData,
      this.subCategoryData,
      this.bedroomData,
      this.bathroomData,
      this.buildingAgeData,
      this.facadeData,
      this.floorsData,
      this.neighbourHoodTypeData,
      this.offers,
      this.categoryData,
      this.favorite,
      this.bankOffer,
      this.vendorOffer,
      this.isLocked,
      this.isLockedByMe,
      this.offerData,
      this.propertyIdForPropertiesWithOffers,
      this.createdByData,
      this.lockExpiresAt,
      this.lockOwnerId});

  PropertyDetailData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    propertyIdForPropertiesWithOffers = json['propertyId'];
    createdBy = json['createdBy'];
    reqDenyReasons = json['reqDenyReasons'];
    title = json['title'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    description = json['description'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    isApproved = json['isApproved'];
    createdByBank = json['createdByBank'];
    country = json['country'];
    city = json['city'];
    isDeleted = json['isDeleted'];
    isSoldOut = json['isSoldOut'] ?? false;
    isReviewed = json['isReviewed'] ?? false;
    isVisitRequest = json['isVisitRequest'] ?? false;
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    alternateContactNumber = json['alternateContactNumber'] != null
        ? AlternateContactNumber.fromJson(json['alternateContactNumber'])
        : null;
    contactNumber = json['contactNumber'] != null
        ? AlternateContactNumber.fromJson(json['contactNumber'])
        : null;
    rating = json['rating'];
    totalRatings = json['totalRatings'];
    videoLink = (json['videoLink'] as List?)?.cast<String>() ?? [];
    locationKeys = (json['locationKeys'] as List?)?.cast<String>() ?? [];
    propertyFiles = (json['propertyFiles'] as List?)?.cast<String>() ?? [];
    neighborhoodType =
        (json['neighborhoodType'] as List?)?.cast<String>() ?? [];
    propertyLocation = json['propertyLocation'] != null
        ? PropertyLocation.fromJson(json['propertyLocation'])
        : null;
    floors = json['floors'];
    furnishedType = json['furnishedType'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    buildingAge = json['buildingAge'];
    facade = json['facade'];
    mortgaged = json['mortgaged'];
    virtualTour = json['virtualTour'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    shareLink = json['shareLink'];
    thumbnail = json['thumbnail'];
    if (json['propertyAmenitiesData'] != null) {
      propertyAmenitiesData = <PropertyAmenitiesData>[];
      json['propertyAmenitiesData'].forEach((v) {
        propertyAmenitiesData!.add(PropertyAmenitiesData.fromJson(v));
      });
    }
    if (json['neighbourHoodTypeData'] != null) {
      neighbourHoodTypeData = <NeighbourHoodTypeData>[];
      json['neighbourHoodTypeData'].forEach((v) {
        neighbourHoodTypeData!.add(NeighbourHoodTypeData.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = <OfferData>[];
      json['offers'].forEach((v) {
        offers!.add(OfferData.fromJson(v));
      });
    }
    categoryData = json['categoryData'] != null
        ? CategoryData.fromJson(json['categoryData'])
        : null;
    subCategoryData = json['subCategoryData'] != null
        ? CategoryData.fromJson(json['subCategoryData'])
        : null;
    furnishedData = json['furnishedData'] != null
        ? CategoryData.fromJson(json['furnishedData'])
        : null;
    bedroomData = json['bedroomData'] != null
        ? CategoryData.fromJson(json['bedroomData'])
        : null;
    bathroomData = json['bathroomData'] != null
        ? CategoryData.fromJson(json['bathroomData'])
        : null;
    buildingAgeData = json['buildingAgeData'] != null
        ? CategoryData.fromJson(json['buildingAgeData'])
        : null;
    facadeData = json['facadeData'] != null
        ? CategoryData.fromJson(json['facadeData'])
        : null;
    floorsData = json['floorsData'] != null
        ? CategoryData.fromJson(json['floorsData'])
        : null;
    favorite = json['favorite'];
    bankOffer = json['bankOffer'];
    vendorOffer = json['vendorOffer'];
    isLocked = json['isLocked'];
    isLockedByMe = json['isLockedByMe'];
    offerData = json['offerData'] != null
        ? PropertyOfferData.fromJson(json['offerData'])
        : null;
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
    data['propertyId'] = propertyIdForPropertiesWithOffers;
    data['createdBy'] = createdBy;
    data['reqDenyReasons'] = reqDenyReasons;
    data['title'] = title;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['description'] = description;
    data['categoryId'] = categoryId;
    data['subCategoryId'] = subCategoryId;
    data['isApproved'] = isApproved;
    data['createdByBank'] = createdByBank;
    data['country'] = country;
    data['city'] = city;
    data['isDeleted'] = isDeleted;
    data['isSoldOut'] = isSoldOut ?? false;
    data['isReviewed'] = isReviewed ?? false;
    data['isVisitRequest'] = isVisitRequest ?? false;
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
    if (propertyLocation != null) {
      data['propertyLocation'] = propertyLocation!.toJson();
    }
    data['floors'] = floors;
    data['furnishedType'] = furnishedType;
    data['bedrooms'] = bedrooms;
    data['bathrooms'] = bathrooms;
    data['buildingAge'] = buildingAge;
    data['facade'] = facade;
    data['mortgaged'] = mortgaged;
    data['virtualTour'] = virtualTour;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['shareLink'] = shareLink;
    data['thumbnail'] = thumbnail;
    if (furnishedData != null) {
      data['furnishedData'] = furnishedData!.toJson();
    }
    if (bedroomData != null) {
      data['bedroomData'] = bedroomData!.toJson();
    }
    if (bathroomData != null) {
      data['bathroomData'] = bathroomData!.toJson();
    }
    if (buildingAgeData != null) {
      data['buildingAgeData'] = buildingAgeData!.toJson();
    }
    if (facadeData != null) {
      data['facadeData'] = facadeData!.toJson();
    }
    if (floorsData != null) {
      data['floorsData'] = floorsData!.toJson();
    }
    if (propertyAmenitiesData != null) {
      data['propertyAmenitiesData'] =
          propertyAmenitiesData!.map((v) => v.toJson()).toList();
    }
    if (furnishedData != null) {
      data['furnishedData'] = furnishedData!.toJson();
    }
    if (neighbourHoodTypeData != null) {
      data['neighbourHoodTypeData'] =
          neighbourHoodTypeData!.map((v) => v.toJson()).toList();
    }
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    if (subCategoryData != null) {
      data['subCategoryData'] = subCategoryData!.toJson();
    }
    if (categoryData != null) {
      data['categoryData'] = categoryData!.toJson();
    }
    data['favorite'] = favorite;
    data['bankOffer'] = bankOffer;
    data['vendorOffer'] = vendorOffer;
    data['isLocked'] = isLocked;
    data['isLockedByMe'] = isLockedByMe;
    if (offerData != null) {
      data['offerData'] = offerData!.toJson();
    }
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

  bool livingSpaceDataNotEmpty() {
    if (mortgaged == null &&
        furnishedType == null &&
        bedrooms == null &&
        bathrooms == null &&
        buildingAgeData == null &&
        facade == null &&
        floors == null) {
      return false;
    }
    return true;
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
  dynamic countryCode;
  dynamic contactNumber;
  String? emoji;

  AlternateContactNumber({this.phoneCode, this.contactNumber, this.emoji});

  AlternateContactNumber.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'];
    countryCode = json['countryCode'];
    contactNumber = json['contactNumber'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneCode'] = phoneCode;
    data['countryCode'] = countryCode;
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
  String? companyName;
  BankContactNumbers? bankContactNumbers;
  List<BanksAlternativeContact>? banksAlternativeContact;

  CreatedByData(
      {this.firstName,
      this.lastName,
      this.createdAt,
      this.companyLogo,
      this.companyName,
        this.bankContactNumbers,
      this.banksAlternativeContact});

  CreatedByData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    createdAt = json['createdAt'];
    companyLogo = json['companyLogo'];
    companyName = json['companyName'];
    bankContactNumbers = json['bankContactNumbers'] != null
        ? BankContactNumbers.fromJson(json['bankContactNumbers'])
        : null;
    if (json['banksAlternativeContact'] != null) {
      banksAlternativeContact = <BanksAlternativeContact>[];
      json['banksAlternativeContact'].forEach((v) {
        banksAlternativeContact!.add(BanksAlternativeContact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['createdAt'] = createdAt;
    data['companyLogo'] = companyLogo;
    data['companyName'] = companyName;
    if (bankContactNumbers != null) {
      data['bankContactNumbers'] = bankContactNumbers!.toJson();
    }
    if (banksAlternativeContact != null) {
      data['banksAlternativeContact'] =
          banksAlternativeContact!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankContactNumbers {
  String? phoneCode;
  String? contactNumber;

  BankContactNumbers({this.phoneCode, this.contactNumber});

  BankContactNumbers.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'].toString();
    contactNumber = json['contactNumber'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneCode': phoneCode,
      'contactNumber': contactNumber,
    };
  }
}

class BanksAlternativeContact {
  String? phoneCode;
  String? name;
  String? contactNumber;

  BanksAlternativeContact({this.phoneCode, this.name, this.contactNumber});

  BanksAlternativeContact.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'].toString();
    name = json['name'].toString();
    contactNumber = json['contactNumber'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneCode': phoneCode,
      'name': name,
      'contactNumber': contactNumber,
    };
  }
}

class PropertyOfferData {
  String? sId;
  String? offerType;
  String? startDate;
  String? endDate;
  String? vendorId;
  int? durationInDays;

  PropertyOfferData({
    this.sId,
    this.offerType,
    this.startDate,
    this.endDate,
    this.vendorId,
    this.durationInDays,
  });

  PropertyOfferData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    offerType = json['offerType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    vendorId = json['vendorId'];
    durationInDays = json['durationInDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['offerType'] = offerType;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['vendorId'] = vendorId;
    data['durationInDays'] = durationInDays;
    return data;
  }
}
