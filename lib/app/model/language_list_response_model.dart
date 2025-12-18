class LanguageListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<LanguageListData>? data;

  LanguageListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  LanguageListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LanguageListData>[];
      json['data'].forEach((v) {
        data!.add(new LanguageListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LanguageListData {
  String? sId;
  String? langLongName;
  String? langShortName;
  String? slug;
  String? createdAt;
  String? updatedAt;
  int? iV;

  LanguageListData(
      {this.sId,
        this.langLongName,
        this.langShortName,
        this.slug,
        this.createdAt,
        this.updatedAt,
        this.iV});

  LanguageListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    langLongName = json['langLongName'];
    langShortName = json['langShortName'];
    slug = json['slug'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['langLongName'] = this.langLongName;
    data['langShortName'] = this.langShortName;
    data['slug'] = this.slug;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
