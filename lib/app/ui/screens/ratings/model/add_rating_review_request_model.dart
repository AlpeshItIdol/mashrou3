class AddRatingReviewRequestModel {
  String? userId;
  String? propertyId;
  String? comment;
  dynamic rating;

  AddRatingReviewRequestModel(
      {this.userId, this.propertyId, this.comment, this.rating});

  AddRatingReviewRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    propertyId = json['propertyId'];
    comment = json['comment'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['propertyId'] = propertyId;
    data['comment'] = comment;
    data['rating'] = rating;
    return data;
  }
}
