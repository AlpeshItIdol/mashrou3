import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/repository/authentication_repository.dart';

import '../../../../../../db/app_preferences.dart';

part 'view_all_certificates_state.dart';

class ViewAllCertificatesCubit extends Cubit<ViewAllCertificatesState> {
  AuthenticationRepository repository;

  ViewAllCertificatesCubit({required this.repository})
      : super(AddVendorInitial());

  var selectedRole = "";

  List<dynamic> certificatesList = [];

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context, List<dynamic> list) async {
    certificatesList.clear();
    certificatesList.addAll(list);
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    emit(CertificatesLoaded());
  }
}
