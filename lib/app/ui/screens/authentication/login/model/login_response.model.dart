class LoginResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  LoginResponseData? loginResponseData;

  LoginResponseModel(
      {this.statusCode, this.success, this.message, this.loginResponseData});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    loginResponseData = json['data'] != null
        ? LoginResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (loginResponseData != null) {
      data['data'] = loginResponseData!.toJson();
    }
    return data;
  }
}

class LoginResponseData {
  Users? users;

  LoginResponseData({this.users});

  LoginResponseData.fromJson(Map<String, dynamic> json) {
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.toJson();
    }
    return data;
  }
}

class Users {
  String? sId;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? phoneCode;
  AlternativeContactNumbers? alternativeContactNumbers;
  String? email;
  String? userType;
  List<String>? vendorCategory;
  String? country;
  String? language;
  City? city;
  String? deletedAt;
  bool? isVerified;
  bool? isActive;
  String? companyLogo;
  String? companyName;
  String? companyDescription;
  List<String>? identityVerificationDoc;
  dynamic otp;
  dynamic otpExpire;
  SocialMediaLinks? socialMediaLinks;
  bool? isDeleted;
  bool? profileComplete;
  String? addressLine1;
  String? addressLine2;
  String? createdAt;
  String? updatedAt;
  bool? isSubscriptionEnabled;
  bool? isSubscribed;
  int? iV;
  List<Location>? location;
  int? passwordResetExpires;
  String? passwordResetToken;

  Users(
      {this.sId,
      this.firstName,
      this.lastName,
      this.contactNumber,
      this.phoneCode,
      this.alternativeContactNumbers,
      this.email,
      this.userType,
      this.vendorCategory,
      this.country,
      this.language,
      this.city,
      this.deletedAt,
      this.isVerified,
      this.isActive,
      this.companyLogo,
      this.companyName,
      this.companyDescription,
      this.identityVerificationDoc,
      this.otp,
      this.otpExpire,
      this.socialMediaLinks,
        this.isSubscriptionEnabled,
        this.isSubscribed,
      this.isDeleted,
      this.profileComplete,
      this.addressLine1,
      this.addressLine2,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.location,
      this.passwordResetExpires,
      this.passwordResetToken});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    contactNumber = json['contactNumber'];
    phoneCode = json['phoneCode'];
    // if (json['alternativeContactNumbers'] != null) {
    //   alternativeContactNumbers = <AlternativeContactNumbers>[];
    //   json['alternativeContactNumbers'].forEach((v) {
    //     alternativeContactNumbers!
    //         .add(new AlternativeContactNumbers.fromJson(v));
    //   });
    // }
    // Handling the alternativeContactNumbers field
    // Handle alternativeContactNumbers as an object
    if (json['alternativeContactNumbers'] != null) {
      alternativeContactNumbers =
          AlternativeContactNumbers.fromJson(json['alternativeContactNumbers']);
    }
    email = json['email'];
    userType = json['userType'];
    isSubscriptionEnabled = json['isSubscriptionEnabled'];
    isSubscribed = json['isSubscribed'];
    vendorCategory = json['vendorCategory'] != null
        ? List<String>.from(json['vendorCategory'])
        : null;
    country = json['country'];
    language = json['language'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    deletedAt = json['deletedAt'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    companyLogo = json['companyLogo'];
    companyName = json['companyName'];
    companyDescription = json['companyDescription'];
    identityVerificationDoc = json['identityVerificationDoc'] != null
        ? List<String>.from(json['identityVerificationDoc'])
        : null;
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
    // if (json['amenities'] != null) {
    //   amenities = <Null>[];
    //   json['amenities'].forEach((v) {
    //     amenities!.add(new Null.fromJson(v));
    //   });
    // }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['location'] != null) {
      location = <Location>[];
      json['location'].forEach((v) {
        location!.add(Location.fromJson(v));
      });
    }
    // location = json['location'] != null ? Location.fromJson(json['location']) : null;
    passwordResetExpires = json['passwordResetExpires'];
    passwordResetToken = json['passwordResetToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['contactNumber'] = contactNumber;
    data['phoneCode'] = phoneCode;
    // if (this.alternativeContactNumbers != null) {
    //   data['alternativeContactNumbers'] =
    //       this.alternativeContactNumbers!.map((v) => v.toJson()).toList();
    // }
    // Handling the alternativeContactNumbers field for JSON output
    if (alternativeContactNumbers != null) {
      data['alternativeContactNumbers'] = alternativeContactNumbers!.toJson();
    }
    data['email'] = email;
    data['userType'] = userType;
    data['vendorCategory'] = vendorCategory;
    data['country'] = country;
    data['language'] = language;
    data['isSubscriptionEnabled'] = isSubscriptionEnabled;
    data['isSubscribed'] = isSubscribed;
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
    // if (amenities != null) {
    //   data['amenities'] = amenities!.map((v) => v.toJson()).toList();
    // }
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

class AlternativeContactNumbers {
  String? phoneCode;
  String? contactNumber;
  String? emoji;
  String? sId;

  AlternativeContactNumbers(
      {this.phoneCode, this.contactNumber, this.emoji, this.sId});

  AlternativeContactNumbers.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'];
    contactNumber = json['contactNumber'];
    emoji = json['emoji'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneCode'] = phoneCode;
    data['contactNumber'] = contactNumber;
    data['emoji'] = emoji;
    data['_id'] = sId;
    return data;
  }
}

class City {
  String? sId;
  String? name;

  City({this.sId, this.name});

  City.fromJson(Map<String, dynamic> json) {
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

class SocialMediaLinks {
  String? instagram;
  String? facebook;
  String? twitter;
  String? linkedIn;
  String? catalog;
  String? website;
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
    website = json['website'];
    profileLink = json['profileLink'] != null
        ? (json['profileLink'] is List
            ? List<String>.from(json['profileLink'])
            : [json['profileLink']])
        : null;
    // profileLink = json['profileLink'] != null
    //     ? List<String>.from(json['profileLink'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['linkedIn'] = linkedIn;
    data['catalog'] = catalog;
    data['website'] = website;
    data['profileLink'] = profileLink;
    return data;
  }
}

class Location {
  dynamic latitude;
  dynamic longitude;
  String? address;

  Location({this.latitude, this.longitude, this.address});

  Location.fromJson(Map<String, dynamic> json) {
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
