import 'package:get_it/get_it.dart';
import 'package:mashrou3/config/network/dio_config.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/utils.dart';

import '../model/base/base_model.dart';
import '../ui/screens/banks_offer/models/banks_offer_list_model.dart';

abstract class BankOfferListRepository {
  Future<ResponseBaseModel> getBanksOfferList({
    required Map<String, dynamic>? queryParameters,
    required String searchText,
  });
}

class BankOfferListRepositoryImpl extends BankOfferListRepository {
  @override
  Future<ResponseBaseModel> getBanksOfferList({
    required Map<String, dynamic>? queryParameters,
    required String searchText,
  }) async {
    if (await Utils.isConnected()) {
      final url = NetworkAPIs.kVBankOfferList;

      final response = await GetIt.I<DioProvider>().getBaseAPIWithTokenAndRequestParam(
        url: url,
        // Convert all values to string for Dio compatibility
        queryParameters: queryParameters?.map(
              (key, value) => MapEntry(key, value is Iterable ? value : value.toString()),
        ),
        search: searchText,
      );

      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          BankOffersListResponse bankOffersListResponse =
          BankOffersListResponse.fromJson(response.data);
          return SuccessResponse(data: bankOffersListResponse);
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
