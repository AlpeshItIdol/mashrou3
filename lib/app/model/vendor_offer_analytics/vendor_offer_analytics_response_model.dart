class VendorOfferAnalyticsResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  VendorOfferAnalyticsData? data;

  VendorOfferAnalyticsResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  VendorOfferAnalyticsResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? VendorOfferAnalyticsData.fromJson(json['data'])
        : null;
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

class VendorOfferAnalyticsData {
  List<VendorOfferAnalyticsOffer>? offers;
  int? pageCount;
  int? page;
  int? documentCount;

  VendorOfferAnalyticsData({
    this.offers,
    this.pageCount,
    this.page,
    this.documentCount,
  });

  VendorOfferAnalyticsData.fromJson(Map<String, dynamic> json) {
    if (json['offers'] != null) {
      offers = <VendorOfferAnalyticsOffer>[];
      json['offers'].forEach((v) {
        offers!.add(VendorOfferAnalyticsOffer.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    page = json['page'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    data['page'] = page;
    data['documentCount'] = documentCount;
    return data;
  }
}

class VendorOfferAnalyticsOffer {
  int? offerAppliedCount;
  int? vendorCashCount;
  int? vendorFinanceCount;
  String? offerId;
  AnalyticsPrice? price;
  String? offerTitle;
  String? userId;
  String? companyLogo;
  String? companyName;
  String? vendorCategory;
  AnalyticsData? analyticsData;

  VendorOfferAnalyticsOffer({
    this.offerAppliedCount,
    this.vendorCashCount,
    this.vendorFinanceCount,
    this.offerId,
    this.price,
    this.offerTitle,
    this.userId,
    this.companyLogo,
    this.companyName,
    this.vendorCategory,
    this.analyticsData,
  });

  VendorOfferAnalyticsOffer.fromJson(Map<String, dynamic> json) {
    offerAppliedCount = json['offerAppliedCount'];
    vendorCashCount = json['vendorCashCount'];
    vendorFinanceCount = json['vendorFinanceCount'];
    offerId = json['offerId'];
    price = json['price'] != null ? AnalyticsPrice.fromJson(json['price']) : null;
    offerTitle = json['offerTitle'];
    userId = json['userId'];
    companyLogo = json['companyLogo'];
    companyName = json['companyName'];
    vendorCategory = json['vendorCategory'];
    analyticsData = json['analyticsData'] != null
        ? AnalyticsData.fromJson(json['analyticsData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offerAppliedCount'] = offerAppliedCount;
    data['vendorCashCount'] = vendorCashCount;
    data['vendorFinanceCount'] = vendorFinanceCount;
    data['offerId'] = offerId;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['offerTitle'] = offerTitle;
    data['userId'] = userId;
    data['companyLogo'] = companyLogo;
    data['companyName'] = companyName;
    data['vendorCategory'] = vendorCategory;
    if (analyticsData != null) {
      data['analyticsData'] = analyticsData!.toJson();
    }
    return data;
  }
}

class AnalyticsPrice {
  String? amount;
  String? currencyCode;
  String? currencySymbol;

  AnalyticsPrice({
    this.amount,
    this.currencyCode,
    this.currencySymbol,
  });

  AnalyticsPrice.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
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

class AnalyticsData {
  int? propertyOfferCount;

  AnalyticsData({
    this.propertyOfferCount,
  });

  AnalyticsData.fromJson(Map<String, dynamic> json) {
    propertyOfferCount = json['propertyOfferCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyOfferCount'] = propertyOfferCount;
    return data;
  }
}

