import 'package:mashrou3/app/ui/screens/authentication/login/model/login_response.model.dart';

class SignUpResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  SignUpResponseData? data;

  SignUpResponseModel({this.statusCode, this.success, this.message, this.data});

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? SignUpResponseData.fromJson(json['data']) : null;
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

class SignUpResponseData {
  Users? users;

  SignUpResponseData({this.users});

  SignUpResponseData.fromJson(Map<String, dynamic> json) {
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    return data;
  }
}

// class SignUpResponseData {
//   String? sId;
//   String? firstName;
//   String? lastName;
//   String? contactNumber;
//   String? phoneCode;
//   AlternativeContactNumbers? alternativeContactNumbers;
//   String? email;
//   String? userType;
//   List<Null>? vendorCategory;
//   String? country;
//   String? language;
//   String? city;
//   String? deletedAt;
//   bool? isVerified;
//   String? companyLogo;
//   String? companyName;
//   String? companyDescription;
//   List<Null>? identityVerificationDoc;
//   String? otp;
//   String? otpExpire;
//   String? socialMediaLinks;
//   bool? isDeleted;
//   bool? profileComplete;
//   List<Null>? connectedVendors;
//   String? addressLine1;
//   String? addressLine2;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   SignUpResponseData(
//       {this.sId,
//         this.firstName,
//         this.lastName,
//         this.contactNumber,
//         this.phoneCode,
//         this.alternativeContactNumbers,
//         this.email,
//         this.userType,
//         this.vendorCategory,
//         this.country,
//         this.language,
//         this.city,
//         this.deletedAt,
//         this.isVerified,
//         this.companyLogo,
//         this.companyName,
//         this.companyDescription,
//         this.identityVerificationDoc,
//         this.otp,
//         this.otpExpire,
//         this.socialMediaLinks,
//         this.isDeleted,
//         this.profileComplete,
//         this.connectedVendors,
//         this.addressLine1,
//         this.addressLine2,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   SignUpResponseData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     contactNumber = json['contactNumber'];
//     phoneCode = json['phoneCode'];
//     // Handle alternativeContactNumbers as an object
//     if (json['alternativeContactNumbers'] != null) {
//       alternativeContactNumbers = AlternativeContactNumbers.fromJson(json['alternativeContactNumbers']);
//     }
//     email = json['email'];
//     userType = json['userType'];
//     // if (json['vendorCategory'] != null) {
//     //   vendorCategory = <Null>[];
//     //   json['vendorCategory'].forEach((v) {
//     //     vendorCategory!.add(new Null.fromJson(v));
//     //   });
//     // }
//     country = json['country'];
//     language = json['language'];
//     city = json['city'];
//     deletedAt = json['deletedAt'];
//     isVerified = json['isVerified'];
//     companyLogo = json['companyLogo'];
//     companyName = json['companyName'];
//     companyDescription = json['companyDescription'];
//     // if (json['identityVerificationDoc'] != null) {
//     //   identityVerificationDoc = <Null>[];
//     //   json['identityVerificationDoc'].forEach((v) {
//     //     identityVerificationDoc!.add(new Null.fromJson(v));
//     //   });
//     // }
//     otp = json['otp'];
//     otpExpire = json['otpExpire'];
//     socialMediaLinks = json['socialMediaLinks'];
//     isDeleted = json['isDeleted'];
//     profileComplete = json['profileComplete'];
//     // if (json['connectedVendors'] != null) {
//     //   connectedVendors = <Null>[];
//     //   json['connectedVendors'].forEach((v) {
//     //     connectedVendors!.add(new Null.fromJson(v));
//     //   });
//     // }
//     addressLine1 = json['addressLine1'];
//     addressLine2 = json['addressLine2'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['firstName'] = this.firstName;
//     data['lastName'] = this.lastName;
//     data['contactNumber'] = this.contactNumber;
//     data['phoneCode'] = this.phoneCode;
//     if (this.alternativeContactNumbers != null) {
//       data['alternativeContactNumbers'] =
//           this.alternativeContactNumbers!.toJson();
//     }
//     data['email'] = this.email;
//     data['userType'] = this.userType;
//     // if (this.vendorCategory != null) {
//     //   data['vendorCategory'] =
//     //       this.vendorCategory!.map((v) => v.toJson()).toList();
//     // }
//     data['country'] = this.country;
//     data['language'] = this.language;
//     data['city'] = this.city;
//     data['deletedAt'] = this.deletedAt;
//     data['isVerified'] = this.isVerified;
//     data['companyLogo'] = this.companyLogo;
//     data['companyName'] = this.companyName;
//     data['companyDescription'] = this.companyDescription;
//     // if (this.identityVerificationDoc != null) {
//     //   data['identityVerificationDoc'] =
//     //       this.identityVerificationDoc!.map((v) => v.toJson()).toList();
//     // }
//     data['otp'] = this.otp;
//     data['otpExpire'] = this.otpExpire;
//     data['socialMediaLinks'] = this.socialMediaLinks;
//     data['isDeleted'] = this.isDeleted;
//     data['profileComplete'] = this.profileComplete;
//     // if (this.connectedVendors != null) {
//     //   data['connectedVendors'] =
//     //       this.connectedVendors!.map((v) => v.toJson()).toList();
//     // }
//     data['addressLine1'] = this.addressLine1;
//     data['addressLine2'] = this.addressLine2;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
//
// class AlternativeContactNumbers {
//   String? phoneCode;
//   String? contactNumber;
//   String? emoji;
//   String? sId;
//
//   AlternativeContactNumbers(
//       {this.phoneCode, this.contactNumber, this.emoji, this.sId});
//
//   AlternativeContactNumbers.fromJson(Map<String, dynamic> json) {
//     phoneCode = json['phoneCode'];
//     contactNumber = json['contactNumber'];
//     emoji = json['emoji'];
//     sId = json['_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['phoneCode'] = phoneCode;
//     data['contactNumber'] = contactNumber;
//     data['emoji'] = emoji;
//     data['_id'] = sId;
//     return data;
//   }
// }



