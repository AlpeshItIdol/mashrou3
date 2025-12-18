// To parse this JSON data, do
//
//     final bankOffersListResponse = bankOffersListResponseFromJson(jsonString);

import 'dart:convert';

BankOffersListResponse bankOffersListResponseFromJson(String str) => BankOffersListResponse.fromJson(json.decode(str));

String bankOffersListResponseToJson(BankOffersListResponse data) => json.encode(data.toJson());

class BankOffersListResponse {
  int? statusCode;
  bool? success;
  String? message;
  BankOfferList? data;

  BankOffersListResponse({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory BankOffersListResponse.fromJson(Map<String, dynamic> json) => BankOffersListResponse(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : BankOfferList.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class BankOfferList {
  List<BankUserList>? bank;
  int? page;
  int? documentCount;

  BankOfferList({
    this.bank,
    this.page,
    this.documentCount,
  });

  factory BankOfferList.fromJson(Map<String, dynamic> json) => BankOfferList(
    bank: json["bank"] == null ? [] : List<BankUserList>.from(json["bank"]!.map((x) => BankUserList.fromJson(x))),
    page: json["page"],
    documentCount: json["documentCount"],
  );

  Map<String, dynamic> toJson() => {
    "bank": bank == null ? [] : List<dynamic>.from(bank!.map((x) => x.toJson())),
    "page": page,
    "documentCount": documentCount,
  };
}

class BankUserList {
  String? id;
  dynamic firstName;
  dynamic lastName;
  dynamic bankOfferSummary;
  String? email;
  dynamic city;
  bool? isActive;
  String? companyLogo;
  String? companyName;
  dynamic companyDescription;
  BankLocation? bankLocation;
  List<BanksAlternativeContact>? banksAlternativeContact;
  DateTime? createdAt;
  dynamic fullName;
  String? roleId;
  String? role;
  List<Permission>? permission;

  BankUserList({
    this.id,
    this.firstName,
    this.lastName,
    this.bankOfferSummary,
    this.email,
    this.city,
    this.isActive,
    this.companyLogo,
    this.companyName,
    this.companyDescription,
    this.bankLocation,
    this.banksAlternativeContact,
    this.createdAt,
    this.fullName,
    this.roleId,
    this.role,
    this.permission,
  });

  factory BankUserList.fromJson(Map<String, dynamic> json) => BankUserList(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    bankOfferSummary: json["bankOfferSummary"],
    email: json["email"],
    city: json["city"],
    isActive: json["isActive"],
    companyLogo: json["companyLogo"],
    companyName: json["companyName"],
    companyDescription: json["companyDescription"],
    bankLocation: json["bankLocation"] == null ? null : BankLocation.fromJson(json["bankLocation"]),
    banksAlternativeContact: json["banksAlternativeContact"] == null ? [] : List<BanksAlternativeContact>.from(json["banksAlternativeContact"]!.map((x) => BanksAlternativeContact.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    fullName: json["fullName"],
    roleId: json["role_id"],
    role: json["role"],
    permission: json["permission"] == null ? [] : List<Permission>.from(json["permission"]!.map((x) => Permission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "bankOfferSummary": bankOfferSummary,
    "email": email,
    "city": city,
    "isActive": isActive,
    "companyLogo": companyLogo,
    "companyName": companyName,
    "companyDescription": companyDescription,
    "bankLocation": bankLocation?.toJson(),
    "banksAlternativeContact": banksAlternativeContact == null ? [] : List<dynamic>.from(banksAlternativeContact!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "fullName": fullName,
    "role_id": roleId,
    "role": role,
    "permission": permission == null ? [] : List<dynamic>.from(permission!.map((x) => x.toJson())),
  };
}

class BankLocation {
  double? latitude;
  double? longitude;
  String? address;
  String? city;
  String? country;

  BankLocation({
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.country,
  });

  factory BankLocation.fromJson(Map<String, dynamic> json) => BankLocation(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    address: json["address"],
    city: json["city"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "city": city,
    "country": country,
  };
}

class BanksAlternativeContact {
  String? phoneCode;
  String? contactNumber;
  String? name;
  String? id;

  BanksAlternativeContact({
    this.phoneCode,
    this.contactNumber,
    this.name,
    this.id,
  });

  factory BanksAlternativeContact.fromJson(Map<String, dynamic> json) => BanksAlternativeContact(
    phoneCode: json["phoneCode"],
    contactNumber: json["contactNumber"],
    name: json["name"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "phoneCode": phoneCode,
    "contactNumber": contactNumber,
    "name": name,
    "_id": id,
  };
}

class Permission {
  String? module;
  List<String>? permissions;
  List<dynamic>? subModules;
  String? id;

  Permission({
    this.module,
    this.permissions,
    this.subModules,
    this.id,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    module: json["module"],
    permissions: json["permissions"] == null ? [] : List<String>.from(json["permissions"]!.map((x) => x)),
    subModules: json["subModules"] == null ? [] : List<dynamic>.from(json["subModules"]!.map((x) => x)),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "module": module,
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
    "subModules": subModules == null ? [] : List<dynamic>.from(subModules!.map((x) => x)),
    "_id": id,
  };
}
