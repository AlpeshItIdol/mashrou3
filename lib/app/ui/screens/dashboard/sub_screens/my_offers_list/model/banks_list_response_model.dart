// import 'package:mashrou3/app/ui/screens/authentication/login/model/login_response.model.dart';
//
// class BanksListResponseModel {
//   int? statusCode;
//   bool? success;
//   String? message;
//   BanksListData? data;
//
//   BanksListResponseModel(
//       {this.statusCode, this.success, this.message, this.data});
//
//   BanksListResponseModel.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? BanksListData.fromJson(json['data']) : null;
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
// class BanksListData {
//   List<Bank>? bank;
//   int? page;
//   int? documentCount;
//
//   BanksListData({this.bank, this.page, this.documentCount});
//
//   BanksListData.fromJson(Map<String, dynamic> json) {
//     if (json['bank'] != null) {
//       bank = <Bank>[];
//       json['bank'].forEach((v) {
//         bank!.add(Bank.fromJson(v));
//       });
//     }
//     page = json['page'];
//     documentCount = json['documentCount'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (bank != null) {
//       data['bank'] = bank!.map((v) => v.toJson()).toList();
//     }
//     data['page'] = page;
//     data['documentCount'] = documentCount;
//     return data;
//   }
// }
//
// class Bank {
//   String? sId;
//   String? firstName;
//   String? lastName;
//   String? email;
//   bool? isActive;
//   BankLocation? bankLocation;
//   String? createdAt;
//   String? roleId;
//   String? role;
//   String? country;
//   City? city;
//   String? bankOfferSummary;
//   String? companyName;
//   String? companyLogo;
//   List<BanksAlternativeContact>? banksAlternativeContact;
//   List<Permission>? permission;
//
//   Bank(
//       {this.sId,
//       this.firstName,
//       this.lastName,
//       this.email,
//       this.isActive,
//       this.bankLocation,
//       this.createdAt,
//       this.roleId,
//       this.role,
//       this.city,
//       this.country,
//       this.companyLogo,
//       this.companyName,
//       this.bankOfferSummary,
//       this.banksAlternativeContact,
//       this.permission});
//
//   Bank.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     email = json['email'];
//     isActive = json['isActive'];
//     bankLocation = json['bankLocation'] != null
//         ? BankLocation.fromJson(json['bankLocation'])
//         : null;
//     createdAt = json['createdAt'];
//     roleId = json['role_id'];
//     role = json['role'];
//     country = json['country'];
//     city = json['city'] != null ? City.fromJson(json['city']) : null;
//     companyLogo = json['companyLogo'];
//     companyName = json['companyName'];
//     bankOfferSummary = json['bankOfferSummary'];
//
//     if (json['banksAlternativeContact'] != null) {
//       banksAlternativeContact = <BanksAlternativeContact>[];
//       json['banksAlternativeContact'].forEach((v) {
//         banksAlternativeContact!.add(BanksAlternativeContact.fromJson(v));
//       });
//     }
//     if (json['permission'] != null) {
//       permission = <Permission>[];
//       json['permission'].forEach((v) {
//         permission!.add(Permission.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['firstName'] = firstName;
//     data['lastName'] = lastName;
//     data['email'] = email;
//     data['isActive'] = isActive;
//     if (bankLocation != null) {
//       data['bankLocation'] = bankLocation!.toJson();
//     }
//     data['createdAt'] = createdAt;
//     data['role_id'] = roleId;
//     data['role'] = role;
//     data['country'] = country;
//     if (city != null) {
//       data['city'] = city!.toJson();
//     }
//     data['companyLogo'] = this.companyLogo;
//     data['companyName'] = this.companyName;
//     data['bankOfferSummary'] = bankOfferSummary;
//     if (banksAlternativeContact != null) {
//       data['banksAlternativeContact'] =
//           banksAlternativeContact!.map((v) => v.toJson()).toList();
//     }
//     if (permission != null) {
//       data['permission'] = permission!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class BankLocation {
//   double? latitude;
//   double? longitude;
//   String? address;
//
//   BankLocation({this.latitude, this.longitude, this.address});
//
//   BankLocation.fromJson(Map<String, dynamic> json) {
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     address = json['address'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     data['address'] = address;
//     return data;
//   }
// }
//
// class Permission {
//   String? module;
//   List<String>? permissions;
//   List<SubModules>? subModules;
//   String? sId;
//
//   Permission({this.module, this.permissions, this.subModules, this.sId});
//
//   Permission.fromJson(Map<String, dynamic> json) {
//     module = json['module'];
//     permissions = json['permissions'].cast<String>();
//     if (json['subModules'] != null) {
//       subModules = <SubModules>[];
//       json['subModules'].forEach((v) {
//         subModules!.add(SubModules.fromJson(v));
//       });
//     }
//     sId = json['_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['module'] = module;
//     data['permissions'] = permissions;
//     if (subModules != null) {
//       data['subModules'] = subModules!.map((v) => v.toJson()).toList();
//     }
//     data['_id'] = sId;
//     return data;
//   }
// }
//
// class SubModules {
//   String? name;
//   List<String>? permissions;
//   String? sId;
//
//   SubModules({this.name, this.permissions, this.sId});
//
//   SubModules.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     permissions = json['permissions'].cast<String>();
//     sId = json['_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['permissions'] = permissions;
//     data['_id'] = sId;
//     return data;
//   }
// }
