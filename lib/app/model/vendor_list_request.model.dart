class VendorListRequestModel {
  String? countryId;
  int? page;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;

  VendorListRequestModel({
    this.countryId,
    this.page = 1,
    this.itemsPerPage = 100,
    this.sortField = "createdAt",
    this.sortOrder = "asc",
  });

  VendorListRequestModel.fromJson(Map<String, dynamic> json) {
    countryId = json['id'];
    page = json['page'] ?? 1;
    itemsPerPage = json['itemsPerPage'] ?? 10;
    sortField = json['sortField'] ?? "createdAt";
    sortOrder = json['sortOrder'] ?? "asc";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = countryId;
    data['page'] = page;
    data['itemsPerPage'] = itemsPerPage;
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    return data;
  }
}
