class NeighborhoodPropertyModel {
  double? latitude;
  double? longitude;
  String? address;
  String? neighborhoodType;

  NeighborhoodPropertyModel({this.latitude, this.longitude, this.address, this.neighborhoodType});

  NeighborhoodPropertyModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    neighborhoodType = json['neighborhoodType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['neighborhoodType'] = this.neighborhoodType;
    return data;
  }
}
