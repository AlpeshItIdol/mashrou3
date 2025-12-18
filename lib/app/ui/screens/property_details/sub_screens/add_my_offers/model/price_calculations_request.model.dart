class PriceCalculationsRequestModel {
  String? offerType;
  String? type;
  bool? isAllProperty;
  List<String>? propertyIds;
  String? startDate;
  String? endDate;

  PriceCalculationsRequestModel({
    this.offerType,
    this.type,
    this.isAllProperty,
    this.propertyIds,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offerType'] = offerType;
    data['type'] = type;
    data['isAllProperty'] = isAllProperty;
    data['propertyIds'] = propertyIds;
    if (startDate != null) {
      data['start_date'] = startDate;
    }
    if (endDate != null) {
      data['end_date'] = endDate;
    }
    return data;
  }
}

