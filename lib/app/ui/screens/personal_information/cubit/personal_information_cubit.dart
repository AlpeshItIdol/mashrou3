import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/repository/authentication_repository.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../config/network/network_constants.dart';
import '../../../../../config/resources/app_strings.dart';
import '../../../../db/app_preferences.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/common_only_message_response_model.dart';
import '../../../../model/verify_response.model.dart';

part 'personal_information_state.dart';

class PersonalInformationCubit extends Cubit<PersonalInformationState> {
  PersonalInformationCubit({required this.repository})
      : super(PersonalInformationInitial());
  AuthenticationRepository repository;

  var selectedUserId = "";
  var selectedRole = "";

  VerifyResponseData? userSavedData;
  List<dynamic> profilePictureList = [];
  List<String> certificatesList = [];
  List<String> portfolioList = [];
  List<String> httpCertificatesList = [];
  List<String> httpPortfolioList = [];

  Future<void> getData(BuildContext context) async {
    userSavedData = VerifyResponseData();
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();

    selectedUserId = await GetIt.I<AppPreferences>().getUserID();
    printf(selectedUserId);
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    if (!context.mounted) return;
    setEditData(context);
    profilePictureList = [userSavedData?.users?.companyLogo ?? ""];
    emit(UserDetailsLoadedForPersonalInformation());
  }

  Future<void> updateData() async {
    emit(UpdatedUserDetailsLoading());

    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();

    profilePictureList = [userSavedData?.users?.companyLogo ?? ""];
    emit(UpdatedUserDetailsLoaded());
  }

  void setEditData(BuildContext context) {
    profilePictureList.clear();
    certificatesList.clear();
    portfolioList.clear();
    if (userSavedData != null && userSavedData?.users != null) {
      httpCertificatesList.clear();
      httpPortfolioList.clear();

      httpCertificatesList
          .addAll(userSavedData?.users?.identityVerificationDoc ?? []);
      httpPortfolioList.addAll(userSavedData?.users?.portfolio ?? []);

      profilePictureList = [userSavedData?.users?.companyLogo ?? ""];
      certificatesList
          .addAll(userSavedData?.users?.identityVerificationDoc ?? []);
      if (selectedRole == AppStrings.vendor) {
        portfolioList.addAll(userSavedData?.users?.portfolio ?? []);
      }
    }
  }

  Future<void> updateImageData(BuildContext context) async {
    await updateProfilePictureAPI(context);
    emit(ImageDataLoaded());
  }

  /// Delete Profile API
  Future<void> deleteProfile() async {
    emit(PersonalInformationLoading());

    final response = await repository.deleteAccount(userId: selectedUserId);

    if (response is SuccessResponse &&
        response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel deleteResponse =
          response.data as CommonOnlyMessageResponseModel;

      emit(DeleteProfileSuccess(deleteResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(PersonalInformationError(errorMessage: response.errorMessage));
    }
  }

  /// MULTIPART UPDATE PROFILE PICTURE API
  ///
  Future<void> updateProfilePictureAPI(BuildContext context) async {
    emit(PersonalInformationLoading());
    var formData = FormData();

    // Initial mandatory fields
    formData = FormData.fromMap({
      NetworkParams.kPortfolio: json.encode(httpPortfolioList),
      NetworkParams.kIdentityVerificationDoc: json.encode(httpCertificatesList),
    });

    if (profilePictureList.isNotEmpty) {
      dynamic multipartFile = "";
      if (!profilePictureList.first.startsWith('http')) {
        multipartFile = await MultipartFile.fromFile(profilePictureList.first);
        formData.files.add(MapEntry(NetworkParams.kCompanyLogo, multipartFile));
      } else {
        formData.fields
            .add(MapEntry(NetworkParams.kCompanyLogo, multipartFile));
        multipartFile = profilePictureList.first;
      }
      formData.fields
          .add(MapEntry(NetworkParams.kAction, NetworkParams.kValueAction.toString(),));
    }

    printf(formData);
    final createProjectResponse =
        await repository.updateProfile(data: formData, userId: selectedUserId);

    if (createProjectResponse is FailedResponse) {
      emit(PersonalInformationError(
          errorMessage: createProjectResponse.errorMessage));
    } else if (createProjectResponse is SuccessResponse) {
      VerifyResponseModel response = createProjectResponse.data;
      userSavedData = response.verifyResponseData;
      final appPreferences = GetIt.I<AppPreferences>();
      final verifyResponseData = response;
      final user = response.verifyResponseData?.users;
      if (verifyResponseData.verifyResponseData != null && user != null) {
        // Set user details and role type
        await appPreferences
            .setUserDetails(verifyResponseData.verifyResponseData!);
      }
      if (!context.mounted) return;
      await getData(context);
      emit(CompleteProfileSuccess(model: response));
    }
  }
}
