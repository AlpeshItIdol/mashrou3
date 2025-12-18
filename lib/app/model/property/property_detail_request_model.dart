class PropertyDetailsRequestModel {
  bool? withOffers;

  PropertyDetailsRequestModel({
    this.withOffers,
  });

  PropertyDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    withOffers = json['withOffers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['withOffers'] = withOffers;

    return data;
  }
}
