import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/common_only_message_response_model.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/country_selection_cubit.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/country_list_model.dart';
import '../../../../../../repository/authentication_repository.dart';
import '../../../../../../repository/common_api_repository.dart';
import '../../../model/logout_request_model.dart';

part 'undergoing_verification_state.dart';

class UndergoingVerificationCubit extends Cubit<UndergoingVerificationState> {
  AuthenticationRepository repository;

  UndergoingVerificationCubit({
    required this.repository,
  }) : super(UndergoingVerificationInitial());

  var token = "";

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    token = await GetIt.I<AppPreferences>().getApiToken() ?? "";
  }

  /// Logout API
  ///
  /// required [token] as user token.
  Future<void> logout() async {
    emit(UndergoingVerificationLoading());

    final model = LogoutRequest(token: token);

    final apiResponse = await repository.logout(requestModel: model);

    if (apiResponse is FailedResponse) {
      emit(UndergoingVerificationError(apiResponse.errorMessage));
    } else if (apiResponse is SuccessResponse) {
      CommonOnlyMessageResponseModel logoutResponse = apiResponse.data;
      if (logoutResponse.message != null) {
        printf("${logoutResponse.message}");
      }
      emit(UndergoingVerificationSuccess());
    }
  }
}
