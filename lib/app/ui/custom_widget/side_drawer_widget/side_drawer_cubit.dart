import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';
import 'package:mashrou3/app/model/verify_response.model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../db/app_preferences.dart';

part 'side_drawer_state.dart';

class SideDrawerCubit extends Cubit<SideDrawerState> {
  SideDrawerCubit() : super(SideDrawerInitial());
  bool isGuest = false;
  bool isVisitor = false;
  bool isVendor = false;
  String userName = "";
  String userImg = "";
  String userRoleType = AppStrings.visitor;
  VerifyResponseData? userSavedData;
  var supportData = Support();

  Future<void> initializeData() async {
    try {
      // Fetch user preferences
      isGuest = await GetIt.I<AppPreferences>().getIsGuestUser();
      supportData =
          (await GetIt.I<AppPreferences>().getSupportDetails()) ?? Support();

      userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
          VerifyResponseData();
      if (userSavedData?.users != null) {
        final user = userSavedData!.users!;

        userName = "${user.firstName ?? ""} ${user.lastName ?? ""}".trim();
        userImg = user.companyLogo ?? "";
        userRoleType = user.userType ?? AppStrings.visitor;
      } else {
        // Defaults if userSavedData or users is null
        userName = "";
        userImg = "";
        userRoleType = AppStrings.visitor;
      }

      isVisitor = userRoleType == AppStrings.visitor;
      isVendor = userRoleType == AppStrings.vendor;

      emit(SideDrawerDataSet());
      emit(SideDrawerImgDataSet());
    } catch (e, stackTrace) {
      // Log errors
      printf("Error initializing SideDrawerWidget: $e\n$stackTrace");
    }
  }
}
