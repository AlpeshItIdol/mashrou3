import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/common_only_message_response_model.dart';
import 'package:mashrou3/app/model/offers/my_offers_list_request.model.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/add_offer/model/vendor_add_offer_response_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/bank_details/model/bank_details_response_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/property_vendor_offer_response_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_list_response_model.dart';
import 'package:mashrou3/config/network/dio_config.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/utils.dart';

import '../model/base/base_model.dart';
import '../model/offers/my_offers_list_response_model.dart';
import '../model/offers/offers_list_for_property_request.model.dart';
import '../model/offers/offers_list_for_property_response.model.dart';
import '../ui/screens/dashboard/sub_screens/add_offer/model/add_vendor_response_model.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/model/apply_offer_request.model.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/model/apply_offer_response_model.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/model/apply_vendor_offer_request.model.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/model/price_calculations_request.model.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/model/price_calculations_response_model.dart';

abstract class OffersManagementRepository {
  Future<ResponseBaseModel> getMyOffersList({
    required MyOffersListRequestModel requestModel,
  });

  Future<ResponseBaseModel> getDraftOffer({
    required MyOffersListRequestModel requestModel,
  });

  Future<ResponseBaseModel> applyOffer({
    required ApplyOfferRequestModel requestModel,
  });
  Future<ResponseBaseModel> getBankDetails({required String bankId});

  Future<ResponseBaseModel> getOffersListForProperty({
    required OffersListForPropertyRequestModel requestModel,
  });

  Future<ResponseBaseModel> addVendorOffer({
    required FormData requestModel,
  });

  Future<ResponseBaseModel> updateVendorOffer({
    required FormData requestModel,
    required String postId,
    required bool isDraftOffer,
  });

  Future<ResponseBaseModel> getOfferById({
    required String feedId,
    bool isDraftOffer = false,
  });

  Future<ResponseBaseModel> deleteFeedPost({required String postId, required bool isDraftOffer});

  Future<ResponseBaseModel> getVendorCategoryList({required String searchText, required String propertyId});

  Future<ResponseBaseModel> getVendorList({
    required Map<String, dynamic>? queryParameters,
    required String? searchText,
  });

  Future<ResponseBaseModel> getOfferByVendorPropertyId({
    required String vendorId,
    required String propertyId,
  });

  Future<ResponseBaseModel> getPriceCalculations({
    required PriceCalculationsRequestModel requestModel,
  });

  Future<ResponseBaseModel> applyVendorOffer({
    required ApplyVendorOfferRequestModel requestModel,
  });
}

class OffersManagementRepositoryImpl extends OffersManagementRepository {
  @override
  Future<ResponseBaseModel> getMyOffersList({
    required MyOffersListRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kMyOffersList,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          MyOffersListResponseModel myOffersListResponseModel = MyOffersListResponseModel.fromJson(response.data);
          return SuccessResponse(data: myOffersListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getDraftOffer({
    required MyOffersListRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kMyReviewOffers,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          MyOffersListResponseModel myOffersListResponseModel = MyOffersListResponseModel.fromJson(response.data);
          return SuccessResponse(data: myOffersListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> applyOffer({required ApplyOfferRequestModel requestModel}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kApplyMyOffer,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          ApplyOfferResponseModel applyOfferResponseModel = ApplyOfferResponseModel.fromJson(response.data);
          return SuccessResponse(data: applyOfferResponseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getBankDetails({required String bankId}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().getBaseAPIWithToken(
        url: NetworkAPIs.kGetBankDetails + bankId,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          BankDetailsResponseModel responseModel = BankDetailsResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getOffersListForProperty({
    required OffersListForPropertyRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kOffersListForProperty,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          OffersListForPropertyResponseModel responseModel = OffersListForPropertyResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> addVendorOffer({required FormData requestModel}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kAddVendorOffer,
        data: requestModel,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AddVendorOfferResponseModel responseModel = AddVendorOfferResponseModel.fromJson(response.data);

          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> deleteFeedPost({required String postId, required bool isDraftOffer}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().deleteBaseAPIWithToken(
        url: isDraftOffer ? "${NetworkAPIs.kDeleteDraftOffer}/$postId" : "${NetworkAPIs.kDeleteOffer}/$postId",
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CommonOnlyMessageResponseModel responseModel = CommonOnlyMessageResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> updateVendorOffer({
    required FormData requestModel,
    required String postId,
    required bool isDraftOffer,
  }) async {
    if (await Utils.isConnected()) {
      final response = isDraftOffer
          ? await GetIt.I<DioProvider>().putBaseAPIWithToken(
              url: "${NetworkAPIs.kUpdateDraftOffer}/$postId",
              data: requestModel,
            )
          : await GetIt.I<DioProvider>().putBaseAPIWithToken(
              url: "${NetworkAPIs.kUpdateOffer}/$postId",
              data: requestModel,
            );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VendorOfferCreateResponseModel responseModel = VendorOfferCreateResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getOfferById({
    required String feedId,
    bool isDraftOffer = false,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().getBaseAPIWithToken(
        url: isDraftOffer ? "${NetworkAPIs.kPropertyDraftOffer}/$feedId" : "${NetworkAPIs.kPropertyOffer}/$feedId",
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          SingleOfferResponse responseModel = SingleOfferResponse.fromJson(response.data);
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getVendorCategoryList({required String searchText, required String propertyId}) async {
    if (await Utils.isConnected()) {
      Map<String, dynamic> params = {"propertyId": propertyId};
      if (searchText.isNotEmpty) {
        params.addAll({
          "search": searchText,
        });
      }

      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(url: NetworkAPIs.kVendorCategoryListForProperty, data: params);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VendorCategoryListResponse listResponse = VendorCategoryListResponse.fromJson(response.data);
          return SuccessResponse(data: listResponse);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getVendorList({
    required Map<String, dynamic>? queryParameters,
    required String? searchText,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .getBaseAPIWithTokenAndRequestParam(url: NetworkAPIs.kVendorList, queryParameters: queryParameters, search: searchText);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(response.data.toString());
          VendorListResponseModel listResponse = VendorListResponseModel.fromJson(response.data);
          return SuccessResponse(data: listResponse);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getOfferByVendorPropertyId({
    required String vendorId,
    required String propertyId,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(url: NetworkAPIs.kVendorPropertyOfferList, data: {
        NetworkParams.kVendorId: vendorId,
        NetworkParams.kPropertyId: propertyId,
      });
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyVendorOfferResponseModel responseModel = PropertyVendorOfferResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getPriceCalculations({
    required PriceCalculationsRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kPriceCalculations,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PriceCalculationsResponseModel responseModel = PriceCalculationsResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> applyVendorOffer({
    required ApplyVendorOfferRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kApplyVendorOffer,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          ApplyOfferResponseModel responseModel = ApplyOfferResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }
}
