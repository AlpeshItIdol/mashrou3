class MyOffersListRequestModel {
  int? page;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;
  String? search;

  MyOffersListRequestModel(
      {this.page, this.itemsPerPage, this.sortField, this.sortOrder,this.search});

  MyOffersListRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    itemsPerPage = json['itemsPerPage'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['itemsPerPage'] = itemsPerPage;
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    data['search'] = search;
    return data;
  }
}
