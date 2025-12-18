class NotificationRequestModel {
  int? page;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;

  NotificationRequestModel(
      {this.page,
        this.itemsPerPage,
        this.sortField,
        this.sortOrder,
        });

  NotificationRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    itemsPerPage = json['itemsPerPage'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['itemsPerPage'] = itemsPerPage;
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    return data;
  }
}