class SubCategoryRequestModel {
  String? key;
  dynamic id;

  SubCategoryRequestModel({
    this.key,
    this.id,
  });
}

class SubCategoryMultiRequestModel {
  String? key;
  List<String>? id;

  SubCategoryMultiRequestModel({
    this.key,
    this.id,
  });
}
