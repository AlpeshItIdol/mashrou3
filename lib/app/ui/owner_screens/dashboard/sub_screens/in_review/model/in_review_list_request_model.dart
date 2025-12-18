import '../../../../../screens/filter/model/filter_request_model.dart';

class InReviewListDataRequestModel {
  String? reqModuleType;
  int? page;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;
  String? search;
  FilterRequestModel? filter;

  InReviewListDataRequestModel(
      {this.reqModuleType,
        this.page,
        this.itemsPerPage,
        this.sortField,
        this.sortOrder,
        this.search,
        this.filter});

  InReviewListDataRequestModel.fromJson(Map<String, dynamic> json) {
    reqModuleType = json['reqModuleType'];
    page = json['page'];
    itemsPerPage = json['itemsPerPage'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
    search = json['search'];
    filter =
    json['filter'] != null ? new FilterRequestModel.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reqModuleType'] = this.reqModuleType;
    data['page'] = this.page;
    data['itemsPerPage'] = this.itemsPerPage;
    data['sortField'] = this.sortField;
    data['sortOrder'] = this.sortOrder;
    data['search'] = this.search;
    if (this.filter != null) {
      data['filter'] = this.filter!.toJson();
    }
    return data;
  }
}

class Filter {
  String? category;

  Filter({this.category});

  Filter.fromJson(Map<String, dynamic> json) {
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    return data;
  }
}
