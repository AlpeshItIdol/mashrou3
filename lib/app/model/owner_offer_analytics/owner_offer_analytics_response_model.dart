class OwnerOfferAnalyticsResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  OwnerOfferAnalyticsData? data;

  OwnerOfferAnalyticsResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  OwnerOfferAnalyticsResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] as int?;
    success = json['success'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? OwnerOfferAnalyticsData.fromJson(json['data'] as Map<String, dynamic>)
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

class OwnerOfferAnalyticsData {
  List<OwnerPropertyAnalytics>? properties;
  int? pageCount;
  int? page;
  int? documentCount;

  OwnerOfferAnalyticsData({
    this.properties,
    this.pageCount,
    this.page,
    this.documentCount,
  });

  OwnerOfferAnalyticsData.fromJson(Map<String, dynamic> json) {
    if (json['properties'] != null) {
      properties = <OwnerPropertyAnalytics>[];
      (json['properties'] as List<dynamic>).forEach((v) {
        properties!.add(OwnerPropertyAnalytics.fromJson(v as Map<String, dynamic>));
      });
    }
    pageCount = json['pageCount'] as int?;
    page = json['page'] as int?;
    documentCount = json['documentCount'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (properties != null) {
      data['properties'] = properties!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    data['page'] = page;
    data['documentCount'] = documentCount;
    return data;
  }
}

class OwnerPropertyAnalytics {
  int? noOfClicks;
  String? lastVisitedAt;
  int? noOfVendors;
  int? noOfBanks;
  int? noOfVisitRequest;
  int? financeCompleted;
  String? id;
  String? title;
  String? country;
  String? city;
  String? createdBy;
  String? subCategoryName;
  String? companyName;
  String? companyLogo;
  int? propertyVendorCount;
  int? propertyBankCount;
  int? visitRequestProperty;
  OwnerFinanceData? financeData;
  OwnerAnalyticsData? analyticsData;

  OwnerPropertyAnalytics({
    this.noOfClicks,
    this.lastVisitedAt,
    this.noOfVendors,
    this.noOfBanks,
    this.noOfVisitRequest,
    this.financeCompleted,
    this.id,
    this.title,
    this.country,
    this.city,
    this.createdBy,
    this.subCategoryName,
    this.companyName,
    this.companyLogo,
    this.propertyVendorCount,
    this.propertyBankCount,
    this.visitRequestProperty,
    this.financeData,
    this.analyticsData,
  });

  OwnerPropertyAnalytics.fromJson(Map<String, dynamic> json) {
    noOfClicks = json['noOfClicks'] as int?;
    lastVisitedAt = json['lastVisitedAt'] as String?;
    noOfVendors = json['noOfVendors'] as int?;
    noOfBanks = json['noOfBanks'] as int?;
    noOfVisitRequest = json['noOfVisitRequest'] as int?;
    financeCompleted = json['financeCompleted'] as int?;
    id = json['_id'] as String?;
    title = json['title'] as String?;
    country = json['country'] as String?;
    city = json['city'] as String?;
    createdBy = json['createdBy'] as String?;
    subCategoryName = json['subCategoryName'] as String?;
    companyName = json['companyName'] as String?;
    companyLogo = json['companyLogo'] as String?;
    propertyVendorCount = json['propertyVendorCount'] as int?;
    propertyBankCount = json['propertyBankCount'] as int?;
    visitRequestProperty = json['visitRequestProperty'] as int?;
    financeData = json['financeData'] != null
        ? OwnerFinanceData.fromJson(json['financeData'] as Map<String, dynamic>)
        : null;
    analyticsData = json['analyticsData'] != null
        ? OwnerAnalyticsData.fromJson(json['analyticsData'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noOfClicks'] = noOfClicks;
    data['lastVisitedAt'] = lastVisitedAt;
    data['noOfVendors'] = noOfVendors;
    data['noOfBanks'] = noOfBanks;
    data['noOfVisitRequest'] = noOfVisitRequest;
    data['financeCompleted'] = financeCompleted;
    data['_id'] = id;
    data['title'] = title;
    data['country'] = country;
    data['city'] = city;
    data['createdBy'] = createdBy;
    data['subCategoryName'] = subCategoryName;
    data['companyName'] = companyName;
    data['companyLogo'] = companyLogo;
    data['propertyVendorCount'] = propertyVendorCount;
    data['propertyBankCount'] = propertyBankCount;
    data['visitRequestProperty'] = visitRequestProperty;
    if (financeData != null) {
      data['financeData'] = financeData!.toJson();
    }
    if (analyticsData != null) {
      data['analyticsData'] = analyticsData!.toJson();
    }
    return data;
  }
}

class OwnerFinanceData {
  int? propertyFinanceCount;
  int? vendorFinanceCount;

  OwnerFinanceData({
    this.propertyFinanceCount,
    this.vendorFinanceCount,
  });

  OwnerFinanceData.fromJson(Map<String, dynamic> json) {
    propertyFinanceCount = json['propertyFinanceCount'] as int?;
    vendorFinanceCount = json['vendorFinanceCount'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyFinanceCount'] = propertyFinanceCount;
    data['vendorFinanceCount'] = vendorFinanceCount;
    return data;
  }
}

class OwnerAnalyticsData {
  int? propertyCount;
  int? propertyFinCount;
  int? propertyShareCount;
  int? propertyDirectCallCount;
  int? propertyVendorFinCount;
  int? propertyVirtualTourCount;
  int? propertyMapCount;
  int? propertyVideoCount;
  int? propertyWhatsAppCount;
  int? propertyTextMessageCount;
  int? propertyUniqueView;
  String? propertySpentTime;

  OwnerAnalyticsData({
    this.propertyCount,
    this.propertyFinCount,
    this.propertyShareCount,
    this.propertyDirectCallCount,
    this.propertyVendorFinCount,
    this.propertyVirtualTourCount,
    this.propertyMapCount,
    this.propertyVideoCount,
    this.propertyWhatsAppCount,
    this.propertyTextMessageCount,
    this.propertyUniqueView,
    this.propertySpentTime,
  });

  OwnerAnalyticsData.fromJson(Map<String, dynamic> json) {
    propertyCount = json['propertyCount'] as int?;
    propertyFinCount = json['propertyFinCount'] as int?;
    propertyShareCount = json['propertyShareCount'] as int?;
    propertyDirectCallCount = json['propertyDirectCallCount'] as int?;
    propertyVendorFinCount = json['propertyVendorFinCount'] as int?;
    propertyVirtualTourCount = json['propertyVirtualTourCount'] as int?;
    propertyMapCount = json['propertyMapCount'] as int?;
    propertyVideoCount = json['propertyVideoCount'] as int?;
    propertyWhatsAppCount = json['propertyWhatsAppCount'] as int?;
    propertyTextMessageCount = json['propertyTextMessageCount'] as int?;
    propertyUniqueView = json['propertyUniqueView'] as int?;
    propertySpentTime = json['propertySpentTime'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyCount'] = propertyCount;
    data['propertyFinCount'] = propertyFinCount;
    data['propertyShareCount'] = propertyShareCount;
    data['propertyDirectCallCount'] = propertyDirectCallCount;
    data['propertyVendorFinCount'] = propertyVendorFinCount;
    data['propertyVirtualTourCount'] = propertyVirtualTourCount;
    data['propertyMapCount'] = propertyMapCount;
    data['propertyVideoCount'] = propertyVideoCount;
    data['propertyWhatsAppCount'] = propertyWhatsAppCount;
    data['propertyTextMessageCount'] = propertyTextMessageCount;
    data['propertyUniqueView'] = propertyUniqueView;
    data['propertySpentTime'] = propertySpentTime;
    return data;
  }
}


