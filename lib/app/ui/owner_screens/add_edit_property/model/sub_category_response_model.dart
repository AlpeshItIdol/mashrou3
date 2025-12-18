class SubCategoryResponseModel {
  int? statusCode;
  bool? success;
  List<PropertySubCategoryData>? data;

  SubCategoryResponseModel({this.statusCode, this.success, this.data});

  SubCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <PropertySubCategoryData>[];
      json['data'].forEach((v) {
        data!.add(PropertySubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertySubCategoryData {
  String? name;
  String? sId;
  String? categoryId;

  PropertySubCategoryData({this.name, this.sId, this.categoryId});

  PropertySubCategoryData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['_id'] = sId;
    data['categoryId'] = categoryId;
    return data;
  }
}
