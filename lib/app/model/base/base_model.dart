class ResponseBaseModel {
  dynamic response;

  ResponseBaseModel(this.response);

  ResponseBaseModel.setResponse({required this.response});
}

class SuccessResponse<T> extends  ResponseBaseModel{
  T data;

  SuccessResponse({required this.data}) : super(data);
}

class FailedResponse extends ResponseBaseModel{
  String errorMessage;

  FailedResponse({required this.errorMessage}) : super(errorMessage);
}
