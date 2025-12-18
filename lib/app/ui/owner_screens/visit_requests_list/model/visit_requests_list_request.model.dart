import '../../../screens/filter/model/filter_request_model.dart';

class VisitRequestsListRequestModel {
  String? search;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;
  int? page;
  FilterRequestModel? filter;

  VisitRequestsListRequestModel(
      {this.search,
      this.itemsPerPage,
      this.sortField,
      this.sortOrder,
      this.filter,
      this.page});

  VisitRequestsListRequestModel.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    itemsPerPage = json['itemsPerPage'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
    page = json['page'];
    filter = json['filter'] != null
        ? FilterRequestModel.fromJson(json['filter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = search;
    data['itemsPerPage'] = itemsPerPage;
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    data['page'] = page;
    if (filter != null) {
      data['filter'] = filter!.toJson();
    }
    return data;
  }
}
