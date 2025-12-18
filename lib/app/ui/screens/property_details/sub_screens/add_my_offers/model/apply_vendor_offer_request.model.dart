class ApplyVendorOfferRequestModel {
  List<String>? propertyId;
  List<String>? offersIds;
  String? offerType;
  List<PropertyData>? propertiesData;
  FinalSum? finalSum;
  String? action;
  bool? isAllProperty;
  String? startDate;
  String? endDate;
  int? totalDays;

  ApplyVendorOfferRequestModel({
    this.propertyId,
    this.offersIds,
    this.offerType,
    this.propertiesData,
    this.finalSum,
    this.action,
    this.isAllProperty,
    this.startDate,
    this.endDate,
    this.totalDays,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = propertyId;
    data['offersIds'] = offersIds;
    data['offerType'] = offerType;
    if (propertiesData != null) {
      data['propertiesData'] = propertiesData!.map((v) => v.toJson()).toList();
    }
    if (finalSum != null) {
      data['finalSum'] = finalSum!.toJson();
    }
    data['action'] = action;
    data['isAllProperty'] = isAllProperty;
    if (startDate != null) {
      data['startDate'] = startDate;
    }
    if (endDate != null) {
      data['endDate'] = endDate;
    }
    if (totalDays != null) {
      data['totalDays'] = totalDays;
    }
    return data;
  }
}

class PropertyData {
  String? propertyId;
  double? pricing;
  Rate? timedRate;
  Rate? lifetimeRate;
  double? originalAmount;

  PropertyData({
    this.propertyId,
    this.pricing,
    this.timedRate,
    this.lifetimeRate,
    this.originalAmount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = propertyId;
    data['pricing'] = pricing;
    if (timedRate != null) {
      data['timed_rate'] = timedRate!.toJson();
    }
    if (lifetimeRate != null) {
      data['lifetime_rate'] = lifetimeRate!.toJson();
    }
    data['originalAmount'] = originalAmount;
    return data;
  }
}

class Rate {
  String? amount;
  String? currencyCode;
  String? currencySymbol;

  Rate({
    this.amount,
    this.currencyCode,
    this.currencySymbol,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    return data;
  }
}

class FinalSum {
  double? amount;
  String? currencyCode;
  String? currencySymbol;

  FinalSum({
    this.amount,
    this.currencyCode,
    this.currencySymbol,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    return data;
  }
}

