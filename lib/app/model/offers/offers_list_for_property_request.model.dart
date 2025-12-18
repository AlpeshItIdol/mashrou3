class OffersListForPropertyRequestModel {
  String? propertyId;

  OffersListForPropertyRequestModel(
      {this.propertyId, });

  OffersListForPropertyRequestModel.fromJson(Map<String, dynamic> json) {
    propertyId = json['propertyId'];
   }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = propertyId;
    return data;
  }
}
