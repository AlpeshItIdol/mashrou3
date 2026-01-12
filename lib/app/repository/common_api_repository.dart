import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/city_list_response_model.dart';
import 'package:mashrou3/app/model/property/address_location_response_model.dart';
import 'package:mashrou3/app/model/property/currency_list_response_model.dart';
import 'package:mashrou3/app/model/vendor_list_response.model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_detail_response_model.dart';

import '../../config/network/dio_config.dart';
import '../../config/network/network_constants.dart';
import '../../config/utils.dart';
import '../model/base/base_model.dart';
import '../model/city_list_request.model.dart';
import '../model/common_only_message_response_model.dart';
import '../model/country_list_model.dart';
import '../model/country_request_mode.dart';
import '../model/language_list_response_model.dart';
import '../model/property/add_to_fav_request_model.dart';
import '../model/property/property_category_response_model.dart';
import '../model/user_details_request.model.dart';
import '../model/user_details_response.model.dart';
import '../model/vendor_offer_analytics/vendor_offer_analytics_request_model.dart';
import '../model/vendor_offer_analytics/vendor_offer_analytics_response_model.dart';

abstract class CommonApiRepository {
  Future<ResponseBaseModel> countryList({
    required CountryListRequestModel requestModel,
  });

  Future<ResponseBaseModel> cityList({
    required CityListRequestModel requestModel,
  });

  Future<ResponseBaseModel> userFlagDetails({
    required UserDetailsRequestModel requestModel,
  });

  Future<ResponseBaseModel> vendorList();

  Future<ResponseBaseModel> languageList();

  Future<ResponseBaseModel> propertyCategoryList();

  Future<ResponseBaseModel> addRemoveFavorite({
    required AddRemoveFavRequestModel requestModel,
  });

  Future<ResponseBaseModel> updateLanguage();

  Future<ResponseBaseModel> userDetails({
    required String userId,
  });

  Future<ResponseBaseModel> getCurrencyList();

  Future<ResponseBaseModel> getVendorOfferAnalytics({
    required VendorOfferAnalyticsRequestModel requestModel,
  });

  Future<ResponseBaseModel> getAddressLocationList();
}

class CommonApiRepositoryImpl extends CommonApiRepository {
  /// Country List API
  ///
  @override
  Future<ResponseBaseModel> countryList({
    required CountryListRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
        url: NetworkAPIs.kCountryList,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CountryListResponseModel countryListResponseModel =
              CountryListResponseModel.fromJson(response.data);
          debugPrint("Response-----------${response.data.toString()}");
          return SuccessResponse(data: countryListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  /// Language List API
  ///
  @override
  Future<ResponseBaseModel> languageList() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
        url: NetworkAPIs.kLanguageList,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          LanguageListResponseModel listResponseModel =
              LanguageListResponseModel.fromJson(response.data);
          debugPrint("Response-----------${response.data.toString()}");
          return SuccessResponse(data: listResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  /// City List API
  ///
  @override
  Future<ResponseBaseModel> cityList({
    required CityListRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .postBaseAPI(url: NetworkAPIs.kCityList, data: requestModel.toJson());
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CityListResponseModel cityListResponseModel =
              CityListResponseModel.fromJson(response.data);
          debugPrint("Response-----------${response.data.toString()}");
          return SuccessResponse(data: cityListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  /// User Flag Details API
  ///
  @override
  Future<ResponseBaseModel> userFlagDetails({
    required UserDetailsRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .getBaseAPI(url: NetworkAPIs.kUserFlagDetails + requestModel.id!);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          UserDetailsResponseModel userDetailsResponseModel =
              UserDetailsResponseModel.fromJson(response.data);
          debugPrint("Response-----------${response.data.toString()}");
          return SuccessResponse(data: userDetailsResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  /// Vendor List API
  ///
  @override
  Future<ResponseBaseModel> vendorList() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
        url: NetworkAPIs.kVendorCategoryList,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VendorListResponseModel vendorListResponseModel =
              VendorListResponseModel.fromJson(response.data);
          debugPrint("Response-----------${response.data.toString()}");
          return SuccessResponse(data: vendorListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  /// Language List API
  ///
  @override
  Future<ResponseBaseModel> propertyCategoryList() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
            url: NetworkAPIs.kPropertyCategories, data: {"pagination": false});
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyCategoryResponseModel propertyCategoryResponseModel =
              PropertyCategoryResponseModel.fromJson(response.data);
          return SuccessResponse(data: propertyCategoryResponseModel);
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
  Future<ResponseBaseModel> addRemoveFavorite({
    required AddRemoveFavRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kAddRemoveFav,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CommonOnlyMessageResponseModel responseModel =
              CommonOnlyMessageResponseModel.fromJson(response.data);
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

  Future<String> getLangCode() async {
    AppPreferences appPreferences = AppPreferences();
    String? selectedLanguage = await appPreferences.getLanguageCode();
    return selectedLanguage ?? 'en';
  }

  @override
  Future<ResponseBaseModel> updateLanguage() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .putBaseAPIWithToken(url: NetworkAPIs.kUpdateLang, data: {
        NetworkParams.kLanguage: await getLangCode(),
      });
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CommonOnlyMessageResponseModel responseModel =
              CommonOnlyMessageResponseModel.fromJson(response.data);
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

  /// User Details API
  ///
  @override
  Future<ResponseBaseModel> userDetails({
    required String userId,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .getBaseAPIWithToken(url: NetworkAPIs.kUserDetails + userId);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VendorDetailResponseModel userDetailsResponseModel =
          VendorDetailResponseModel.fromJson(response.data);
          printf("Response-----------${response.data.toString()}");
          return SuccessResponse(data: userDetailsResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> getCurrencyList() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .getBaseAPIWithToken(url: NetworkAPIs.kCurrencyList);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CurrencyListResponseModel responseModel =
          CurrencyListResponseModel.fromJson(response.data);
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

  /// Vendor Offer Analytics API
  ///
  @override
  Future<ResponseBaseModel> getVendorOfferAnalytics({
    required VendorOfferAnalyticsRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kVendorOfferAnalytics,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VendorOfferAnalyticsResponseModel responseModel =
              VendorOfferAnalyticsResponseModel.fromJson(response.data);
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

  /// Address Location List API
  ///
  @override
  Future<ResponseBaseModel> getAddressLocationList() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kAddressLocation,
        data: {
          "pagination": false,
          "isSuperAdmin": true,
          "limit": 10000,
        },
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AddressLocationResponseModel responseModel =
              AddressLocationResponseModel.fromJson(response.data);
          debugPrint("AddressLocationResponse-----------${response.data.toString()}");
          return SuccessResponse(data: responseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }
}
