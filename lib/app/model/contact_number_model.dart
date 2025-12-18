class ContactNumberModel {
  String? phoneCode;
  String? countryCode;
  String? contactNumber;
  String? emoji;

  ContactNumberModel({this.phoneCode, this.countryCode, this.contactNumber, this.emoji});

  ContactNumberModel.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phoneCode'];
    countryCode = json['countryCode'];
    contactNumber = json['contactNumber'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneCode'] = this.phoneCode;
    data['countryCode'] = this.countryCode;
    data['contactNumber'] = this.contactNumber;
    data['emoji'] = this.emoji;
    return data;
  }
}
