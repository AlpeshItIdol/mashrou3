class CityListRequestModel {
  bool? pagination;
  int? page;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;
  String? search;
  String? countryId;

  CityListRequestModel({
    this.pagination,
    this.page,
    this.itemsPerPage,
    this.sortField,
    this.sortOrder,
    this.search,
    this.countryId,
  });

  CityListRequestModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'];
    page = json['page'];
    itemsPerPage = json['itemsPerPage'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
    search = json['search'];
    countryId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pagination'] = pagination;
    data['page'] = page;
    data['itemsPerPage'] = itemsPerPage;
    if (sortField != null) data['sortField'] = sortField;
    if (sortOrder != null) data['sortOrder'] = sortOrder;
    data['search'] = search;
    data['id'] = countryId;
    return data;
  }
}
