import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/country_selection_cubit.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../../config/resources/app_constants.dart';
import '../../../../../db/app_preferences.dart';
import '../../../../../model/country_list_model.dart';
import '../../../../../repository/authentication_repository.dart';
import '../../../../../model/base/base_model.dart';
import '../../../../../repository/common_api_repository.dart';
import '../model/login_request.model.dart';
import '../model/login_response.model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  AuthenticationRepository repository;
  CommonApiRepository commonApiRepository;

  LoginCubit({required this.repository, required this.commonApiRepository})
      : super(LoginInitial());

  final formKey = GlobalKey<FormState>();

  TextEditingController mobileNumberCtl = TextEditingController();
  FocusNode mobileNumberFn = FocusNode();

  var selectedRole = "";
  var countryCode = "+962";
  var countryCodeStr = "JO";
  var mobileNumberWithCountryCode = "";

  bool shouldValidate = true;

  // List<CountryListData>? countryList = [];
  CountryListData selectedCountry = AppConstants.defaultCountry;

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    countryCode = "+962";
    countryCodeStr = "JO";

    mobileNumberCtl.clear();
    mobileNumberWithCountryCode = "";
    // countryList?.clear();
    context.read<CountrySelectionCubit>().resetToDefault();
    // await getCountryList(context);
  }

  /// Login API
  ///
  /// required [mobileNumber] as user entered mobile number.
  Future<void> login(BuildContext context) async {
    emit(LoginLoading());

    selectedCountry = context.read<CountrySelectionCubit>().selectedCountry ??
        CountryListData(countryCode: "JO", phoneCode: "962");
    // String formatCountryCode(String phoneCode) {
    //   return phoneCode.contains("+") ? phoneCode : "+$phoneCode";
    // }
    String formatCountryCode(String phoneCode) {
      return phoneCode.startsWith("+") ? phoneCode.substring(1) : phoneCode;
    }

    var countryCode = formatCountryCode(selectedCountry.phoneCode!);

    // mobileNumberWithCountryCode = countryCode + mobileNumberCtl.text;
    mobileNumberWithCountryCode = "$countryCode&${mobileNumberCtl.text}";

    final model = LoginRequest(
        contactNumber: mobileNumberCtl.text, phoneCode: countryCode);

    final apiResponse = await repository.loginUser(requestModel: model);

    if (apiResponse is FailedResponse) {
      emit(LoginError(apiResponse.errorMessage));
    } else if (apiResponse is SuccessResponse) {
      LoginResponseModel loginResponse = apiResponse.data;

      await GetIt.I<AppPreferences>().setSubscriptionRequired(value: loginResponse.loginResponseData?.users?.isSubscriptionEnabled == true);
      await GetIt.I<AppPreferences>().setUserSubscribed(value: loginResponse.loginResponseData?.users?.isSubscribed == true);

      if (loginResponse.loginResponseData != null) {
        printf("${loginResponse.loginResponseData?.users?.otp}");
      }
      if (formKey.currentState != null) {
        formKey.currentState?.reset(); // Reset the form validation state
      }
      emit(LoginSuccess(loginResponse: loginResponse));
    }
  }

  /// Country List API
  ///
// Future<void> getCountryList(BuildContext context) async {
//   emit(LoginLoading());
//
//   final model = CountryListRequestModel(
//     searchQuery: "",
//     // countryId: selectedCountry.sId.toString(),
//   );
//
//   final response = await context.read<CommonApiCubit>().fetchCountryList(requestModel: model );
//
//   if (response is String) {
//     emit(LoginError(response));
//   } else {
//     countryList = response;
//     printf("CountryList--------${countryList?.length}");
//     emit(APISuccess());
//   }
// }
}
