class ApplyOfferResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  ApplyOfferResponseData? data;

  ApplyOfferResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  ApplyOfferResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? ApplyOfferResponseData.fromJson(json['data'])
        : null;
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

class ApplyOfferResponseData {
  String? sId;
  String? vendorId;
  String? propertyId;
  int? iV;
  String? createdAt;
  List<String>? offersIds;
  String? updatedAt;

  ApplyOfferResponseData(
      {this.sId,
      this.vendorId,
      this.propertyId,
      this.iV,
      this.createdAt,
      this.offersIds,
      this.updatedAt});

  ApplyOfferResponseData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    vendorId = json['vendorId'];
    propertyId = json['propertyId'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    offersIds = json['offersIds'].cast<String>();
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['vendorId'] = vendorId;
    data['propertyId'] = propertyId;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['offersIds'] = offersIds;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
