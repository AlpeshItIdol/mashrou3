class CountryListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<CountryListData>? countryListData;

  CountryListResponseModel(
      {this.statusCode, this.success, this.message, this.countryListData});

  CountryListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      countryListData = <CountryListData>[];
      json['data'].forEach((v) {
        countryListData!.add(CountryListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (countryListData != null) {
      data['data'] = countryListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryListData {
  String? sId;
  String? emoji;
  String? name;
  String? countryCode;
  String? phoneCode;

  CountryListData({this.sId, this.emoji, this.name, this.countryCode, this.phoneCode});

  CountryListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    emoji = json['emoji'];
    name = json['name'];
    countryCode = json['iso2'];
    phoneCode = json['phone_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['emoji'] = emoji;
    data['name'] = name;
    data['iso2'] = countryCode;
    data['phone_code'] = phoneCode;
    return data;
  }
}
