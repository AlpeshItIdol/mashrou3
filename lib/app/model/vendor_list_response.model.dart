class VendorListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<VendorListData>? data;

  VendorListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  VendorListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VendorListData>[];
      json['data'].forEach((v) {
        data!.add(new VendorListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorListData {
  String? sId;
  bool? isActive;
  bool? isVendorCreated;
  String? title;

  VendorListData({this.sId, this.isActive, this.isVendorCreated, this.title});

  VendorListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isVendorCreated = json['isVendorCreated'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['isActive'] = isActive;
    data['isVendorCreated'] = isVendorCreated;
    data['title'] = title;
    return data;
  }
}
