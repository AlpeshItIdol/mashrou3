class FilterStatusListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<FilterStatusData>? data;

  FilterStatusListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  FilterStatusListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FilterStatusData>[];
      json['data'].forEach((v) {
        data!.add(FilterStatusData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterStatusData {
  String? title;
  String? filterType;
  String? key;
  bool? isActive;

  FilterStatusData({this.title, this.filterType, this.key, this.isActive});

  FilterStatusData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    filterType = json['filterType'];
    key = json['key'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['filterType'] = filterType;
    data['key'] = key;
    data['isActive'] = isActive;
    return data;
  }
}
