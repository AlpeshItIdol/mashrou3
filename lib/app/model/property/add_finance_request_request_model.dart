class AddFinanceRequestRequestModel {
  String? propertyId;
  String? bankId;
  String? vendorId;
  String? offerId;

  AddFinanceRequestRequestModel({this.propertyId, this.bankId, this.vendorId, this.offerId});

  AddFinanceRequestRequestModel.fromJson(Map<String, dynamic> json) {
    propertyId = json['propertyId'];
    bankId = json['bankId'];
    vendorId = json['vendorId'];
    offerId = json['offerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = propertyId;
    if (bankId != null) data['bankId'] = bankId;
    if (vendorId != null) data['vendorId'] = vendorId;
    if (offerId != null) data['offerId'] = offerId;
    return data;
  }
}
