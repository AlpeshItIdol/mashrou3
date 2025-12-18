import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/bank_details/model/bank_details_response_model.dart';
import 'package:mashrou3/config/network/dio_config.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/utils.dart';

import '../model/base/base_model.dart';
import '../model/property/add_finance_request_request_model.dart';
import '../model/property/add_finance_request_response_model.dart';
import '../model/property/bank_view_count_request_model.dart';
import '../model/property/bank_view_count_response_model.dart';
import '../ui/screens/property_details/sub_screens/bank_details/model/bank_property_offers_response_model.dart';
import '../ui/screens/property_details/sub_screens/banks_list/model/banks_list_response_model.dart';

abstract class BankManagementRepository {
  Future<ResponseBaseModel> getBanksList({
    required Map<String, dynamic>? queryParameters,
    required String searchText,
  });

  Future<ResponseBaseModel> getMenuBankList({
    required Map<String, dynamic>? queryParameters,
    required String searchText,
  });

  Future<ResponseBaseModel> getBankDetails({required String bankId});

  Future<ResponseBaseModel> addFinanceRequest({
    required AddFinanceRequestRequestModel requestModel,
  });

  Future<ResponseBaseModel> bankPropertyOffers({
    required AddFinanceRequestRequestModel requestModel,
  });

  Future<ResponseBaseModel> vendorBankPropertyOffers({
    required AddFinanceRequestRequestModel requestModel,
  });

  Future<ResponseBaseModel> getBankViewCount({
    required BankViewCountRequestModel requestModel,
  });
}

class BankManagementRepositoryImpl extends BankManagementRepository {
  @override
  Future<ResponseBaseModel> getBanksList({
    required Map<String, dynamic>? queryParameters,
    required String searchText,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .getBaseAPIWithTokenAndRequestParam(
              url: NetworkAPIs.kBanksList,
              queryParameters: queryParameters,
              search: searchText);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          BanksListResponseModel banksListResponseModel =
              BanksListResponseModel.fromJson(response.data);
          return SuccessResponse(data: banksListResponseModel);
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
  Future<ResponseBaseModel> getMenuBankList({
    required Map<String, dynamic>? queryParameters,
    required String searchText,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .getBaseAPIWithTokenAndRequestParam(
          url: NetworkAPIs.kBanksMenuList,
          queryParameters: queryParameters,
          search: searchText);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          BanksListResponseModel banksListResponseModel =
              BanksListResponseModel.fromJson(response.data);
          return SuccessResponse(data: banksListResponseModel);
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
          BankDetailsResponseModel responseModel =
              BankDetailsResponseModel.fromJson(response.data);
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
  Future<ResponseBaseModel> addFinanceRequest({
    required AddFinanceRequestRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kAddFinanceRequest,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AddFinanceRequestResponseModel responseModel =
              AddFinanceRequestResponseModel.fromJson(response.data);
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
  Future<ResponseBaseModel> bankPropertyOffers({
    required AddFinanceRequestRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kBankPropertyOffer,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          BankPropertyOffersResponseModel responseModel =
              BankPropertyOffersResponseModel.fromJson(response.data);
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
  Future<ResponseBaseModel> vendorBankPropertyOffers({
    required AddFinanceRequestRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kVendorBankPropertyOffer,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          BankPropertyOffersResponseModel responseModel =
          BankPropertyOffersResponseModel.fromJson(response.data);
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
  Future<ResponseBaseModel> getBankViewCount({
    required BankViewCountRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kBankViewCount,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          BankViewCountResponseModel responseModel =
          BankViewCountResponseModel.fromJson(response.data);
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
