class AddFinanceRequestResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  AddFinanceRequestData? data;

  AddFinanceRequestResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  AddFinanceRequestResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new AddFinanceRequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AddFinanceRequestData {
  String? visitorId;
  String? propertyId;
  String? vendorId;
  String? bankId;
  String? financeType;
  VisitorData? visitorData;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AddFinanceRequestData(
      {this.visitorId,
        this.propertyId,
        this.vendorId,
        this.bankId,
        this.financeType,
        this.visitorData,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AddFinanceRequestData.fromJson(Map<String, dynamic> json) {
    visitorId = json['visitorId'];
    propertyId = json['propertyId'];
    vendorId = json['vendorId'];
    bankId = json['bankId'];
    financeType = json['financeType'];
    visitorData = json['visitorData'] != null
        ? new VisitorData.fromJson(json['visitorData'])
        : null;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorId'] = this.visitorId;
    data['propertyId'] = this.propertyId;
    data['vendorId'] = this.vendorId;
    data['bankId'] = this.bankId;
    data['financeType'] = this.financeType;
    if (this.visitorData != null) {
      data['visitorData'] = this.visitorData!.toJson();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class VisitorData {
  String? firstName;
  String? lastName;
  String? email;
  String? contactNumber;
  String? phoneCode;

  VisitorData(
      {this.firstName,
        this.lastName,
        this.email,
        this.contactNumber,
        this.phoneCode});

  VisitorData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    phoneCode = json['phoneCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['contactNumber'] = this.contactNumber;
    data['phoneCode'] = this.phoneCode;
    return data;
  }
}
