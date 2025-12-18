import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/otp_widget/bloc/otp_input_section_cubit.dart';
import 'package:mashrou3/utils/app_localization.dart';

import '../../../../../../config/utils.dart';
import '../../../../../model/base/base_model.dart';
import '../../../../../model/resend_otp_response.model.dart';
import '../../../../../model/verify_request.model.dart';
import '../../../../../model/verify_response.model.dart';
import '../../../../../repository/authentication_repository.dart';
import '../../login/model/login_request.model.dart';

part 'otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  AuthenticationRepository repository;

  OtpVerificationCubit({required this.repository}) : super(OtpVerificationInitial());

  final formKey = GlobalKey<FormState>();

  var mobileNumberWithCountryCode = "";

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    context.read<OtpInputSectionCubit>().controller.clear();
  }

  /// Verify OTP API
  ///
  /// required [otpCode] as user entered otp.
  Future<void> verifyOTP(BuildContext context) async {
    emit(OtpVerificationLoading());

    String otpCode = context.read<OtpInputSectionCubit>().controller.text ?? "";

    final reqModel = VerifyRequestModel(
      otp: otpCode,
      contactNumber: mobileNumberWithCountryCode.split("&")[1],
      phoneCode: mobileNumberWithCountryCode.split("&")[0],
    );

    final apiResponse = await repository.verifyOtp(requestModel: reqModel);

    if (apiResponse is FailedResponse) {
      emit(OtpVerificationError(apiResponse.errorMessage));
    } else if (apiResponse is SuccessResponse) {
      VerifyResponseModel verifyResponse = apiResponse.data;

      if (verifyResponse.verifyResponseData != null) {
        printf("${verifyResponse.message}");
      }
      emit(OtpVerificationSuccess(model: verifyResponse));
    }
  }

  /// Resend OTP API
  ///
  Future<void> resendOtp() async {
    emit(OtpVerificationLoading());

    // Split the mobile number and phone code
    final parts = mobileNumberWithCountryCode.split("&");
    final phoneCode = parts[0]; // part before '&' (e.g., "+962")
    final contactNumber = parts[1]; // part after '&' (e.g., "9999999988")

    final model = LoginRequest(contactNumber: contactNumber, phoneCode: phoneCode);

    final apiResponse = await repository.resendOtp(requestModel: model);

    if (apiResponse is FailedResponse) {
      emit(OtpVerificationError(apiResponse.errorMessage));
    } else if (apiResponse is SuccessResponse) {
      ResendOtpResponseModel resendOtpResponse = apiResponse.data;
      if (resendOtpResponse.message != null) {
        printf("${resendOtpResponse.message}");
        printf("${resendOtpResponse.data}");
      }
      emit(ResendOtpSuccess(resendOtpResponse));
    }
  }

  /// Method Timer Reset
  ///
  Future<void> timerReset(BuildContext context) async {
    context.read<OtpInputSectionCubit>().timerReset();
  }

  /// Method validate
  ///
  bool validate(BuildContext context) {
    if (context.read<OtpInputSectionCubit>().controller.text.isEmpty) {
      Utils.showErrorMessage(context: context, message: appStrings(context).textResendIn);
      return false;
    }
    return true;
  }
}
