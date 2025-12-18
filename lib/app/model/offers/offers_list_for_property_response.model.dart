// import 'my_offers_list_response_model.dart';

import '../../ui/screens/dashboard/sub_screens/add_offer/model/add_vendor_response_model.dart';

class OffersListForPropertyResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  List<OfferData>? offersListData;

  OffersListForPropertyResponseModel(
      {this.statusCode, this.success, this.message, this.offersListData});

  OffersListForPropertyResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      offersListData = <OfferData>[];
      json['data'].forEach((v) {
        offersListData!.add(new OfferData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (offersListData != null) {
      data['data'] = offersListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
