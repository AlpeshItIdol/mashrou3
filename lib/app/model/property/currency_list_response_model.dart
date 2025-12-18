class CurrencyListResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<CurrencyListData>? data;

  CurrencyListResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  CurrencyListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CurrencyListData>[];
      json['data'].forEach((v) {
        data!.add(new CurrencyListData.fromJson(v));
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

class CurrencyListData {
  String? sId;
  String? currencySymbol;
  String? currencyName;
  String? currencyCode;
  int? iV;
  String? createdAt;
  String? updatedAt;

  CurrencyListData(
      {this.sId,
        this.currencySymbol,
        this.currencyName,
        this.currencyCode,
        this.iV,
        this.createdAt,
        this.updatedAt});

  CurrencyListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    currencySymbol = json['currencySymbol'];
    currencyName = json['currencyName'];
    currencyCode = json['currencyCode'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['currencySymbol'] = this.currencySymbol;
    data['currencyName'] = this.currencyName;
    data['currencyCode'] = this.currencyCode;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
