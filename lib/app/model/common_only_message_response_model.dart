class CommonOnlyMessageResponseModel {
  int? statusCode;
  bool? success;
  String? message;

  CommonOnlyMessageResponseModel({this.statusCode, this.success, this.message});

  CommonOnlyMessageResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}
