import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/repository/common_api_repository.dart';

import '../../model/city_list_request.model.dart';
import '../../model/country_request_mode.dart';
import '../../model/property/add_to_fav_request_model.dart';
import '../../model/property/address_location_response_model.dart';
import '../../model/user_details_request.model.dart';
import '../../model/vendor_list_request.model.dart';

class CommonApiService {
  final CommonApiRepository commonApiRepository;

  CommonApiService({required this.commonApiRepository});

  Future<dynamic> getCountryList({
    required CountryListRequestModel requestModel,
  }) async {
    final apiResponse =
        await commonApiRepository.countryList(requestModel: requestModel);
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> getCityList({
    required CityListRequestModel requestModel,
  }) async {
    final apiResponse =
        await commonApiRepository.cityList(requestModel: requestModel);
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> getUserFlagDetails({
    required UserDetailsRequestModel requestModel,
  }) async {
    final apiResponse =
        await commonApiRepository.userFlagDetails(requestModel: requestModel);
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> getUserDetails({
    required String userId,
  }) async {
    final apiResponse = await commonApiRepository.userDetails(userId: userId);
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> addRemoveFavorite({
    required AddRemoveFavRequestModel requestModel,
  }) async {
    final apiResponse =
        await commonApiRepository.addRemoveFavorite(requestModel: requestModel);
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> updateLanguage() async {
    final apiResponse = await commonApiRepository.updateLanguage();
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> getLanguageList() async {
    final apiResponse = await commonApiRepository.languageList();
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> getCurrencyList() async {
    final apiResponse = await commonApiRepository.getCurrencyList();
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> getVendorList() async {
    final apiResponse = await commonApiRepository.vendorList();
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> getPropertyCategoryList() async {
    final apiResponse = await commonApiRepository.propertyCategoryList();
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }

  Future<dynamic> getAddressLocationList() async {
    final apiResponse = await commonApiRepository.getAddressLocationList();
    if (apiResponse is SuccessResponse) {
      return apiResponse.data;
    } else if (apiResponse is FailedResponse) {
      return apiResponse.errorMessage;
    }
  }
}
