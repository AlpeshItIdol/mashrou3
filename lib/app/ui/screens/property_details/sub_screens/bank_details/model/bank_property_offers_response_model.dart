class BankPropertyOffersResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<BankPropertyOffersData>? data;

  BankPropertyOffersResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  BankPropertyOffersResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BankPropertyOffersData>[];
      json['data'].forEach((v) {
        data!.add(BankPropertyOffersData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankPropertyOffersData {
  String? sId;
  String? offerDescription;
  String? title;
  String? image;
  String? bankId;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  BankPropertyOffersData(
      {this.sId,
      this.offerDescription,
      this.title,
        this.image,
      this.bankId,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  BankPropertyOffersData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    offerDescription = json['offerDescription'];
    title = json['title'];
    image = json['image'];
    bankId = json['bankId'];
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
    data['bankId'] = bankId;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
