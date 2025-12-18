class AddVendorOfferRequestModel {
  String? title;
  String? price;
  String? description;

  AddVendorOfferRequestModel({this.title, this.price, this.description});

  AddVendorOfferRequestModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    return data;
  }


}