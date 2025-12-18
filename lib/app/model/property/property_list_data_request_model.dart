import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/utils.dart';

class PropertyListDataRequestModel {
  int? page;
  int? itemsPerPage;
  String? sortField;
  String? sortOrder;
  String? search;
  FilterRequestModel? filter;
  bool? myFavorite;
  bool? skipLogin;
  bool? withOffers;
  String? userId;

  PropertyListDataRequestModel(
      {this.page,
      this.itemsPerPage,
      this.sortField,
      this.sortOrder,
      this.search,
      this.filter,
      this.myFavorite,
      this.withOffers,
      this.skipLogin,
      this.userId});

  PropertyListDataRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    itemsPerPage = json['itemsPerPage'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
    search = json['search'];
    filter = json['filter'] != null
        ? FilterRequestModel.fromJson(json['filter'])
        : null;
    myFavorite = json['myFavorite'];
    skipLogin = json['skipLogin'];
    withOffers = json['withOffers'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['itemsPerPage'] = itemsPerPage;
    if (sortField != null) data['sortField'] = sortField;
    if (sortOrder != null) data['sortOrder'] = sortOrder;
    if (search != null) data['search'] = search;
    if (filter != null) {
      final filterJson = filter!.toJson();
      printf("PropertyListDataRequestModel.toJson: filter.toJson() = $filterJson");
      printf("PropertyListDataRequestModel.toJson: filter.category = ${filter!.category}");
      data['filter'] = filterJson;
    }
    data['myFavorite'] = myFavorite;
    data['skipLogin'] = skipLogin;
    data['withOffers'] = withOffers;
    if (userId != null) data['userId'] = userId;
    return data;
  }
}
