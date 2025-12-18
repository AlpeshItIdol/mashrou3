class VisitRequestApproveRequestModel {
  String? requestId;
  String? action;

  VisitRequestApproveRequestModel({this.requestId, this.action});

  VisitRequestApproveRequestModel.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['action'] = action;
    return data;
  }
}
