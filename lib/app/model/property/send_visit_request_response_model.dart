class SendVisitRequestResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  SendVisitRequestData? sendVisitRequestData;

  SendVisitRequestResponseModel(
      {this.statusCode, this.success, this.message, this.sendVisitRequestData});

  SendVisitRequestResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    sendVisitRequestData = json['data'] != null ? SendVisitRequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (sendVisitRequestData != null) {
      data['data'] = sendVisitRequestData!.toJson();
    }
    return data;
  }
}

class SendVisitRequestData {
  String? propertyId;
  String? createdBy;
  String? reqModuleType;
  bool? isResponded;
  bool? isDeleted;
  String? reqStatus;
  String? sendTo;
  VisitReqData? visitReqData;
  String? firstName;
  String? lastName;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SendVisitRequestData(
      {this.propertyId,
      this.createdBy,
      this.reqModuleType,
      this.isResponded,
      this.isDeleted,
      this.reqStatus,
      this.sendTo,
      this.visitReqData,
      this.firstName,
      this.lastName,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SendVisitRequestData.fromJson(Map<String, dynamic> json) {
    propertyId = json['propertyId'];
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
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = propertyId;
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
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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
