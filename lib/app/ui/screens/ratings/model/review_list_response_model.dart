class ReviewListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  ReviewListData? data;

  ReviewListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  ReviewListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ReviewListData.fromJson(json['data']) : null;
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

class ReviewListData {
  List<ReviewData>? data;
  int? pageCount;
  int? documentCount;

  ReviewListData({this.data, this.pageCount, this.documentCount});

  ReviewListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReviewData>[];
      json['data'].forEach((v) {
        data!.add(ReviewData.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    data['documentCount'] = documentCount;
    return data;
  }
}

class ReviewData {
  String? sId;
  String? userId;
  String? comment;

  // String? propertyId;
  dynamic rating;
  String? firstName;
  String? lastName;
  String? companyLogo;
  String? createdAt;
  String? updatedAt;
  bool? isActive;
  int? iV;

  ReviewData(
      {this.sId,
      this.userId,
      this.comment,
      // this.propertyId,
      this.rating,
      this.firstName,
      this.lastName,
      this.companyLogo,
      this.createdAt,
      this.updatedAt,
      this.isActive,
      this.iV});

  ReviewData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    comment = json['comment'];
    // propertyId = json['propertyId'];
    rating = json['rating'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    isActive = json['isActive'] ?? false;
    companyLogo = json['companyLogo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['comment'] = comment;
    // data['propertyId'] = propertyId;
    data['rating'] = rating;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['isActive'] = isActive;
    data['companyLogo'] = companyLogo;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
