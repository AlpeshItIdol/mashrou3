class OwnerOfferAnalyticsRequestModel {
  int? page;
  String? search;
  bool? excel;
  String? tableType;
  Map<String, dynamic>? filter;
  String? sortField;
  String? sortOrder;
  int? itemsPerPage;
  bool? pagination;
  String? ownerId;

  OwnerOfferAnalyticsRequestModel({
    this.page = 1,
    this.search = "",
    this.excel = false,
    this.tableType = "super_admin_property",
    this.filter,
    this.sortField = "createdAt",
    this.sortOrder = "desc",
    this.itemsPerPage = 10,
    this.pagination = true,
    this.ownerId,
  });

  OwnerOfferAnalyticsRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'] as int?;
    search = json['search'] as String?;
    excel = json['excel'] as bool?;
    tableType = json['tableType'] as String?;
    filter = json['filter'] != null ? Map<String, dynamic>.from(json['filter'] as Map) : null;
    sortField = json['sortField'] as String?;
    sortOrder = json['sortOrder'] as String?;
    itemsPerPage = json['itemsPerPage'] as int?;
    pagination = json['pagination'] as bool?;
    ownerId = json['ownerId'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['search'] = search;
    data['excel'] = excel;
    data['tableType'] = tableType;
    if (filter != null) {
      data['filter'] = filter;
    }
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    data['itemsPerPage'] = itemsPerPage;
    data['pagination'] = pagination;
    if (ownerId != null) {
      data['ownerId'] = ownerId;
    }
    return data;
  }
}


