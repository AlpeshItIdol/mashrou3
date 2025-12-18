class VisitRequestRejectRequestModel {
  String? requestId;
  String? message;
  String? action;

  VisitRequestRejectRequestModel(
      {this.requestId, this.message, this.action});

  VisitRequestRejectRequestModel.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    message = json['message'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['message'] = message;
    data['action'] = action;
    return data;
  }
}
