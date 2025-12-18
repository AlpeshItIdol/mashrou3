import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/common_only_message_response_model.dart';
import 'package:mashrou3/app/ui/screens/authentication/register/register_step2/model/sign_up_response.model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_detail_response_model.dart';

import '../../config/network/dio_config.dart';
import '../../config/network/network_constants.dart';
import '../../config/utils.dart';
import '../model/base/base_model.dart';
import '../model/resend_otp_response.model.dart';
import '../ui/screens/authentication/login/model/login_request.model.dart';
import '../ui/screens/authentication/login/model/login_response.model.dart';
import '../ui/screens/authentication/model/logout_request_model.dart';
import '../ui/screens/authentication/register/register_step2/model/sign_up_request.model.dart';
import '../model/verify_request.model.dart';
import '../model/verify_response.model.dart';

abstract class AuthenticationRepository {
  Future<ResponseBaseModel> loginUser({
    required LoginRequest requestModel,
  });

  Future<ResponseBaseModel> logout({
    required LogoutRequest requestModel,
  });

  Future<ResponseBaseModel> signUp({
    required SignUpRequestModel requestModel,
  });

  Future<ResponseBaseModel> verifyOtp({
    required VerifyRequestModel requestModel,
  });

  Future<ResponseBaseModel> resendOtp({
    required LoginRequest requestModel,
  });

  /// Complete Profile
  Future<ResponseBaseModel> completeProfile(
      {required FormData data, required String userId});

  /// Update Profile
  Future<ResponseBaseModel> updateProfile(
      {required FormData data, required String userId});

  Future<ResponseBaseModel> userDetails({
    required String userId,
  });

  /// Delete Profile
  Future<ResponseBaseModel> deleteAccount({
    required String userId,
  });

}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  @override
  Future<ResponseBaseModel> loginUser(
      {required LoginRequest requestModel}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .postBaseAPI(url: NetworkAPIs.kLogin, data: requestModel.toJson());
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          LoginResponseModel loginResponse =
              LoginResponseModel.fromJson(response.data);
          return SuccessResponse(data: loginResponse);
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
  Future<ResponseBaseModel> logout(
      {required LogoutRequest requestModel}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kLogout,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CommonOnlyMessageResponseModel logoutResponse =
              CommonOnlyMessageResponseModel.fromJson(response.data);
          return SuccessResponse(data: logoutResponse);
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
  Future<ResponseBaseModel> signUp(
      {required SignUpRequestModel requestModel}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .postBaseAPI(url: NetworkAPIs.kRegister, data: requestModel.toJson());
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          SignUpResponseModel signUpResponse =
              SignUpResponseModel.fromJson(response.data);
          return SuccessResponse(data: signUpResponse);
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
  Future<ResponseBaseModel> verifyOtp(
      {required VerifyRequestModel requestModel}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
          url: NetworkAPIs.kSignUpVerifyOTP, data: requestModel.toJson());
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VerifyResponseModel verifyResponse =
              VerifyResponseModel.fromJson(response.data);
          return SuccessResponse(data: verifyResponse);
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
  Future<ResponseBaseModel> resendOtp(
      {required LoginRequest requestModel}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
          url: NetworkAPIs.kResendOtp, data: requestModel.toJson());
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          ResendOtpResponseModel resendOtpResponse =
              ResendOtpResponseModel.fromJson(response.data);
          return SuccessResponse(data: resendOtpResponse);
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
  Future<ResponseBaseModel> completeProfile(
      {required FormData data, required String userId}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().putBaseAPIWithToken(
          url: NetworkAPIs.kCompleteProfile, data: data, id: userId);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VerifyResponseModel data =
              VerifyResponseModel.fromJson(response.data);
          return SuccessResponse(data: data);
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
  Future<ResponseBaseModel> updateProfile(
      {required FormData data, required String userId}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().putBaseAPIWithToken(
          url: NetworkAPIs.kUpdateProfile, data: data, id: userId);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VerifyResponseModel data =
              VerifyResponseModel.fromJson(response.data);
          return SuccessResponse(data: data);
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
  Future<ResponseBaseModel> deleteAccount({
    required String userId,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().deleteBaseAPIWithToken(
        url: NetworkAPIs.kDeleteProfile + userId,
      );
      if (response.data != null) {
        if (response.statusCode == 200) {
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
}
