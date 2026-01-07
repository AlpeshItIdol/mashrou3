class VendorOfferAnalyticsRequestModel {
  int? page;
  String? search;
  bool? excel;
  String? tableType;
  AnalyticsFilter? filter;
  String? sortField;
  String? sortOrder;
  int? itemsPerPage;
  bool? pagination;
  String? vendorId;

  VendorOfferAnalyticsRequestModel({
    this.page = 1,
    this.search = "",
    this.excel = false,
    this.tableType = "super_admin_vendor_offer",
    this.filter,
    this.sortField = "createdAt",
    this.sortOrder = "desc",
    this.itemsPerPage = 10,
    this.pagination = true,
    this.vendorId,
  });

  VendorOfferAnalyticsRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    search = json['search'];
    excel = json['excel'];
    tableType = json['tableType'];
    filter = json['filter'] != null
        ? AnalyticsFilter.fromJson(json['filter'])
        : null;
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
    itemsPerPage = json['itemsPerPage'];
    pagination = json['pagination'];
    vendorId = json['vendorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['search'] = search;
    data['excel'] = excel;
    data['tableType'] = tableType;
    if (filter != null) {
      data['filter'] = filter!.toJson();
    }
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    data['itemsPerPage'] = itemsPerPage;
    data['pagination'] = pagination;
    if (vendorId != null) data['vendorId'] = vendorId;
    return data;
  }
}

class AnalyticsFilter {
  String? userType;

  AnalyticsFilter({this.userType});

  AnalyticsFilter.fromJson(Map<String, dynamic> json) {
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userType'] = userType;
    return data;
  }
}

