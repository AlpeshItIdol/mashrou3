class BankViewCountRequestModel {
  String? bankId;

  BankViewCountRequestModel({this.bankId});

  BankViewCountRequestModel.fromJson(Map<String, dynamic> json) {
    bankId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = bankId;
    return data;
  }
}
