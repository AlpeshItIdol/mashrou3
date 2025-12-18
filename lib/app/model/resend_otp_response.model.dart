class ResendOtpResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  String? data;

  ResendOtpResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
