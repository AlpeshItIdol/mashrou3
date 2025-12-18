class DeletePropertyInReviewRequestModel {
  List<String>? propertyIds;

  DeletePropertyInReviewRequestModel({this.propertyIds});

  DeletePropertyInReviewRequestModel.fromJson(Map<String, dynamic> json) {
    propertyIds = json['propertyRequestIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyRequestIds'] = propertyIds;
    return data;
  }
}
