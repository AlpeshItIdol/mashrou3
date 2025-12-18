class BanksListRequestModel {
  String? search;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;
  int? page;

  BanksListRequestModel(
      {this.search,
      this.itemsPerPage,
      this.sortField,
      this.sortOrder,
      this.page});

  BanksListRequestModel.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    itemsPerPage = json['itemsPerPage'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = search;
    data['itemsPerPage'] = itemsPerPage;
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    data['page'] = page;
    return data;
  }
}
