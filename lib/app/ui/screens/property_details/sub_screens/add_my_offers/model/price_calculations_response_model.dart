class PriceCalculationsResponseModel {
  bool? success;
  String? message;
  PriceCalculationsData? data;

  PriceCalculationsResponseModel({this.success, this.message, this.data});

  PriceCalculationsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? PriceCalculationsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PriceCalculationsData {
  String? offerType;
  String? startDate;
  String? endDate;
  int? totalDays;
  int? totalSelectedProperty;
  double? totalAmount;
  String? currency;
  String? currencySymbol;
  List<PropertyPricingData>? propertiesData;
  FinalSumData? finalSum;

  PriceCalculationsData({
    this.offerType,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.totalSelectedProperty,
    this.totalAmount,
    this.currency,
    this.currencySymbol,
    this.propertiesData,
    this.finalSum,
  });

  PriceCalculationsData.fromJson(Map<String, dynamic> json) {
    // Parse properties_Data (with underscore) or propertiesData (camelCase)
    if (json['properties_Data'] != null || json['propertiesData'] != null) {
      propertiesData = <PropertyPricingData>[];
      final propertiesList = json['properties_Data'] ?? json['propertiesData'];
      if (propertiesList != null) {
        propertiesList.forEach((v) {
          propertiesData!.add(PropertyPricingData.fromJson(v));
        });
      }
    }
    
    // Get offerType, startDate, endDate, totalDays from first property if available
    if (propertiesData != null && propertiesData!.isNotEmpty) {
      final firstProperty = propertiesData!.first;
      offerType = firstProperty.offerType;
      startDate = firstProperty.startDate;
      endDate = firstProperty.endDate;
      totalDays = firstProperty.totalDays;
    }
    
    // Get totalSelectedProperty from properties_Data length
    totalSelectedProperty = propertiesData?.length ?? 0;
    
    // Get totalAmount from final_sum
    if (json['final_sum'] != null || json['finalSum'] != null) {
      finalSum = FinalSumData.fromJson(json['final_sum'] ?? json['finalSum']);
      totalAmount = finalSum?.amount;
      currency = finalSum?.currencyCode;
      currencySymbol = finalSum?.currencySymbol;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offerType'] = offerType;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['totalDays'] = totalDays;
    data['totalSelectedProperty'] = totalSelectedProperty;
    data['totalAmount'] = totalAmount;
    data['currency'] = currency;
    data['currencySymbol'] = currencySymbol;
    if (propertiesData != null) {
      data['propertiesData'] = propertiesData!.map((v) => v.toJson()).toList();
    }
    if (finalSum != null) {
      data['finalSum'] = finalSum!.toJson();
    }
    return data;
  }
}

class PropertyPricingData {
  String? propertyId;
  String? offerType;
  double? pricing;
  RateData? timedRate;
  RateData? lifetimeRate;
  double? originalAmount;
  String? vendorCategoryId;
  String? userId;
  String? startDate;
  String? endDate;
  int? totalDays;

  PropertyPricingData({
    this.propertyId,
    this.offerType,
    this.pricing,
    this.timedRate,
    this.lifetimeRate,
    this.originalAmount,
    this.vendorCategoryId,
    this.userId,
    this.startDate,
    this.endDate,
    this.totalDays,
  });

  PropertyPricingData.fromJson(Map<String, dynamic> json) {
    propertyId = json['propertyId'];
    offerType = json['offerType'];
    pricing = json['pricing'] != null ? (json['pricing'] is int ? json['pricing'].toDouble() : json['pricing']) : null;
    timedRate = json['timed_rate'] != null ? RateData.fromJson(json['timed_rate']) : null;
    lifetimeRate = json['lifetime_rate'] != null ? RateData.fromJson(json['lifetime_rate']) : null;
    originalAmount = json['originalAmount'] != null ? (json['originalAmount'] is int ? json['originalAmount'].toDouble() : json['originalAmount']) : null;
    vendorCategoryId = json['vendorCategoryId'];
    userId = json['userId'];
    startDate = json['start_date'] ?? json['startDate'];
    endDate = json['end_date'] ?? json['endDate'];
    totalDays = json['totalDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = propertyId;
    data['offerType'] = offerType;
    data['pricing'] = pricing;
    if (timedRate != null) {
      data['timed_rate'] = timedRate!.toJson();
    }
    if (lifetimeRate != null) {
      data['lifetime_rate'] = lifetimeRate!.toJson();
    }
    data['originalAmount'] = originalAmount;
    data['vendorCategoryId'] = vendorCategoryId;
    data['userId'] = userId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['totalDays'] = totalDays;
    return data;
  }
}

class RateData {
  String? amount;
  String? currencyCode;
  String? currencySymbol;

  RateData({
    this.amount,
    this.currencyCode,
    this.currencySymbol,
  });

  RateData.fromJson(Map<String, dynamic> json) {
    amount = json['amount']?.toString();
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    return data;
  }
}

class FinalSumData {
  double? amount;
  String? currencyCode;
  String? currencySymbol;

  FinalSumData({
    this.amount,
    this.currencyCode,
    this.currencySymbol,
  });

  FinalSumData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? (json['amount'] is int ? json['amount'].toDouble() : json['amount'] is double ? json['amount'] : double.tryParse(json['amount'].toString()) ?? 0.0) : null;
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    return data;
  }
}

