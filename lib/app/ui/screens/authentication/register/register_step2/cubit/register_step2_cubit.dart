import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/model/country_list_model.dart';
import 'package:mashrou3/config/resources/app_constants.dart';

import '../../../../../../../config/utils.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/country_request_mode.dart';
import '../../../../../../repository/authentication_repository.dart';
import '../../../component/bloc/country_selection_cubit.dart';
import '../model/sign_up_request.model.dart';
import '../model/sign_up_response.model.dart';

part 'register_step2_state.dart';

class RegisterStep2Cubit extends Cubit<RegisterStep2State> {
  AuthenticationRepository repository;

  RegisterStep2Cubit({required this.repository})
      : super(RegisterStep2Initial());

  AppPreferences appPreferences = AppPreferences();

  final formKey = GlobalKey<FormState>();

  TextEditingController mobileNumberCtl = TextEditingController();
  FocusNode mobileNumberFn = FocusNode();

  var selectedUserRole = "";
  var mobileNumberWithCountryCode = "";
  var countryCode = "+962";
  var countryCodeStr = "JO";

  List<CountryListData>? countryList = [];

  CountryListData selectedCountry = AppConstants.defaultCountry;

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context) async {
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";

    emit(ClearValueStateInit());
    await resetForm(context);

    await getCountryList(context);
  }

  /// Reset the form and data
  Future<void> resetForm(BuildContext context) async {
    emit(ClearValueStateInit());
    countryCode = "+962";
    context.read<RegisterStep2Cubit>().selectedCountry =
        AppConstants.defaultCountry;
    context.read<CountrySelectionCubit>().countryFlag =
        AppConstants.defaultCountryFlag;
    context.read<CountrySelectionCubit>().countryCode =
        AppConstants.defaultCountryCode;
    context.read<CountrySelectionCubit>().countryName =
        AppConstants.defaultCountryName;

    mobileNumberCtl.clear();
    selectedCountry = AppConstants.defaultCountry;

    mobileNumberFn.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    selectedCountry = AppConstants.defaultCountry;
    mobileNumberWithCountryCode = "";
    countryList?.clear();
    formKey.currentState?.reset();
    emit(ClearValueState());
  }

  /// Country List API
  ///
  Future<void> getCountryList(BuildContext context) async {
    emit(RegisterStep2Loading());
    final model = CountryListRequestModel(
      searchQuery: "",
      // countryId: selectedCountry.sId.toString(),
    );
    final response = await context
        .read<CommonApiCubit>()
        .fetchCountryList(requestModel: model);

    if (response is String) {
      emit(RegisterStep2Error(response));
    } else {
      countryList = response;
      printf("CountryList--------${countryList?.length}");
      emit(APISuccess());
    }
  }

  /// Send Verification Code API
  ///
  /// required [mobileNumber] as user entered mobileNumber.
  /// required [countryCode] as user entered countryCode.
  Future<void> sendVerificationCode(BuildContext context) async {
    emit(RegisterStep2Loading());

    selectedCountry = context.read<CountrySelectionCubit>().selectedCountry ??
        CountryListData(countryCode: "JO", phoneCode: "+962");
    String formatCountryCode(String phoneCode) {
      return phoneCode.startsWith("+") ? phoneCode.substring(1) : phoneCode;
    }

    var countryCode = formatCountryCode(selectedCountry.phoneCode!);

    mobileNumberWithCountryCode = "$countryCode&${mobileNumberCtl.text}";

    final reqModel = SignUpRequestModel(
      phoneCode: countryCode,
      contactNumber: mobileNumberCtl.text,
      country: selectedCountry.sId ?? AppConstants.defaultCountry.sId,
      userType: selectedUserRole,
    );

    final registerResponse = await repository.signUp(requestModel: reqModel);

    if (registerResponse is FailedResponse) {
      emit(RegisterStep2Error(registerResponse.errorMessage));
    } else if (registerResponse is SuccessResponse) {
      SignUpResponseModel signUpResponse = registerResponse.data;
      emit(RegisterStep2Initial());
      if (signUpResponse.data != null) {
        printf("----${signUpResponse.data?.users?.otp}");
      }

      emit(RegisterStep2Success(model: signUpResponse));
    }
  }
}
