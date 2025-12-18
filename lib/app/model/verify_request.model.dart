class VerifyRequestModel {
  String? otp;
  String? contactNumber;
  String? phoneCode;

  VerifyRequestModel({this.otp,this.contactNumber,this.phoneCode});

  VerifyRequestModel.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    contactNumber = json['contactNumber'];
    phoneCode = json['phoneCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['contactNumber'] = contactNumber;
    data['phoneCode'] = phoneCode;
    return data;
  }
}
