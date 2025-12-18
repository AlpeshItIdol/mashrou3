class BaseRequestModel {
  bool? pagination;
  String? sortField;
  String? sortOrder;

  BaseRequestModel({this.pagination, this.sortField, this.sortOrder});

  BaseRequestModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pagination'] = pagination;
    data['sortField'] = sortField;
    data['sortOrder'] = sortOrder;
    return data;
  }
}
