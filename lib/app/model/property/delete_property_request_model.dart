class DeletePropertyRequestModel {
  List<String>? propertyIds;

  DeletePropertyRequestModel({this.propertyIds});

  DeletePropertyRequestModel.fromJson(Map<String, dynamic> json) {
    propertyIds = json['propertyIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyIds'] = propertyIds;
    return data;
  }
}
