import '../../../../model/property/property_detail_response_model.dart';

class VisitRequestsListResponseModel {
  dynamic statusCode;
  bool? success;
  VisitRequestsListData? data;

  VisitRequestsListResponseModel({this.statusCode, this.success, this.data});

  VisitRequestsListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null
        ? VisitRequestsListData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VisitRequestsListData {
  List<VisitRequestData>? data;
  dynamic pageCount;
  dynamic documentCount;

  VisitRequestsListData({this.data, this.pageCount, this.documentCount});

  VisitRequestsListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VisitRequestData>[];
      json['data'].forEach((v) {
        data!.add(VisitRequestData.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    documentCount = json['documentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    data['documentCount'] = documentCount;
    return data;
  }
}

class VisitRequestData {
  String? sId;
  PropertyDetailData? property;
  String? createdBy;
  String? reqModuleType;
  bool? isResponded;
  bool? isDeleted;
  String? reqStatus;
  String? sendTo;
  VisitReqData? visitReqData;
  String? firstName;
  String? lastName;
  String? createdAt;
  String? updatedAt;
  dynamic iV;
  String? respondedAt;
  String? reqDenyReasons;

  VisitRequestData(
      {this.sId,
      this.property,
      this.createdBy,
      this.reqModuleType,
      this.isResponded,
      this.isDeleted,
      this.reqStatus,
      this.sendTo,
      this.visitReqData,
      this.firstName,
      this.lastName,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.reqDenyReasons,
      this.respondedAt});

  VisitRequestData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    property = json['propertyId'] != null
        ? PropertyDetailData.fromJson(json['propertyId'])
        : null;
    createdBy = json['createdBy'];
    reqModuleType = json['reqModuleType'];
    isResponded = json['isResponded'];
    isDeleted = json['isDeleted'];
    reqStatus = json['reqStatus'];
    sendTo = json['sendTo'];
    visitReqData = json['visitReqData'] != null
        ? VisitReqData.fromJson(json['visitReqData'])
        : null;
    firstName = json['firstName'];
    lastName = json['lastName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    respondedAt = json['respondedAt'];
    reqDenyReasons = json['reqDenyReasons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (property != null) {
      data['propertyId'] = property!.toJson();
    }
    data['createdBy'] = createdBy;
    data['reqModuleType'] = reqModuleType;
    data['isResponded'] = isResponded;
    data['isDeleted'] = isDeleted;
    data['reqStatus'] = reqStatus;
    data['sendTo'] = sendTo;
    if (visitReqData != null) {
      data['visitReqData'] = visitReqData!.toJson();
    }
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['reqDenyReasons'] = reqDenyReasons;
    data['respondedAt'] = respondedAt;
    return data;
  }
}

class VisitReqData {
  String? visitNote;
  String? visitDateTime;
  String? visitTime;

  VisitReqData({this.visitNote, this.visitDateTime, this.visitTime});

  VisitReqData.fromJson(Map<String, dynamic> json) {
    visitNote = json['visitNote'];
    visitDateTime = json['visitDateTime'];
    visitTime = json['visitTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitNote'] = visitNote;
    data['visitDateTime'] = visitDateTime;
    data['visitTime'] = visitTime;
    return data;
  }
}


