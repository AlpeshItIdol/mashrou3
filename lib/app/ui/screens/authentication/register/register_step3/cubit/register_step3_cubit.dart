import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/otp_widget/bloc/otp_input_section_cubit.dart';

import '../../../../../../../config/utils.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/resend_otp_response.model.dart';
import '../../../../../../model/verify_request.model.dart';
import '../../../../../../model/verify_response.model.dart';
import '../../../../../../repository/authentication_repository.dart';
import '../../../login/model/login_request.model.dart';

part 'register_step3_state.dart';

class RegisterStep3Cubit extends Cubit<RegisterStep3State> {
  AuthenticationRepository repository;

  RegisterStep3Cubit({required this.repository}) : super(RegisterStep3Initial());

  final formKey = GlobalKey<FormState>();

  var selectedUserRole = "";
  var mobileNumberWithCountryCode = "";

  /// Get initial data
  ///
  Future<void> getData(BuildContext context) async {
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    Future.delayed(const Duration(milliseconds: 300), () {
      emit(SelectedRoleUpdate());
      context.read<OtpInputSectionCubit>().controller.clear();
    });
  }

  /// Resend OTP API
  ///
  Future<void> resendOtp() async {
    emit(RegisterStep3Loading());

    // Split the mobile number and phone code
    final parts = mobileNumberWithCountryCode.split("&");
    final phoneCode = parts[0]; // part before '&' (e.g., "+962")
    final contactNumber = parts[1]; // part after '&' (e.g., "9999999988")

    final model = LoginRequest(contactNumber: contactNumber, phoneCode: phoneCode);

    final apiResponse = await repository.resendOtp(requestModel: model);

    if (apiResponse is FailedResponse) {
      emit(RegisterStep3Error(apiResponse.errorMessage));
    } else if (apiResponse is SuccessResponse) {
      ResendOtpResponseModel resendOtpResponse = apiResponse.data;
      if (resendOtpResponse.message != null) {
        printf("${resendOtpResponse.message}");
        printf("${resendOtpResponse.data}");
      }
      emit(ResendOtpSuccess(resendOtpResponse));
    }
  }

  /// Verify OTP API
  ///
  /// required [otpCode] as user entered otp.
  Future<void> verifyOTP(BuildContext context) async {
    emit(RegisterStep3Loading());

    String otpCode = context.read<OtpInputSectionCubit>().controller.text;

    printf("otpCode----$otpCode");
    final reqModel = VerifyRequestModel(
      otp: otpCode,
      contactNumber: mobileNumberWithCountryCode.split("&")[1],
      phoneCode: mobileNumberWithCountryCode.split("&")[0],
    );

    final apiResponse = await repository.verifyOtp(requestModel: reqModel);

    if (apiResponse is FailedResponse) {
      emit(RegisterStep3Error(apiResponse.errorMessage));
    } else if (apiResponse is SuccessResponse) {
      VerifyResponseModel verifyResponse = apiResponse.data;

      if (verifyResponse.verifyResponseData != null) {
        printf("${verifyResponse.message}");
      }
      emit(RegisterStep3Success(model: verifyResponse));
    }
  }

  /// Method Timer reset
  ///
  Future<void> timerReset(BuildContext context) async {
    context.read<OtpInputSectionCubit>().timerReset();
  }
}
