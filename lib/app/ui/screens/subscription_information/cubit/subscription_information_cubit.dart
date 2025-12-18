import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/resources/app_strings.dart';
import '../../../../db/app_preferences.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/verify_response.model.dart';
import '../../../../navigation/routes.dart';
import '../../../../repository/authentication_repository.dart';
import '../../property_details/sub_screens/vendor_finance/model/vendor_detail_response_model.dart';

part 'subscription_information_state.dart';

class SubscriptionInformationCubit extends Cubit<SubscriptionInformationState> {
  AuthenticationRepository repository;

  SubscriptionInformationCubit({required this.repository}) : super(SubscriptionInformationInitial());

  Future<void> handleSplashNavigation(BuildContext context) async {}

  /// Details API
  Future<void> getProfileDetails({required BuildContext context}) async {
    emit(LoadingUserStatus());
    var isLogin = await GetIt.I<AppPreferences>().getIsLoggedIn();
    var selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    if (isLogin && selectedUserRole != AppStrings.visitor) {
      var userId = await GetIt.I<AppPreferences>().getUserID();
      final response = await repository.userDetails(userId: userId);

      if (response is SuccessResponse && response.data is VendorDetailResponseModel) {
        VendorDetailResponseModel responseModel = response.data as VendorDetailResponseModel;
        UserDetailsData? detailData = (responseModel.data ?? UserDetailsData()) as UserDetailsData?;

        await GetIt.I<AppPreferences>().setSubscriptionRequired(value: detailData?.isSubscriptionEnabled == true);
        await GetIt.I<AppPreferences>().setUserSubscribed(value: detailData?.isSubscribed == true);

        if (detailData?.isSubscriptionEnabled == true) {
          if (detailData?.isSubscribed == true) {
            if (!context.mounted) return;
            _navigateToScreen(context);
          }
        } else {
          if (!context.mounted) return;
          _navigateToScreen(context);
        }
      }
    }
  }

  void _navigateToScreen(BuildContext context) async {
    var selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    var isUserLoggedIn = await GetIt.I<AppPreferences>().getIsLoggedIn();

    // If all conditions are met, navigate to the dashboard based on user role
    if (selectedUserRole == AppStrings.owner) {
      if (!context.mounted) return;
      context.goNamed(Routes.kOwnerDashboard);
    } else if (selectedUserRole == AppStrings.visitor) {
      if (!isUserLoggedIn) {
        // Navigate to login screen if the user is not logged in
        if (!context.mounted) return;
        context.goNamed(Routes.kLoginScreen);
        return;
      } else {
        if (!context.mounted) return;
        context.goNamed(Routes.kDashboard);
      }
    } else if (selectedUserRole == AppStrings.vendor) {
      if (!isUserLoggedIn) {
        // Navigate to login screen if the user is not logged in
        if (!context.mounted) return;
        context.goNamed(Routes.kLoginScreen);
        return;
      } else {
        if (!context.mounted) return;
        context.goNamed(Routes.kDashboard);
      }
    }
  }
}
