class SignUpRequestModel {
  String? userType;
  String? country;
  String? phoneCode;
  String? contactNumber;

  SignUpRequestModel({this.userType, this.country, this.contactNumber, this.phoneCode});

  SignUpRequestModel.fromJson(Map<String, dynamic> json) {
    userType = json['userType'];
    country = json['country'];
    phoneCode = json['phoneCode'];
    contactNumber = json['contactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userType'] = userType;
    data['country'] = country;
    data['phoneCode'] = phoneCode;
    data['contactNumber'] = contactNumber;
    return data;
  }
}
