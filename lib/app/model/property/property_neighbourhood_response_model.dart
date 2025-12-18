class PropertyNeighbourhoodResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<PropertyNeighbourhoodData>? data;

  PropertyNeighbourhoodResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory PropertyNeighbourhoodResponseModel.fromJson(
      Map<String, dynamic> json) {
    return PropertyNeighbourhoodResponseModel(
      statusCode: json['statusCode'] as int?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) =>
              PropertyNeighbourhoodData.fromJson(item as Map<String, dynamic>))
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

class PropertyNeighbourhoodData {
  String? sId;
  String? name;

  PropertyNeighbourhoodData({
    this.sId,
    this.name,
  });

  PropertyNeighbourhoodData.fromJson(Map<String, dynamic> json) {
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
