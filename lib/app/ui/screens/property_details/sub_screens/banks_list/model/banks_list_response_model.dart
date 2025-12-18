

class BanksListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  BanksListData? data;

  BanksListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  BanksListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    // Handle different response structures
    if (json['data'] != null) {
      if (json['data'] is Map) {
        data = BanksListData.fromJson(json['data'] as Map<String, dynamic>);
      } else if (json['data'] is List) {
        // If data is directly a list, wrap it in BanksListData
        final listData = <String, dynamic>{'user': json['data']};
        data = BanksListData.fromJson(listData);
      }
    } else {
      // If no data key, try to parse the entire json as data
      data = BanksListData.fromJson(json);
    }
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

class BanksListData {
  List<BankUser>? bankUser;
  int? page;
  int? documentCount;

  BanksListData({this.bankUser, this.page, this.documentCount});

  BanksListData.fromJson(Map<String, dynamic> json) {
    // Handle different possible keys for the banks list
    if (json['bank'] != null) {
      bankUser = <BankUser>[];
      if (json['bank'] is List) {
        json['bank'].forEach((v) {
          bankUser!.add(BankUser.fromJson(v));
        });
      }
    } else if (json['user'] != null) {
      bankUser = <BankUser>[];
      if (json['user'] is List) {
        json['user'].forEach((v) {
          bankUser!.add(BankUser.fromJson(v));
        });
      }
    } else if (json['banks'] != null) {
      bankUser = <BankUser>[];
      if (json['banks'] is List) {
        json['banks'].forEach((v) {
          bankUser!.add(BankUser.fromJson(v));
        });
      }
    } else if (json['data'] != null && json['data'] is List) {
      bankUser = <BankUser>[];
      json['data'].forEach((v) {
        bankUser!.add(BankUser.fromJson(v));
      });
    }
    page = json['page'] ?? json['pageCount'];
    documentCount = json['documentCount'] ?? json['total'] ?? json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bankUser != null) {
      data['user'] = bankUser!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['documentCount'] = documentCount;
    return data;
  }
}

class BankUser {
  String? sId;
  List<BankOffers>? offers;
  String? bankId;
  String? bankName;
  String? companyName;
  String? companyLogo;
  List<BanksAlternativeContact>? banksAlternativeContact;
  BankLocation? bankLocation;

  BankUser(
      {this.sId,
      this.offers,
      this.bankId,
      this.bankName,
      this.companyName,
      this.companyLogo,
      this.banksAlternativeContact,
      this.bankLocation});

  BankUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['offers'] != null) {
      offers = <BankOffers>[];
      json['offers'].forEach((v) {
        offers!.add(BankOffers.fromJson(v));
      });
    }
    // Use _id as bankId if bankId is not provided
    bankId = json['bankId'] ?? json['_id'];
    // Use companyName as bankName if bankName is not provided
    bankName = json['bankName'] ?? json['companyName'];
    companyName = json['companyName'];
    companyLogo = json['companyLogo'];
    if (json['banksAlternativeContact'] != null) {
      banksAlternativeContact = <BanksAlternativeContact>[];
      json['banksAlternativeContact'].forEach((v) {
        banksAlternativeContact!.add(BanksAlternativeContact.fromJson(v));
      });
    }
    bankLocation = json['bankLocation'] != null
        ? BankLocation.fromJson(json['bankLocation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    data['bankId'] = bankId;
    data['bankName'] = bankName;
    data['companyName'] = companyName;
    data['companyLogo'] = companyLogo;
    if (banksAlternativeContact != null) {
      data['banksAlternativeContact'] =
          banksAlternativeContact!.map((v) => v.toJson()).toList();
    }
    if (bankLocation != null) {
      data['bankLocation'] = bankLocation!.toJson();
    }
    return data;
  }
}

class BankOffers {
  String? sId;
  String? offerDescription;
  String? title;
  String? image;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  BankOffers(
      {this.sId,
      this.offerDescription,
      this.title,
        this.image,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  BankOffers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    offerDescription = json['offerDescription'];
    title = json['title'];
    image = json['image'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['offerDescription'] = offerDescription;
    data['title'] = title;
    data['image'] = image;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class BanksAlternativeContact {
  String? phoneCode;
  String? contactNumber;
  String? name;
  String? sId;

  BanksAlternativeContact(
      {this.phoneCode, this.contactNumber, this.name, this.sId});

  BanksAlternativeContact.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'];
    contactNumber = json['contactNumber'];
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneCode'] = phoneCode;
    data['contactNumber'] = contactNumber;
    data['name'] = name;
    data['_id'] = sId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['city'] = city;
    data['country'] = country;
    return data;
  }
}
