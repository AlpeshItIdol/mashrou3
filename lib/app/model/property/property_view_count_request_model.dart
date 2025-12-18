class PropertyViewCountRequestModel {
  String? propertyId;

  PropertyViewCountRequestModel({this.propertyId});

  PropertyViewCountRequestModel.fromJson(Map<String, dynamic> json) {
    propertyId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = propertyId;
    return data;
  }
}
