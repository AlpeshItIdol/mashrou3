class ApplyOfferRequestModel {
  List<String>? propertyIds;
  List<String>? offersIds;
  bool? isMultiple;
  String? action;

  ApplyOfferRequestModel({this.propertyIds, this.offersIds, this.isMultiple, this.action});

  ApplyOfferRequestModel.fromJson(Map<String, dynamic> json) {
    isMultiple = json['isMultiple'];
    propertyIds = json['propertyId'];
    offersIds = json['offersIds'].cast<String>();
    action= json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isMultiple'] = isMultiple;
    data['propertyId'] = propertyIds;
    data['offersIds'] = offersIds;
    data['action'] = action;
    return data;
  }
}
