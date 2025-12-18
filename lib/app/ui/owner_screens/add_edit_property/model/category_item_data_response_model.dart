class CategoryItemDataResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  CategoryItem? data;

  CategoryItemDataResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  CategoryItemDataResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? CategoryItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CategoryItem {
  CategoryItemOptions? floors;
  CategoryItemOptions? bedrooms;
  CategoryItemOptions? bathrooms;
  CategoryItemOptions? amenities;
  CategoryItemOptions? facades;
  CategoryItemOptions? furnishedTypes;
  CategoryItemOptions? buildingAge;
  CategoryItemOptions? mortgaged;

  CategoryItem(
      {this.floors,
      this.bedrooms,
      this.bathrooms,
      this.amenities,
      this.facades,
      this.furnishedTypes,
      this.buildingAge,
      this.mortgaged});

  CategoryItem.fromJson(Map<String, dynamic> json) {
    floors = json['floors'] != null
        ? CategoryItemOptions.fromJson(json['floors'])
        : null;
    bedrooms = json['bedrooms'] != null
        ? CategoryItemOptions.fromJson(json['bedrooms'])
        : null;
    bathrooms = json['bathrooms'] != null
        ? CategoryItemOptions.fromJson(json['bathrooms'])
        : null;
    amenities = json['amenities'] != null
        ? CategoryItemOptions.fromJson(json['amenities'])
        : null;
    facades = json['facade'] != null
        ? CategoryItemOptions.fromJson(json['facade'])
        : null;
    furnishedTypes = json['furnishedType'] != null
        ? CategoryItemOptions.fromJson(json['furnishedType'])
        : null;
    buildingAge = json['buildingAge'] != null
        ? CategoryItemOptions.fromJson(json['buildingAge'])
        : null;
    mortgaged = json['mortgaged'] != null
        ? CategoryItemOptions.fromJson(json['mortgaged'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (floors != null) {
      data['floors'] = floors!.toJson();
    }
    if (bedrooms != null) {
      data['bedrooms'] = bedrooms!.toJson();
    }
    if (bathrooms != null) {
      data['bathrooms'] = bathrooms!.toJson();
    }
    if (amenities != null) {
      data['amenities'] = amenities!.toJson();
    }
    if (facades != null) {
      data['facade'] = facades!.toJson();
    }
    if (furnishedTypes != null) {
      data['furnishedType'] = furnishedTypes!.toJson();
    }
    if (buildingAge != null) {
      data['buildingAge'] = buildingAge!.toJson();
    }
    if (mortgaged != null) {
      data['mortgaged'] = mortgaged!.toJson();
    }
    return data;
  }
}

class CategoryItemOptions {
  List<CategoryItemData>? data;
  bool? required;
  String? label;
  bool? isMultiple;
  String? key;

  CategoryItemOptions(
      {this.data, this.required, this.label, this.isMultiple, this.key});

  CategoryItemOptions.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryItemData>[];
      json['data'].forEach((v) {
        data!.add(CategoryItemData.fromJson(v));
      });
    }
    required = json['required'];
    label = json['label'];
    isMultiple = json['isMultiple'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['required'] = required;
    data['label'] = label;
    data['isMultiple'] = isMultiple;
    data['key'] = key;
    return data;
  }
}

class CategoryItemData {
  String? name;
  String? sId;

  CategoryItemData({this.name, this.sId});

  CategoryItemData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['_id'] = sId;
    return data;
  }
}
