class FinanceRequestListResponse {
  int? statusCode;
  bool? success;
  String? message;
  FinanceRequestData? data;

  FinanceRequestListResponse(
      {this.statusCode, this.success, this.message, this.data});

  FinanceRequestListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? FinanceRequestData.fromJson(json['data']) : null;
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

class FinanceRequestData {
  List<FinanceRequest>? financeData;
  int? pageCount;
  int? documentCount;

  FinanceRequestData({this.financeData, this.pageCount, this.documentCount});

  FinanceRequestData.fromJson(Map<String, dynamic> json) {
    if (json['financeData'] != null) {
      financeData = <FinanceRequest>[];
      json['financeData'].forEach((v) {
        financeData!.add(FinanceRequest.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (financeData != null) {
      data['financeData'] = financeData!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    data['documentCount'] = documentCount;
    return data;
  }
}

class FinanceRequest {
  String? sId;
  String? visitorId;
  PropertyId? propertyId;
  String? bankId;
  String? vendorId;
  bool? isApproved;
  bool? isDeleted;
  String? financeType;
  String? paymentMethod;
  VisitorData? visitorData;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FinanceRequest(
      {this.sId,
        this.visitorId,
        this.propertyId,
        this.bankId,
        this.vendorId,
        this.isApproved,
        this.isDeleted,
        this.financeType,
        this.paymentMethod,
        this.visitorData,
        this.createdAt,
        this.updatedAt,
        this.iV});

  FinanceRequest.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    visitorId = json['visitorId'];
    propertyId = json['propertyId'] != null
        ? PropertyId.fromJson(json['propertyId'])
        : null;
    bankId = json['bankId'];
    vendorId = json['vendorId'];
    isApproved = json['isApproved'];
    isDeleted = json['isDeleted'];
    financeType = json['financeType'];
    paymentMethod = json['paymentMethod'];
    visitorData = json['visitorData'] != null
        ? VisitorData.fromJson(json['visitorData'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['visitorId'] = visitorId;
    if (propertyId != null) {
      data['propertyId'] = propertyId!.toJson();
    }
    data['bankId'] = bankId;
    data['vendorId'] = vendorId;
    data['isApproved'] = isApproved;
    data['isDeleted'] = isDeleted;
    data['financeType'] = financeType;
    data['paymentMethod'] = paymentMethod;
    if (visitorData != null) {
      data['visitorData'] = visitorData!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class PropertyId {
  String? sId;
  String? title;

  PropertyId({this.sId, this.title});

  PropertyId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['phoneCode'] = phoneCode;
    return data;
  }
}
