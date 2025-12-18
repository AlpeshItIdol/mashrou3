import 'package:mashrou3/app/ui/screens/property_details/sub_screens/bank_details/model/bank_property_offers_response_model.dart';

class BankDetailsResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  BankDetailsData? data;

  BankDetailsResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  BankDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? BankDetailsData.fromJson(json['data']) : null;
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

class BankDetailsData {
  String? sId;
  String? bankOfferSummary;
  String? email;
  String? companyLogo;
  String? companyName;
  List<BanksAlternativeContact>? banksAlternativeContact;
  BankTerm? bankterm;
  String? country;
  List<BankPropertyOffersData>? offersList;

  BankDetailsData(
      {this.sId,
      this.bankOfferSummary,
      this.email,
      this.companyLogo,
      this.companyName,
      this.banksAlternativeContact,
      this.bankterm,
      this.country,
      this.offersList});

  BankDetailsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bankOfferSummary = json['bankOfferSummary'];
    email = json['email'];
    companyLogo = json['companyLogo'];
    companyName = json['companyName'];
    if (json['banksAlternativeContact'] != null) {
      banksAlternativeContact = <BanksAlternativeContact>[];
      json['banksAlternativeContact'].forEach((v) {
        banksAlternativeContact!.add(BanksAlternativeContact.fromJson(v));
      });
    }
    if (json['offersList'] != null) {
      offersList = <BankPropertyOffersData>[];
      json['offersList'].forEach((v) {
        offersList!.add(BankPropertyOffersData.fromJson(v));
      });
    } else {
      offersList = [];
    }
    bankterm =
        json['bankterm'] != null ? BankTerm.fromJson(json['bankterm']) : null;
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['bankOfferSummary'] = bankOfferSummary;
    data['companyLogo'] = companyLogo;
    data['companyName'] = companyName;
    data['email'] = email;
    if (banksAlternativeContact != null) {
      data['banksAlternativeContact'] =
          banksAlternativeContact!.map((v) => v.toJson()).toList();
    }
    if (offersList != null) {
      data['offersList'] = offersList!.map((v) => v.toJson()).toList();
    } else {
      offersList = [];
    }
    if (bankterm != null) {
      data['bankterm'] = bankterm!.toJson();
    }
    data['country'] = country;
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

class BankTerm {
  String? sId;
  String? slug;
  Content? content;
  bool? isDeleted;
  String? bankId;
  List<BanksAlternativeContact>? contactNumbers;
  String? createdAt;
  String? updatedAt;
  int? iV;

  BankTerm(
      {this.sId,
      this.slug,
      this.content,
      this.isDeleted,
      this.bankId,
      this.contactNumbers,
      this.createdAt,
      this.updatedAt,
      this.iV});

  BankTerm.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slug = json['slug'];
    content =
        json['content'] != null ? Content.fromJson(json['content']) : null;
    isDeleted = json['isDeleted'];
    bankId = json['bankId'];
    if (json['contactNumbers'] != null) {
      contactNumbers = <BanksAlternativeContact>[];
      json['contactNumbers'].forEach((v) {
        contactNumbers!.add(BanksAlternativeContact.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['slug'] = slug;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    data['isDeleted'] = isDeleted;
    data['bankId'] = bankId;
    if (contactNumbers != null) {
      data['contactNumbers'] = contactNumbers!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Content {
  String? en;
  String? ar;

  Content({this.en, this.ar});

  Content.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['ar'] = ar;
    return data;
  }
}
