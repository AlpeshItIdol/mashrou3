class SoldOutPropertyRequestModel {
  String? propertyId;

  SoldOutPropertyRequestModel({this.propertyId});

  SoldOutPropertyRequestModel.fromJson(Map<String, dynamic> json) {
    propertyId = json['propertyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['propertyId'] = propertyId;

    return data;
  }
}
