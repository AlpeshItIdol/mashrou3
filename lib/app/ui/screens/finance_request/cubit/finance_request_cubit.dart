import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/offers/finance_request_details_model.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/screens/finance_request/model/finance_request_list_response.dart';
import 'package:mashrou3/config/network/network_constants.dart';

import '../../../../../config/resources/app_strings.dart';
import '../../../../db/app_preferences.dart';
import '../../../../model/verify_response.model.dart';

part 'finance_request_state.dart';

class FinanceRequestCubit extends Cubit<FinanceRequestState> {
  PropertyRepository repository;
  String userRoleType = AppStrings.visitor;
  VerifyResponseData? userSavedData;
  var selectedLanguage = 'en';
  bool isVendor = false;
  FinanceRequestDetailsData financeRequestDetailsData = FinanceRequestDetailsData();

  FinanceRequestCubit({required this.repository}) : super(FinanceRequestInitial());

  int totalRecords = 0;

  /// Finance Request list API
  Future<void> getList({
    int pageKey = 0,
  }) async {
    emit(FinanceRequestListLoading());

    //Fetch User Details & Language
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ?? VerifyResponseData();
    selectedLanguage = await GetIt.I<AppPreferences>().getLanguageCode() ?? 'en';
    if (userSavedData?.users != null) {
      final user = userSavedData!.users!;
      userRoleType = user.userType ?? AppStrings.visitor;
    } else {
      // Defaults if userSavedData or users is null
      userRoleType = AppStrings.visitor;
    }

    isVendor = userRoleType == AppStrings.vendor;

    final queryParameters = {
      NetworkParams.kPage: pageKey.toString(),
      NetworkParams.kItemPerPage: "10",
      NetworkParams.kSortOrder: "desc",
      NetworkParams.kSortField: "createdAt",
    };
    final response = await repository.getFinanceRequestListVisitor(queryParameters);

    if (response is SuccessResponse && response.data is FinanceRequestListResponse) {
      FinanceRequestListResponse financeRequestListResponse = response.data as FinanceRequestListResponse;
      final responseList = financeRequestListResponse.data?.financeData ?? [];

      bool isLastPage = responseList.length != 10;
      totalRecords = financeRequestListResponse.data?.documentCount ?? 0;

      if (responseList.isEmpty) {
        emit(NoFinanceRequestListFoundState());
      } else {
        emit(FinanceRequestListSuccess(isLastPage, pageKey, responseList));
      }
    } else if (response is FailedResponse) {
      emit(NoFinanceRequestListFoundState());
      emit(FinanceRequestListError(errorMessage: response.errorMessage));
    }
  }

  Future<void> getFinanceRequestDetails(BuildContext context, String sID) async {
    emit(FinanceRequestListLoading());
    final response = await repository.getFinanceRequestDetails(context: context, requestId: sID);

    if (response is SuccessResponse && response.data is FinanceRequestDetailsModel) {
      FinanceRequestDetailsModel financeRequestDetailsModel = response.data as FinanceRequestDetailsModel;
      financeRequestDetailsData = financeRequestDetailsModel.data!;
      emit(FinanceRequestDetailsSuccess(model: financeRequestDetailsData));
    } else if (response is FailedResponse) {
      emit(FinanceRequestDetailsError(errorMessage: response.errorMessage));
    }
  }
}
