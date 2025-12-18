import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';


import '../../../../../../db/app_preferences.dart';
import '../../../../../../repository/authentication_repository.dart';

part 'register_step1_state.dart';

class RegisterStep1Cubit extends Cubit<RegisterStep1State> {
  AuthenticationRepository repository;

  RegisterStep1Cubit({required this.repository})
      : super(RegisterStep1Initial());

  AppPreferences appPreferences = AppPreferences();

  var selectedUserRole = "";

  TextEditingController mobileNumberCtl = TextEditingController();
  FocusNode mobileNumberFn = FocusNode();

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    mobileNumberCtl.clear();
  }
}
