class VendorCategoryListResponse {
  int? statusCode;
  bool? success;
  String? message;
  VendorCategoryPaginationData? data;
  List<VendorCategoryData>? dataList; // For backward compatibility (non-paginated response)

  VendorCategoryListResponse(
      {this.statusCode, this.success, this.message, this.data, this.dataList});

  VendorCategoryListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    
    // Handle both paginated and non-paginated responses
    if (json['data'] != null) {
      if (json['data'] is List) {
        // Non-paginated response (old API)
        dataList = <VendorCategoryData>[];
        json['data'].forEach((v) {
          dataList!.add(VendorCategoryData.fromJson(v));
        });
      } else if (json['data'] is Map) {
        // Paginated response (new API)
        data = VendorCategoryPaginationData.fromJson(json['data']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    } else if (dataList != null) {
      data['data'] = dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorCategoryPaginationData {
  List<VendorCategoryData>? vendorData;
  int? page;
  int? documentCount;
  int? pageCount;

  VendorCategoryPaginationData(
      {this.vendorData, this.page, this.documentCount, this.pageCount});

  VendorCategoryPaginationData.fromJson(Map<String, dynamic> json) {
    if (json['vendorData'] != null) {
      vendorData = <VendorCategoryData>[];
      json['vendorData'].forEach((v) {
        vendorData!.add(VendorCategoryData.fromJson(v));
      });
    }
    page = json['page'];
    documentCount = json['documentCount'];
    pageCount = json['pageCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vendorData != null) {
      data['vendorData'] = vendorData!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['documentCount'] = documentCount;
    data['pageCount'] = pageCount;
    return data;
  }
}

class VendorCategoryData {
  String? sId;
  bool? isActive;
  bool? isVendorCreated;
  dynamic title; // Can be String or Map<String, dynamic>
  String? description;
  String? vendorLogo;

  VendorCategoryData(
      {this.sId,
      this.isActive,
      this.isVendorCreated,
      this.title,
      this.description,
      this.vendorLogo});

  VendorCategoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isVendorCreated = json['isVendorCreated'];
    title = json['title'];
    description = json['description'];
    vendorLogo = json['VendorLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['isActive'] = isActive;
    data['isVendorCreated'] = isVendorCreated;
    data['title'] = title;
    data['description'] = description;
    data['VendorLogo'] = vendorLogo;
    return data;
  }

  // Helper method to get localized title
  String getTitleString({String locale = 'en'}) {
    if (title is String) {
      return title as String;
    } else if (title is Map) {
      final titleMap = title as Map;
      return (titleMap[locale] ?? titleMap['en'] ?? titleMap.values.first ?? '') as String;
    }
    return '';
  }
}
