// class VendorsSequenceResponse {
//   int? statusCode;
//   bool? success;
//   String? message;
//   VendorsPageData? data;
//
//   VendorsSequenceResponse({this.statusCode, this.success, this.message, this.data});
//
//   VendorsSequenceResponse.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? VendorsPageData.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['statusCode'] = statusCode;
//     data['success'] = success;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class VendorsPageData {
//   List<VendorSequenceUser>? users;
//   int? page;
//   int? documentCount;
//   int? pageCount;
//
//   VendorsPageData({this.users, this.page, this.documentCount, this.pageCount});
//
//   VendorsPageData.fromJson(Map<String, dynamic> json) {
//     if (json['users'] != null) {
//       users = <VendorSequenceUser>[];
//       json['users'].forEach((v) {
//         users!.add(VendorSequenceUser.fromJson(v));
//       });
//     }
//     page = json['page'];
//     documentCount = json['documentCount'];
//     pageCount = json['pageCount'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (users != null) {
//       data['users'] = users!.map((v) => v.toJson()).toList();
//     }
//     data['page'] = page;
//     data['documentCount'] = documentCount;
//     data['pageCount'] = pageCount;
//     return data;
//   }
// }
//
// class VendorSequenceUser {
//   String? sId;
//   String? firstName;
//   String? lastName;
//   String? contactNumber;
//   String? phoneCode;
//   String? email;
//   String? userType;
//   bool? isActive;
//   String? companyLogo;
//   String? companyName;
//   bool? profileComplete;
//   String? createdAt;
//   int? sequence;
//   String? fullName;
//   String? country;
//
//   VendorSequenceUser({
//     this.sId,
//     this.firstName,
//     this.lastName,
//     this.contactNumber,
//     this.phoneCode,
//     this.email,
//     this.userType,
//     this.isActive,
//     this.companyLogo,
//     this.companyName,
//     this.profileComplete,
//     this.createdAt,
//     this.sequence,
//     this.fullName,
//     this.country,
//   });
//
//   VendorSequenceUser.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     contactNumber = json['contactNumber'];
//     phoneCode = json['phoneCode'];
//     email = json['email'];
//     userType = json['userType'];
//     isActive = json['isActive'];
//     companyLogo = json['companyLogo'];
//     companyName = json['companyName'];
//     profileComplete = json['profileComplete'];
//     createdAt = json['createdAt'];
//     sequence = json['sequence'];
//     fullName = json['fullName'];
//     country = json['country'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['firstName'] = firstName;
//     data['lastName'] = lastName;
//     data['contactNumber'] = contactNumber;
//     data['phoneCode'] = phoneCode;
//     data['email'] = email;
//     data['userType'] = userType;
//     data['isActive'] = isActive;
//     data['companyLogo'] = companyLogo;
//     data['companyName'] = companyName;
//     data['profileComplete'] = profileComplete;
//     data['createdAt'] = createdAt;
//     data['sequence'] = sequence;
//     data['fullName'] = fullName;
//     data['country'] = country;
//     return data;
//   }
// }
//
//


// To parse this JSON data, do
//
//     final vendorsSequenceResponse = vendorsSequenceResponseFromJson(jsonString);

import 'dart:convert';

VendorsSequenceResponse vendorsSequenceResponseFromJson(String str) => VendorsSequenceResponse.fromJson(json.decode(str));

String vendorsSequenceResponseToJson(VendorsSequenceResponse data) => json.encode(data.toJson());

class VendorsSequenceResponse {
  int? statusCode;
  bool? success;
  String? message;
  Data? data;

