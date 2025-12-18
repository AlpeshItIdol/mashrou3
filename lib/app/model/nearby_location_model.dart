import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearByLocationModel {
  LatLng? locationLatLng;
  String? location;
  String? neighborhoodType;

  NearByLocationModel(
      {this.location, this.locationLatLng, this.neighborhoodType});

  NearByLocationModel.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    locationLatLng = json['locationLatLng'];
    neighborhoodType = json['neighborhoodType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    data['neighborhoodType'] = neighborhoodType;
    data['locationLatLng'] = locationLatLng;
    return data;
  }
}
