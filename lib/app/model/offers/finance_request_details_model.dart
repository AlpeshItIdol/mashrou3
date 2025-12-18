class FinanceRequestDetailsModel {
  int? statusCode;
  bool? success;
  String? message;
  FinanceRequestDetailsData? data;

  FinanceRequestDetailsModel({this.statusCode, this.success, this.message, this.data});

  FinanceRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? FinanceRequestDetailsData.fromJson(json['data']) : null;
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

class FinanceRequestDetailsData {
  String? id;
  String? visitorId;
  Property? property;
  String? vendorId;
  String? bankId;
  bool? isApproved;
  bool? isDeleted;
  String? financeType;
  String? paymentMethod;
  VisitorData? visitorData;
  String? createdAt;
  String? updatedAt;
  Offer? offerId;
  String? thumbnail;

  FinanceRequestDetailsData(
      {this.id,
      this.visitorId,
      this.property,
      this.vendorId,
      this.bankId,
      this.isApproved,
      this.isDeleted,
      this.financeType,
      this.paymentMethod,
      this.visitorData,
      this.createdAt,
      this.updatedAt,
      this.offerId,
      this.thumbnail});

  FinanceRequestDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    visitorId = json['visitorId'];
    property = json['propertyId'] != null ? Property.fromJson(json['propertyId']) : null;
    vendorId = json['vendorId'];
    bankId = json['bankId'];
    isApproved = json['isApproved'];
    isDeleted = json['isDeleted'];
    financeType = json['financeType'];
    paymentMethod = json['paymentMethod'];
    visitorData = json['visitorData'] != null ? VisitorData.fromJson(json['visitorData']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    offerId = json['offerId'] != null ? Offer.fromJson(json['offerId']) : null;
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['visitorId'] = visitorId;
    if (property != null) {
      data['propertyId'] = property!.toJson();
    }
    data['vendorId'] = vendorId;
    data['bankId'] = bankId;
    data['isApproved'] = isApproved;
    data['isDeleted'] = isDeleted;
    data['financeType'] = financeType;
    data['paymentMethod'] = paymentMethod;
    if (visitorData != null) {
      data['visitorData'] = visitorData!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (offerId != null) {
      data['offerId'] = offerId!.toJson();
    }
    data['thumbnail'] = thumbnail;
    return data;
  }
}

class Property {
  String? id;
  String? title;
  String? description;
  List<String>? propertyFiles;
  String? thumbnail;

  Property({this.id, this.title, this.propertyFiles,this.description,this.thumbnail});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    propertyFiles = (json['propertyFiles'] as List?)?.cast<String>() ?? [];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'title': title, 'propertyFiles': propertyFiles, 'description': description};
  }
}

class VisitorData {
  String? firstName;
  String? profileImage;
  String? lastName;
  String? email;
  String? contactNumber;
  String? phoneCode;

  VisitorData({this.firstName, this.lastName, this.email, this.contactNumber, this.phoneCode});

  VisitorData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    phoneCode = json['phoneCode'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'contactNumber': contactNumber,
      'phoneCode': phoneCode,
      'profileImage': profileImage,
    };
  }
}

class Offer {
  String? id;
  Price? price;
  String? description;
  String? title;
  bool? isDeleted;
  String? vendorId;
  String? vendorFirstName;
  String? vendorLastName;
  String? createdAt;
  String? updatedAt;

  Offer({
    this.id,
    this.price,
    this.description,
    this.title,
    this.isDeleted,
    this.vendorId,
    this.vendorFirstName,
    this.vendorLastName,
    this.createdAt,
    this.updatedAt,
  });

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    description = json['description'];
    title = json['title'];
    isDeleted = json['isDeleted'];
    vendorId = json['vendorId'];
    vendorFirstName = json['vendorFirstName'];
    vendorLastName = json['vendorLastName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'price': price?.toJson(),
      'description': description,
      'title': title,
      'isDeleted': isDeleted,
      'vendorId': vendorId,
      'vendorFirstName': vendorFirstName,
      'vendorLastName': vendorLastName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Price {
  String? amount;
  String? currencyCode;
  String? currencySymbol;

  Price({this.amount, this.currencyCode, this.currencySymbol});

  Price.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
    };
  }
}