  VendorsSequenceResponse({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory VendorsSequenceResponse.fromJson(Map<String, dynamic> json) => VendorsSequenceResponse(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  List<VendorSequenceUser>? users;
  int? page;
  int? documentCount;
  int? pageCount;

  Data({
    this.users,
    this.page,
    this.documentCount,
    this.pageCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    users: List<VendorSequenceUser>.from(json["users"].map((x) => VendorSequenceUser.fromJson(x))),
    page: json["page"],
    documentCount: json["documentCount"],
    pageCount: json["pageCount"],
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users!.map((x) => x.toJson())),
    "page": page,
    "documentCount": documentCount,
    "pageCount": pageCount,
  };
}

class VendorSequenceUser {
  String? id;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? phoneCode;
  String? email;
  String? userType;
  City? city;
  bool? isActive;
  String? companyLogo;
  String? companyName;
  String? companyDescription;
  List<String>? identityVerificationDoc;
  List<String>? portfolio;
  SocialMediaLinks? socialMediaLinks;
  bool? profileComplete;
  List<String>? connectedBank;
  DateTime? createdAt;
  List<Location>? location;
  AlternativeContactNumbers? alternativeContactNumbers;
  int? sequence;
  String? fullName;
  String? country;
  List<VendorCategory>? vendorCategories;

  VendorSequenceUser({
    this.id,
    this.firstName,
    this.lastName,
    this.contactNumber,
    this.phoneCode,
    this.email,
    this.userType,
    this.city,
    this.isActive,
    this.companyLogo,
    this.companyName,
    this.companyDescription,
    this.identityVerificationDoc,
    this.portfolio,
    this.socialMediaLinks,
    this.profileComplete,
    this.connectedBank,
    this.createdAt,
    this.location,
    this.alternativeContactNumbers,
    this.sequence,
    this.fullName,
    this.country,
    this.vendorCategories,
  });

  factory VendorSequenceUser.fromJson(Map<String, dynamic> json) => VendorSequenceUser(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    contactNumber: json["contactNumber"],
    phoneCode: json["phoneCode"],
    email: json["email"],
    userType: json["userType"],
    city: City.fromJson(json["city"]),
    isActive: json["isActive"],
    companyLogo: json["companyLogo"],
    companyName: json["companyName"],
    companyDescription: json["companyDescription"],
    identityVerificationDoc: List<String>.from(json["identityVerificationDoc"].map((x) => x)),
    portfolio: List<String>.from(json["portfolio"].map((x) => x)),
    socialMediaLinks: SocialMediaLinks.fromJson(json["socialMediaLinks"]),
    profileComplete: json["profileComplete"],
    connectedBank: List<String>.from(json["connectedBank"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    location: List<Location>.from(json["location"].map((x) => Location.fromJson(x))),
    alternativeContactNumbers: json["alternativeContactNumbers"] != null ? AlternativeContactNumbers.fromJson(json["alternativeContactNumbers"]) : AlternativeContactNumbers(),
    sequence: json["sequence"],
    fullName: json["fullName"],
    country: json["country"],
    vendorCategories: List<VendorCategory>.from(json["vendorCategories"].map((x) => VendorCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "contactNumber": contactNumber,
    "phoneCode": phoneCode,
    "email": email,
    "userType": userType,
    "city": city!.toJson(),
    "isActive": isActive,
    "companyLogo": companyLogo,
    "companyName": companyName,
    "companyDescription": companyDescription,
    "identityVerificationDoc": List<dynamic>.from(identityVerificationDoc!.map((x) => x)),
    "portfolio": List<dynamic>.from(portfolio!.map((x) => x)),
    "socialMediaLinks": socialMediaLinks!.toJson(),
    "profileComplete": profileComplete,
    "connectedBank": List<dynamic>.from(connectedBank!.map((x) => x)),
    "createdAt": createdAt!.toIso8601String(),
    "location": List<dynamic>.from(location!.map((x) => x.toJson())),
    "alternativeContactNumbers": alternativeContactNumbers!.toJson(),
    "sequence": sequence,
    "fullName": fullName,
    "country": country,
    "vendorCategories": List<dynamic>.from(vendorCategories!.map((x) => x.toJson())),
  };
}

class AlternativeContactNumbers {
  String? phoneCode;
  String? contactNumber;
  String? emoji;

  AlternativeContactNumbers({
    this.phoneCode,
    this.contactNumber,
    this.emoji,
  });

  factory AlternativeContactNumbers.fromJson(Map<String, dynamic> json) => AlternativeContactNumbers(
    phoneCode: json["phoneCode"],
    contactNumber: json["contactNumber"],
    emoji: json["emoji"],
  );

  Map<String, dynamic> toJson() => {
    "phoneCode": phoneCode,
    "contactNumber": contactNumber,
    "emoji": emoji,
  };
}



class City {
  String? id;
  String? name;

  City({
    this.id,
    this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
  };
}

class Location {
  double? latitude;
  double? longitude;
  String? address;
  String? id;

  Location({
    this.latitude,
    this.longitude,
    this.address,
    this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    address: json["address"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "_id": id,
  };
}

class SocialMediaLinks {
  String? facebook;
  String? twitter;
  String? linkedin;
  String? catalog;
  String? website;
  String? instagram;
  List<dynamic>? profileLink;
  String? virtualTour;
  dynamic? linkedIn;

  SocialMediaLinks({
    this.facebook,
    this.twitter,
    this.linkedin,
    this.catalog,
    this.website,
    this.instagram,
    this.profileLink,
    this.virtualTour,
    this.linkedIn,
  });

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) => SocialMediaLinks(
    facebook: json["facebook"],
    twitter: json["twitter"],
    linkedin: json["linkedin"],
    catalog: json["catalog"],
    website: json["website"],
    instagram: json["instagram"],
    profileLink: json["profileLink"] != null ? List<dynamic>.from(json["profileLink"].map((x) => x)) : [],
    virtualTour: json["virtualTour"],
    linkedIn: json["linkedIn"],
  );

  Map<String, dynamic> toJson() => {
    "facebook": facebook,
    "twitter": twitter,
    "linkedin": linkedin,
    "catalog": catalog,
    "website": website,
    "instagram": instagram,
    "profileLink": List<dynamic>.from(profileLink!.map((x) => x)),
    "virtualTour": virtualTour,
    "linkedIn": linkedIn,
  };
}


class VendorCategory {
  List<dynamic>? id;
  List<dynamic>? title;
  List<dynamic>? description;

  VendorCategory({
    this.id,
    this.title,
    this.description,
  });

  factory VendorCategory.fromJson(Map<String, dynamic> json) => VendorCategory(
    id: List<dynamic>.from(json["_id"].map((x) => x)),
    title: List<dynamic>.from(json["title"].map((x) => x)),
    description: List<dynamic>.from(json["description"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": List<dynamic>.from(id!.map((x) => x)),
    "title": List<dynamic>.from(title!.map((x) => x)),
    "description": List<dynamic>.from(description!.map((x) => x)),
  };
}
