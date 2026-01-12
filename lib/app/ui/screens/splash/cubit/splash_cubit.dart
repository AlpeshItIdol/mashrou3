import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/repository/authentication_repository.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../config/resources/app_strings.dart';
import '../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../db/app_preferences.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/property/property_category_response_model.dart';
import '../../../../model/user_details_request.model.dart';
import '../../../../model/user_details_response.model.dart';
import '../../../../model/verify_response.model.dart';
import '../../property_details/sub_screens/vendor_finance/model/vendor_detail_response_model.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  AuthenticationRepository repository;

  SplashCubit({required this.repository}) : super(SplashInitial());
  bool isDarkModeEnabled = false;
  List<PropertyCategoryData>? propertyCategoryList = [];

  var isVerified = false;
  var isProfileCompleted = false;
  var isActive = false;
  UserDetailsResponseModel userDetailsStatus = UserDetailsResponseModel();

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context) async {
    isDarkModeEnabled = await GetIt.I<AppPreferences>().getIsDarkMode();
    printf(isDarkModeEnabled);
    // Fetch address location list on app launch
    _fetchAddressLocations(context);
    navigateToScreen();
  }

  Future<void> _fetchAddressLocations(BuildContext context) async {
    if (!context.mounted) return;
    final appPreferences = AppPreferences();
    final storedData = await appPreferences.getAddressLocationData();
    if (storedData == null || storedData.locationData == null || storedData.locationData!.isEmpty) {
      // Fetch from API if not stored
      context.read<CommonApiCubit>().fetchAddressLocationList();
    }
  }

  /// navigate to welcome screen
  Future<void> navigateToScreen() async {
    getProfileDetails();
    Future.delayed(const Duration(seconds: 3), () {
      emit(InitialiseComplete());
    });
  }

  Future<void> handleSplashNavigation(BuildContext context) async {
    /// Splash login handling
    ///
    var userId = await GetIt.I<AppPreferences>().getUserID();
    isVerified = await GetIt.I<AppPreferences>().getIsVerified();
    isProfileCompleted = await GetIt.I<AppPreferences>().getIsProfileCompleted();
    isActive = await GetIt.I<AppPreferences>().getIsActive();
    var isUserLoggedIn = await GetIt.I<AppPreferences>().getIsLoggedIn();
    var isGuestUser = await GetIt.I<AppPreferences>().getIsGuestUser();
    var selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";

    /// User Flag Details API calling
    ///
    if (userId.trim().isNotEmpty) {
      if (!context.mounted) return;
      await getUserFlagDetails(context, userId);
    }

    if (isGuestUser) {
      await GetIt.I<AppPreferences>().isGuestUser(value: false);
      // Navigate to login screen if the user is not logged in
      if (!context.mounted) return;
      context.goNamed(Routes.kLoginScreen);
      return;
    }

    if (!isVerified) {
      // Navigate to login screen if the user is not verified
      if (!context.mounted) return;
      context.goNamed(Routes.kLoginScreen);
      return;
    }

    if (selectedUserRole == AppStrings.owner || selectedUserRole == AppStrings.vendor) {
      if (!isProfileCompleted) {
        // Navigate to the profile completion screen if profile is incomplete
        if (!context.mounted) return;
        context.goNamed(Routes.kCompleteProfileScreen);
        return;
      }

      if (!isActive) {
        // Navigate to the undergoing verification screen if the user is not active
        if (!context.mounted) return;
        context.goNamed(Routes.kUndergoingVerificationScreen);
        return;
      }

      var isSubscriptionEnableByAdmin = await GetIt.I<AppPreferences>().getSubscriptionRequired();

      var isSubscriptionActive = await GetIt.I<AppPreferences>().isSubscriptionEnable();

      if (isSubscriptionEnableByAdmin && !isSubscriptionActive) {
        if (!context.mounted) return;
        context.goNamed(Routes.kSubscriptionInformation);
        return;
      }

      if (!isUserLoggedIn) {
        // Navigate to login screen if the user is not logged in
        if (!context.mounted) return;
        context.goNamed(Routes.kLoginScreen);
        return;
      }
    }

    // If all conditions are met, navigate to the dashboard based on user role
    if (selectedUserRole == AppStrings.owner) {
      // TODO: For Vendor Session management Remaining.

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

  Future<void> visitorNavigation(BuildContext context) async {
    var isUserLoggedIn = await GetIt.I<AppPreferences>().getIsLoggedIn();
    if (isUserLoggedIn) {
      if (!context.mounted) return;
      context.goNamed(Routes.kDashboard);
      // context.goNamed(Routes.kUndergoingVerificationScreen);
    } else {
      if (!context.mounted) return;
      context.goNamed(Routes.kLoginScreen);
    }
  }

  Future<void> ownerAndVendorNavigation(BuildContext context) async {
    var isUserLoggedIn = await GetIt.I<AppPreferences>().getIsLoggedIn();
    var isVerified = await GetIt.I<AppPreferences>().getIsVerified();
    var isProfileCompleted = await GetIt.I<AppPreferences>().getIsProfileCompleted();
    var isActive = await GetIt.I<AppPreferences>().getIsActive();
    if (isUserLoggedIn) {
      if (isActive) {
        if (isProfileCompleted) {
        } else {
          if (!context.mounted) return;
          context.goNamed(Routes.kCompleteProfileScreen);
        }
        if (!context.mounted) return;
        context.goNamed(Routes.kOwnerDashboard);
      } else {
        if (!context.mounted) return;
        context.goNamed(Routes.kUndergoingVerificationScreen);
      }

      if (isVerified) {
      } else {
        if (!context.mounted) return;
        context.goNamed(Routes.kLoginScreen);
      }
    } else {
      if (!context.mounted) return;
      context.goNamed(Routes.kLoginScreen);
    }
  }

  Future<void> getUserFlagDetails(BuildContext context, String id) async {
    emit(SplashLoading());

    final model = UserDetailsRequestModel(
      id: id.toString(),
    );

    final response = await context.read<CommonApiCubit>().fetchUserFlagDetails(requestModel: model);

    if (response is String) {
      emit(SplashError(errorMessage: response));
    } else {
      userDetailsStatus = response;
      isVerified = userDetailsStatus.data?.isVerified ?? false;
      isActive = userDetailsStatus.data?.isActive ?? false;
      isProfileCompleted = userDetailsStatus.data?.profileComplete ?? false;
      emit(APISuccess());
    }
  }

  /// Details API
  Future<void> getProfileDetails() async {
    var isLogin = await GetIt.I<AppPreferences>().getIsLoggedIn();
    var selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    if (isLogin && selectedUserRole != AppStrings.visitor) {
      var userId = await GetIt.I<AppPreferences>().getUserID();
      final response = await repository.userDetails(userId: userId);

      if (response is SuccessResponse) {
        VendorDetailResponseModel responseModel = response.data as VendorDetailResponseModel;
        UserDetailsData? detailData = responseModel.data;
        await GetIt.I<AppPreferences>().setSubscriptionRequired(value: detailData?.isSubscriptionEnabled == true);
        await GetIt.I<AppPreferences>().setUserSubscribed(value: detailData?.isSubscribed == true);
      }
    }
  }
}
