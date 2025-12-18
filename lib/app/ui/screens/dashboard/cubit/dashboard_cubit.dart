import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/repository/authentication_repository.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_detail_response_model.dart';

import '../../../../../config/resources/app_constants.dart';
import '../../../../../config/utils.dart';
import '../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../db/app_preferences.dart';
import '../../../../model/common_only_message_response_model.dart';
import '../../../../model/property/property_category_response_model.dart';
import '../../../../model/verify_response.model.dart';
import '../../../../repository/common_api_repository.dart';
import '../../../../repository/notification_repository.dart';
import '../../authentication/model/logout_request_model.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  AuthenticationRepository repository;
  NotificationRepository notificationRepository;
  CommonApiRepository commonApiRepository;

  DashboardCubit({
    required this.repository,
    required this.notificationRepository,
    required this.commonApiRepository,
  }) : super(DashboardInitial());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedDrawerIndex = -1;
  int selectedPageIndex = 0;
  int selectedSortIndex = 0;

  var isGuest = false;

  String? searchText;
  var selectedUserRole = "";
  VerifyResponseData? userSavedData;

  Future<void> getData(BuildContext context) async {
    emit(GuestUserInitState());

    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isGuest = await GetIt.I<AppPreferences>().getIsGuestUser();

    printf("Isguest = $isGuest");
    printf("selectedUserRole = $selectedUserRole");
    searchText = "";
    selectedPageIndex = 0;
    if (!isGuest) {
      await getUserProfileDetails(
          context: context, id: userSavedData?.users?.sId ?? "");
    }
    emit(GuestUserState());
    await Future.delayed(const Duration(milliseconds: 00));
  }

  void changeSideDrawer(int drawerIndex) {
    emit(DashboardSideDrawerChange(drawerIndex: drawerIndex));
  }

  void saveFCMToken(BuildContext context) async {
    final isGuestUser = await GetIt.I<AppPreferences>().getIsGuestUser();
    if (isGuestUser) return;

    final userToken = await GetIt.I<AppPreferences>().getFCMToken();
    notificationRepository.saveFCMToken(userToken).then((_) {
      GetIt.I<AppPreferences>().setFCMTokenUpdate(true);
    });

    // Update user's language on server which is currently selected.
    commonApiRepository.updateLanguage();
  }

  Future<void> getUserProfileDetails(
      {required BuildContext context, required String id}) async {
    final userProfileDataResponse =
        await context.read<CommonApiCubit>().getProfileDetails(userId: id);

    if (userProfileDataResponse is String) {
    } else {
      var data = userProfileDataResponse as VendorDetailResponseModel;
      var token = await GetIt.I<AppPreferences>().getApiToken();
      VerifyResponseData verifyResponseData = VerifyResponseData(
          token: token, users: data.data ?? UserDetailsData());
      await GetIt.I<AppPreferences>().setUserDetails(verifyResponseData);
    }
  }

  /// Method to change the selected page based on the bottom navigation index
  ///
  void changePage(int pageIndex) {
    selectedPageIndex = pageIndex;
    emit(DashboardPageChange(pageIndex: pageIndex));
  }

  /// Logout API
  ///
  /// required [token] as user token.
  Future<void> logout() async {
    emit(LogoutLoading());

    final model =
        LogoutRequest(token: await GetIt.I<AppPreferences>().getApiToken());

    final apiResponse = await repository.logout(requestModel: model);

    if (apiResponse is FailedResponse) {
      emit(LogoutError(apiResponse.errorMessage));
    } else if (apiResponse is SuccessResponse) {
      CommonOnlyMessageResponseModel logoutResponse = apiResponse.data;
      if (logoutResponse.message != null) {
        printf("${logoutResponse.message}");
      }
      emit(LogoutSuccess());
    }
  }

  List<PropertyCategoryData>? propertyCategoryList = [];

  /// Property Category List API
  ///
  Future<void> getPropertyCategoryList(BuildContext context) async {
    emit(LogoutLoading());

    final response =
        await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);

    if (response is String) {
      emit(LogoutError(response));
    } else {
      propertyCategoryList = response;
      emit(APISuccess());
      AppConstants.setPropertyCategory(context, propertyCategoryList);
      emit(PropertyCategoryListUpdate());
    }
  }
}
