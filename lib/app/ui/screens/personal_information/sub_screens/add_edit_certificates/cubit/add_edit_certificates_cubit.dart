import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/repository/authentication_repository.dart';

import '../../../../../../../config/network/network_constants.dart';
import '../../../../../../../config/resources/app_strings.dart';
import '../../../../../../../config/utils.dart';
import '../../../../../../../utils/app_localization.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/verify_response.model.dart';
import '../../../cubit/personal_information_cubit.dart';

part 'add_edit_certificates_state.dart';

class AddEditCertificatesCubit extends Cubit<AddEditCertificatesState> {
  AuthenticationRepository repository;

  AddEditCertificatesCubit({required this.repository})
      : super(AddVendorInitial());

  AppPreferences appPreferences = AppPreferences();

  var selectedUserId = "";
  var selectedRole = "";
  bool isForPortfolio = false;
  bool isForEdit = false;

  VerifyResponseData? userSavedData;

  List<dynamic> certificatesList = [];
  List<String> httpCertificatesList = [];
  List<String> httpPortfolioList = [];

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context, List<dynamic> list) async {
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();

    selectedUserId = await GetIt.I<AppPreferences>().getUserID();
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";

    certificatesList.clear();
    httpCertificatesList.clear();
    httpPortfolioList.clear();

    httpCertificatesList
        .addAll(userSavedData?.users?.identityVerificationDoc ?? []);
    httpPortfolioList.addAll(userSavedData?.users?.portfolio ?? []);
    emit(DefaultDataInit());
    if (list.isNotEmpty) {
      certificatesList.addAll(list);
    } else {
      certificatesList = [];
    }

    emit(DefaultDataLoaded());
  }

  void updateAttachments(List<dynamic> documents, BuildContext context) {
    // certificatesList = documents;
    emit(AttachmentLoaded());
  }

  /// MULTIPART UPDATE CERTIFICATES API
  ///
  Future<void> updateDocumentsAPI(BuildContext context) async {
    emit(AddEditCertificatesLoading());

    var formData = FormData();

    List<dynamic> httpDocumentsList = [];
    if (certificatesList.isNotEmpty) {
      httpDocumentsList =
          certificatesList.where((item) => item.startsWith('http')).toList();
      if (!isForEdit) {
        if (isForPortfolio) {
          printf("length---${httpPortfolioList.length}");
          httpDocumentsList.addAll(httpPortfolioList);
        } else {
          printf("length---${httpCertificatesList.length}");
          httpDocumentsList.addAll(httpCertificatesList);
        }
      }
    }

    if (isForPortfolio) {
      formData = FormData.fromMap({
        NetworkParams.kPortfolio: json.encode(httpDocumentsList),
        NetworkParams.kIdentityVerificationDoc:
            json.encode(httpCertificatesList),
      });
    } else {
      formData = FormData.fromMap({
        NetworkParams.kIdentityVerificationDoc: json.encode(httpDocumentsList),
        NetworkParams.kPortfolio: json.encode(httpPortfolioList),
      });
    }

    printf(formData);
    if (certificatesList.isNotEmpty) {
      // Limit total files to 10
      int addedFilesCount = httpDocumentsList.length;

      for (var file in certificatesList) {
        if (addedFilesCount > 10) {
          printf("Maximum limit reached: You’re allowed to add up to 10 files only.");
          if (!context.mounted) return;
          Utils.showErrorMessage(
            context: context,
            message: appStrings(context).maximumLimitReached,
          );
          break;
        }

        if (!file.startsWith('http') && file.length > 2) {
          final multipartFile = await MultipartFile.fromFile(file);
          formData.files.add(MapEntry(
              isForPortfolio
                  ? NetworkParams.kPortfolio
                  : NetworkParams.kIdentityVerificationDoc,
              multipartFile));
        }
      }
    }

    printf(formData);

    final createProjectResponse =
        await repository.updateProfile(data: formData, userId: selectedUserId);

    if (createProjectResponse is FailedResponse) {
      emit(AddEditCertificatesFailure(createProjectResponse.errorMessage));
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

      PersonalInformationCubit personalInformationCubit =
          context.read<PersonalInformationCubit>();

      // await personalInformationCubit.updateData();
      await personalInformationCubit.getData(context);

      emit(AddEditCertificatesSuccess());
    }
  }
}
