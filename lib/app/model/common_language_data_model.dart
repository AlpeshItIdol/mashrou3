class CommonLanguageDataModel {
  String? en;
  String? ar;

  CommonLanguageDataModel({this.en, this.ar});

  CommonLanguageDataModel.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['ar'] = ar;
    return data;
  }
}
