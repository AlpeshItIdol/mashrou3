class AddRatingReviewResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  AddRatingReviewData? data;

  AddRatingReviewResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  AddRatingReviewResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? AddRatingReviewData.fromJson(json['data'])
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

class AddRatingReviewData {
  String? userId;
  String? comment;
  String? propertyId;
  dynamic rating;
  String? firstName;
  String? lastName;
  String? companyLogo;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AddRatingReviewData(
      {this.userId,
      this.comment,
      this.propertyId,
      this.rating,
      this.firstName,
      this.lastName,
      this.companyLogo,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AddRatingReviewData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    comment = json['comment'];
    propertyId = json['propertyId'];
    rating = json['rating'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    companyLogo = json['companyLogo'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['comment'] = comment;
    data['propertyId'] = propertyId;
    data['rating'] = rating;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['companyLogo'] = companyLogo;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
