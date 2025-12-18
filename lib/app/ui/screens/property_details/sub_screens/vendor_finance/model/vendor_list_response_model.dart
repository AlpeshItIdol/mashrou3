class VendorListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  VendorListData? data;

  VendorListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  VendorListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? VendorListData.fromJson(json['data']) : null;
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

class VendorListData {
  List<VendorUserData>? user;
  int? page;
  int? documentCount;

  VendorListData({this.user, this.page, this.documentCount});

  VendorListData.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = <VendorUserData>[];
      json['user'].forEach((v) {
        user!.add(VendorUserData.fromJson(v));
      });
    }
    page = json['page'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['documentCount'] = documentCount;
    return data;
  }
}

class VendorUserData {
  String? sId;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? phoneCode;
  String? email;
  String? userType;
  bool? isActive;
  bool? profileComplete;
  String? createdAt;
  String? companyLogo;
  String? companyName;
  String? companyDesc;
  String? fullName;
  String? country;
  List<String>? portfolios;
  List<VendorCategories>? vendorCategories;

  VendorUserData(
      {this.sId,
      this.firstName,
      this.lastName,
      this.contactNumber,
      this.phoneCode,
      this.email,
      this.userType,
      this.isActive,
      this.profileComplete,
      this.createdAt,
      this.companyLogo,
      this.companyName,
      this.companyDesc,
      this.fullName,
      this.country,
      this.portfolios,
      this.vendorCategories});

  VendorUserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    contactNumber = json['contactNumber'];
    phoneCode = json['phoneCode'];
    email = json['email'];
    userType = json['userType'];
    isActive = json['isActive'];
    profileComplete = json['profileComplete'];
    createdAt = json['createdAt'];
    companyLogo = json['companyLogo'];
    companyName = json['companyName'];
    companyDesc = json['companyLogo'];
    fullName = json['fullName'];
    country = json['country'];
    portfolios = (json['portfolio'] as List?)?.cast<String>() ?? [];
    if (json['vendorCategories'] != null) {
      vendorCategories = <VendorCategories>[];
      json['vendorCategories'].forEach((v) {
        vendorCategories!.add(VendorCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['contactNumber'] = contactNumber;
    data['phoneCode'] = phoneCode;
    data['email'] = email;
    data['userType'] = userType;
    data['isActive'] = isActive;
    data['profileComplete'] = profileComplete;
    data['createdAt'] = createdAt;
    data['companyLogo'] = companyLogo;
    data['companyName'] = companyName;
    data['companyName'] = companyDesc;
    data['fullName'] = fullName;
    data['country'] = country;
    data['portfolio'] = portfolios;
    if (vendorCategories != null) {
      data['vendorCategories'] =
          vendorCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorCategories {
  String? sId;
  String? title;
  String? description;

  VendorCategories({this.sId, this.title, this.description});

  VendorCategories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
