class AddRemoveFavRequestModel {
  String? propertyId;
  bool? isFavorite;

  AddRemoveFavRequestModel({this.propertyId, this.isFavorite});

  AddRemoveFavRequestModel.fromJson(Map<String, dynamic> json) {
    propertyId = json['propertyId'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['propertyId'] = propertyId;
    data['isFavorite'] = isFavorite;
    return data;
  }
}
