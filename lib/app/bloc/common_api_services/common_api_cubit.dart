import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/model/language_list_response_model.dart';
import 'package:mashrou3/app/model/property/currency_list_response_model.dart';
import 'package:mashrou3/app/model/user_details_response.model.dart';
import 'package:mashrou3/app/model/vendor_list_response.model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_detail_response_model.dart';

import '../../../config/resources/app_constants.dart';
import '../../../config/utils.dart';
import '../../model/city_list_request.model.dart';
import '../../model/city_list_response_model.dart';
import '../../model/common_only_message_response_model.dart';
import '../../model/country_list_model.dart';
import '../../model/country_request_mode.dart';
import '../../model/property/add_to_fav_request_model.dart';
import '../../model/property/property_category_response_model.dart';
import '../../model/user_details_request.model.dart';
import '../../model/vendor_list_request.model.dart';
import 'common_api_services.dart';

part 'common_api_state.dart';

class CommonApiCubit extends Cubit<CommonApiState> {
  static CommonApiCubit? _instance;

  final CommonApiService commonApiService;

  factory CommonApiCubit({required CommonApiService commonApiService}) {
    _instance ??= CommonApiCubit._internal(commonApiService: commonApiService);
    return _instance!;
  }

  CommonApiCubit._internal({required this.commonApiService})
      : super(CommonApiInitial());

  List<CountryListData> countryListData = [];
  CityListData cityListData = CityListData();
  List<VendorListData> vendorListData = [];
  List<PropertyCategoryData> propertyCategoryListData = [];
  List<LanguageListData> languageListData = [];
  List<CurrencyListData>? currencyList = [];

  Future<dynamic> fetchCountryList({
    required CountryListRequestModel requestModel,
  }) async {
    emit(CommonApiLoading());

    final response =
        await commonApiService.getCountryList(requestModel: requestModel);
    if (response is CountryListResponseModel) {
      countryListData = response.countryListData ?? [];
      printf("CountryListData--------${countryListData.length}");
      emit(CountryListLoaded(countryListData: countryListData));
      return countryListData;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> fetchLanguageList() async {
    emit(CommonApiLoading());

    final response = await commonApiService.getLanguageList();
    if (response is LanguageListResponseModel) {
      languageListData = response.data ?? [];
      printf("LanguageListData--------${languageListData.length}");
      emit(LanguageListLoaded(languageListData: languageListData));
      return languageListData;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> fetchCurrencyList() async {
    emit(CommonApiLoading());

    final response = await commonApiService.getCurrencyList();
    if (response is CurrencyListResponseModel) {
      currencyList = response.data ?? [];
      emit(CurrencyListLoaded(currencyData: currencyList ?? []));
      return currencyList;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> fetchCityList({
    required CityListRequestModel requestModel,
  }) async {
    emit(CommonApiLoading());

    final response =
        await commonApiService.getCityList(requestModel: requestModel);
    if (response is CityListResponseModel) {
      if (response.cityListData != null) {
        cityListData = response.cityListData!;
        emit(CityListLoaded(
            cityListData: response.cityListData ?? CityListData()));
      }
      return cityListData;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> fetchCityListWithPagination({
    required CityListRequestModel requestModel,
  }) async {
    final response =
        await commonApiService.getCityList(requestModel: requestModel);
    if (response is CityListResponseModel) {
      if (response.cityListData != null) {
        cityListData = response.cityListData!;
        emit(CityListLoaded(
            cityListData: response.cityListData ?? CityListData()));
      }
      return response;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> fetchVendorList() async {
    emit(CommonApiLoading());

    final response =
        await commonApiService.getVendorList();
    if (response is VendorListResponseModel) {
      vendorListData = response.data ?? [];
      printf("CountryListData--------${vendorListData.length}");
      emit(VendorListLoaded(vendorListData: vendorListData));
      return vendorListData;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> fetchPropertyCategoryList(BuildContext context) async {
    emit(CommonApiLoading());

    final response = await commonApiService.getPropertyCategoryList();
    if (response is PropertyCategoryResponseModel) {
      propertyCategoryListData = response.data ?? [];
      printf("CountryListData--------${propertyCategoryListData.length}");
      AppConstants.setPropertyCategory(context, propertyCategoryListData);
      emit(PropertyCategoryListLoaded(
          propertyCategoryListData: propertyCategoryListData));
      return propertyCategoryListData;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> fetchUserFlagDetails({
    required UserDetailsRequestModel requestModel,
  }) async {
    emit(CommonApiLoading());

    final response =
        await commonApiService.getUserFlagDetails(requestModel: requestModel);
    if (response is UserDetailsResponseModel) {
      return response;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  ///User Details API
  Future<dynamic> getProfileDetails({
    required String userId,
  }) async {
    emit(CommonApiLoading());

    final response = await commonApiService.getUserDetails(userId: userId);

    if (response is VendorDetailResponseModel) {
      return response;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> addRemoveFavorite({
    required AddRemoveFavRequestModel requestModel,
  }) async {
    emit(CommonApiLoading());

    final response =
        await commonApiService.addRemoveFavorite(requestModel: requestModel);
    if (response is CommonOnlyMessageResponseModel) {
      return response;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }

  Future<dynamic> updateLang() async {
    emit(CommonApiLoading());

    final response = await commonApiService.updateLanguage();
    if (response is CommonOnlyMessageResponseModel) {
      return response;
    } else if (response is String) {
      emit(CommonApiError(errorMessage: response));
      return response;
    }
    return "Unknown error";
  }
}
