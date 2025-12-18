

class PropertyCategoryResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<PropertyCategoryData>? data;

  PropertyCategoryResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory PropertyCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return PropertyCategoryResponseModel(
      statusCode: json['statusCode'] as int?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) =>
              PropertyCategoryData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class PropertyCategoryData {
  String? sId;
  String? name;

  PropertyCategoryData({
    this.sId,
    this.name,
  });

  PropertyCategoryData.fromJson(Map<String, dynamic> json) {
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
