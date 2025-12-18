import 'package:mashrou3/app/model/offers/my_offers_list_response_model.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';

import '../ui/screens/authentication/login/model/login_response.model.dart';
import 'country_list_model.dart';

class VerifyResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  VerifyResponseData? verifyResponseData;

  VerifyResponseModel(
      {this.statusCode, this.success, this.message, this.verifyResponseData});

  VerifyResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    verifyResponseData =
        json['data'] != null ? VerifyResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (verifyResponseData != null) {
      data['data'] = verifyResponseData!.toJson();
    }
    return data;
  }
}

class VerifyResponseData {
  String? token;
  UserDetailsData? users;
  Support? support;

  VerifyResponseData({this.token, this.users, this.support});

  VerifyResponseData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    users =
        json['users'] != null ? UserDetailsData.fromJson(json['users']) : null;
    support =
        json['support'] != null ? Support.fromJson(json['support']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (users != null) {
      data['users'] = users!.toJson();
    }
    if (support != null) {
      data['support'] = support!.toJson();
    }
    return data;
  }
}

class UserDetailsData {
  String? sId;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? phoneCode;
  BankLocation? bankLocation;
  BankContactNumbers? bankContactNumbers;
  AlternativeContactNumbers? alternativeContactNumbers;
  String? email;
  String? userType;
  String? country;
  CountryListData? countryData;
  String? language;
  City? city;
  String? deletedAt;
  bool? isVerified;
  bool? isActive;
  String? companyLogo;
  String? companyName;
  String? companyDescription;
  List<String>? identityVerificationDoc;
  List<String>? portfolio;
  dynamic otp;
  dynamic otpExpire;
  SocialMediaLinks? socialMediaLinks;
  bool? isDeleted;
  bool? profileComplete;
  List<OfferData>? offerData;
  List<BanksAlternativeContact>? banksAlternativeContact;
  List<dynamic>? connectedVendors;
  String? addressLine1;
  String? addressLine2;
  List<dynamic>? amenities;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isSubscriptionEnabled;
  bool? isSubscribed;
  List<Location>? location;
  int? passwordResetExpires;
  String? passwordResetToken;

  UserDetailsData(
      {this.sId,
      this.firstName,
      this.lastName,
      this.contactNumber,
      this.phoneCode,
      this.bankContactNumbers,
      this.bankLocation,
      this.alternativeContactNumbers,
      this.email,
      this.userType,
      this.country,
      this.countryData,
      this.language,
        this.isSubscriptionEnabled,
        this.isSubscribed,
      this.city,
      this.deletedAt,
      this.isVerified,
      this.isActive,
      this.companyLogo,
      this.companyName,
      this.companyDescription,
      this.identityVerificationDoc,
      this.portfolio,
      this.otp,
      this.otpExpire,
      this.socialMediaLinks,
      this.isDeleted,
      this.profileComplete,
      this.offerData,
      this.banksAlternativeContact,
      this.connectedVendors,
      this.addressLine1,
      this.addressLine2,
      this.amenities,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.location,
      this.passwordResetExpires,
      this.passwordResetToken});

  UserDetailsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    contactNumber = json['contactNumber'];
    phoneCode = json['phoneCode'];
    alternativeContactNumbers = json['alternativeContactNumbers'] != null
        ? AlternativeContactNumbers.fromJson(json['alternativeContactNumbers'])
        : null;
    bankContactNumbers = json['bankContactNumbers'] != null
        ? BankContactNumbers.fromJson(json['bankContactNumbers'])
        : null;
    bankLocation = json['bankLocation'] != null
        ? BankLocation.fromJson(json['bankLocation'])
        : null;
    email = json['email'];
    userType = json['userType'];
    // Handle country as either String or Map
    if (json['country'] != null) {
      if (json['country'] is String) {
        country = json['country'] as String;
      } else if (json['country'] is Map) {
        // Extract country name from map if it exists
        final countryMap = json['country'] as Map<String, dynamic>;
        country = countryMap['name']?.toString() ?? countryMap['country']?.toString() ?? countryMap.toString();
      } else {
        country = json['country'].toString();
      }
    } else {
      country = null;
    }
    countryData = json['countryData'] != null
        ? CountryListData.fromJson(json['countryData'])
        : null;
    language = json['language'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    deletedAt = json['deletedAt'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    companyLogo = json['companyLogo'];
    companyName = json['companyName'];
    companyDescription = json['companyDescription'];
    isSubscribed = json['isSubscribed'];
    isSubscriptionEnabled = json['isSubscriptionEnabled'];
    identityVerificationDoc = json['identityVerificationDoc'] != null
        ? List<String>.from(json['identityVerificationDoc'])
        : null;
    portfolio =
        json['portfolio'] != null ? List<String>.from(json['portfolio']) : null;
    otp = json['otp'];
    otpExpire = json['otpExpire'];
    socialMediaLinks = json['socialMediaLinks'] != null
        ? SocialMediaLinks.fromJson(json['socialMediaLinks'])
        : null;
    isDeleted = json['isDeleted'];
    profileComplete = json['profileComplete'];
    // if (json['connectedVendors'] != null) {
    //   connectedVendors = <Null>[];
    //   json['connectedVendors'].forEach((v) {
    //     connectedVendors!.add(new Null.fromJson(v));
    //   });
    // }
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    if (json['banksAlternativeContact'] != null) {
      banksAlternativeContact = <BanksAlternativeContact>[];
      json['banksAlternativeContact'].forEach((v) {
        banksAlternativeContact!.add(BanksAlternativeContact.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['location'] != null) {
      location = <Location>[];
      if (json['location'] is List<dynamic>) {
        json['location'].forEach((v) {
          location!.add(Location.fromJson(v));
        });
      } else if (json['location'] is Map<String, dynamic>) {
        location!.add(Location.fromJson(json['location']));
      }
    }
    // location =
    //     json['location'] != null ? Location.fromJson(json['location']) : null;
    passwordResetExpires = json['passwordResetExpires'];
    passwordResetToken = json['passwordResetToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['contactNumber'] = contactNumber;
    data['isSubscriptionEnabled'] = isSubscriptionEnabled;
    data['phoneCode'] = phoneCode;
    if (alternativeContactNumbers != null) {
      data['alternativeContactNumbers'] = alternativeContactNumbers!.toJson();
    }
    if (bankContactNumbers != null) {
      data['bankContactNumbers'] = bankContactNumbers!.toJson();
    }
    if (bankLocation != null) {
      data['bankLocation'] = bankLocation!.toJson();
    }
    data['email'] = email;
    data['userType'] = userType;
    data['country'] = country;
    if (countryData != null) {
      data['countryData'] = countryData!.toJson();
    }
    data['language'] = language;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['deletedAt'] = deletedAt;
    data['isVerified'] = isVerified;
    data['isActive'] = isActive;
    data['companyLogo'] = companyLogo;
    data['companyName'] = companyName;
    data['companyDescription'] = companyDescription;
    data['identityVerificationDoc'] = identityVerificationDoc;
    data['portfolio'] = portfolio;
    data['otp'] = otp;
    data['otpExpire'] = otpExpire;
    if (socialMediaLinks != null) {
      data['socialMediaLinks'] = socialMediaLinks!.toJson();
    }
    data['isDeleted'] = isDeleted;
    data['profileComplete'] = profileComplete;
    // if (connectedVendors != null) {
    //   data['connectedVendors'] =
    //       connectedVendors!.map((v) => v.toJson()).toList();
    // }
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    if (banksAlternativeContact != null) {
      data['banksAlternativeContact'] =
          banksAlternativeContact!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (location != null) {
      data['location'] = location!.map((v) => v.toJson()).toList();
    }
    // if (location != null) {
    //   data['location'] = location!.toJson();
    // }
    data['passwordResetExpires'] = passwordResetExpires;
    data['passwordResetToken'] = passwordResetToken;
    return data;
  }
}

class BankLocation {
  double? latitude;
  double? longitude;
  String? address;
  String? city;
  String? country;

  BankLocation(
      {this.latitude, this.longitude, this.address, this.city, this.country});

  BankLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country
    };
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

class AlternativeContactNumbers {
  String? phoneCode;
  String? countryCode;
  String? contactNumber;
  String? emoji;
  String? sId;

  AlternativeContactNumbers(
      {this.phoneCode, this.contactNumber, this.emoji, this.sId});

  AlternativeContactNumbers.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'];
    countryCode = json['countryCode'];
    contactNumber = json['contactNumber'];
    emoji = json['emoji'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneCode'] = phoneCode;
    data['countryCode'] = countryCode;
    data['contactNumber'] = contactNumber;
    data['emoji'] = emoji;
    data['_id'] = sId;
    return data;
  }
}

class SocialMediaLinks {
  String? instagram;
  String? facebook;
  String? twitter;
  String? linkedIn;
  String? catalog;
  String? website;
  String? virtualTour;
  List<String>? profileLink;

  SocialMediaLinks(
      {this.instagram,
      this.facebook,
      this.twitter,
      this.linkedIn,
      this.catalog,
      this.website,
      this.profileLink});

  SocialMediaLinks.fromJson(Map<String, dynamic> json) {
    instagram = json['instagram'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    linkedIn = json['linkedIn'];
    catalog = json['catalog'];
    virtualTour = json['virtualTour'];
    website = json['website'];
    profileLink = json['profileLink'] != null
        ? (json['profileLink'] is List
            ? List<String>.from(json['profileLink'])
            : [json['profileLink']])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['linkedIn'] = linkedIn;
    data['catalog'] = catalog;
    data['virtualTour'] = virtualTour;
    data['website'] = website;
    data['profileLink'] = profileLink;
    return data;
  }

  bool isEmptyVendor() {
    return (facebook?.isEmpty ?? true) &&
        (twitter?.isEmpty ?? true) &&
        (instagram?.isEmpty ?? true);
  }

  bool isEmptyOwner() {
    return (facebook?.isEmpty ?? true) &&
        (linkedIn?.isEmpty ?? true) &&
        (instagram?.isEmpty ?? true);
  }

  bool isEmpty() {
    return (facebook?.isEmpty ?? true) &&
        (twitter?.isEmpty ?? true) &&
        (website?.isEmpty ?? true) &&
        (instagram?.isEmpty ?? true);
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
