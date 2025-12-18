class CountryListRequestModel {
  String? searchQuery;

  CountryListRequestModel({this.searchQuery = ""});

  CountryListRequestModel.fromJson(Map<String, dynamic> json) {
    searchQuery = json['searchQuery'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['searchQuery'] = searchQuery;
    return data;
  }
}
