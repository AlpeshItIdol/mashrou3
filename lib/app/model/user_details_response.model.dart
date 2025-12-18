class UserDetailsResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  UserStatusData? data;

  UserDetailsResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  UserDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserStatusData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserStatusData {
  String? sId;
  bool? isVerified;
  bool? isActive;
  bool? profileComplete;

  UserStatusData(
      {this.sId, this.isVerified, this.isActive, this.profileComplete});

  UserStatusData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    profileComplete = json['profileComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['isVerified'] = isVerified;
    data['isActive'] = isActive;
    data['profileComplete'] = profileComplete;
    return data;
  }
}
