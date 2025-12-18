class CityListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  CityListData? cityListData;

  CityListResponseModel(
      {this.statusCode, this.success, this.message, this.cityListData});

  CityListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    cityListData =
        json['data'] != null ? CityListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (cityListData != null) {
      data['data'] = cityListData!.toJson();
    }
    return data;
  }
}

class CityListData {
  String? sId;
  String? name;
  String? iso2;
  String? phoneCode;
  int? pageCount;
  int? documentCount;
  List<Cities>? cities;

  CityListData({this.sId, this.name, this.iso2, this.phoneCode, this.cities});

  CityListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    iso2 = json['iso2'];
    phoneCode = json['phone_code'];
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['iso2'] = iso2;
    data['phone_code'] = phoneCode;
    data['pageCount'] = pageCount;
    data['documentCount'] = documentCount;
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String? sId;
  String? name;

  Cities({this.sId, this.name});

  Cities.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}
