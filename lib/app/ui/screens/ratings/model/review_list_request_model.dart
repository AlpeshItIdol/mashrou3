class ReviewListRequestModel {
  String? id;
  int? page;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;

  ReviewListRequestModel(
      {this.id, this.page, this.itemsPerPage, this.sortField, this.sortOrder});

  ReviewListRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    page = json['page'];
    itemsPerPage = json['itemsPerPage'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['page'] = page;
    data['itemsPerPage'] = itemsPerPage;
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    return data;
  }
}
