class SendVisitRequestRequestModel {
  String? propertyId;
  String? note;
  String? visitDate;
  String? visitTime;

  SendVisitRequestRequestModel(
      {this.propertyId, this.note, this.visitDate, this.visitTime});

  SendVisitRequestRequestModel.fromJson(Map<String, dynamic> json) {
    propertyId = json['propertyId'];
    note = json['note'];
    visitDate = json['visitDate'];
    visitTime = json['visitTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = propertyId;
    data['note'] = note;
    data['visitDate'] = visitDate;
    data['visitTime'] = visitTime;
    return data;
  }
}
