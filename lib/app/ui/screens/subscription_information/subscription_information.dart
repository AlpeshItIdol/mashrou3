import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/screens/subscription_information/cubit/subscription_information_cubit.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../../config/resources/app_values.dart';
import '../../../../utils/app_localization.dart';
import '../../../../utils/ui_components.dart';
import '../../../db/app_preferences.dart';
import '../../../db/session_tracker.dart';
import '../../../navigation/routes.dart';
import '../../custom_widget/app_bar_mixin.dart';
import '../../custom_widget/common_row_bottons.dart';
import '../app_prefereces/cubit/app_preferences_cubit.dart';

class SubscriptionInformation extends StatefulWidget {
  const SubscriptionInformation({super.key});

  @override
  State<SubscriptionInformation> createState() => _SubscriptionInformationState();
}

class _SubscriptionInformationState extends State<SubscriptionInformation> with WidgetsBindingObserver, AppBarMixin {
  @override
  void initState() {
    super.initState();
    // Add observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This method gets called on app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      context.read<SubscriptionInformationCubit>().getProfileDetails(context: context);
    }
  }

  void _logout() async {
    await SessionTracker().onLogout();
    await GetIt.I<AppPreferences>().clearData();
    context.goNamed(Routes.kLoginScreen);
  }

  /// Method logout dialog
  ///
  void logoutDialog(BuildContext context) {
    UIComponent.showCustomBottomSheet(
        context: context,
        builder: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIComponent.customRTLIcon(child: SVGAssets.logoutIcon.toSvg(context: context), context: context),
            12.verticalSpace,
            Text(
              appStrings(context).wantToLogOut,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.verticalSpace,
            Text(
              appStrings(context).logoutInfo,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            ButtonRow(
              leftButtonText: appStrings(context).cancel,
              rightButtonText: appStrings(context).logout,
              onLeftButtonTap: () {
                context.pop();
              },
              onRightButtonTap: () async {
                _logout();
                context.pop();
              },
              rightButtonBorderColor: AppColors.red00,
              rightButtonBgColor: Theme.of(context).canvasColor,
              leftButtonBgColor: Theme.of(context).canvasColor,
              leftButtonBorderColor: AppColors.black14,
              leftButtonTextColor: AppColors.black14,
              rightButtonTextColor: AppColors.red00,
              isLeftButtonGradient: false,
              isRightButtonGradient: false,
              isLeftButtonBorderRequired: true,
              isRightButtonBorderRequired: true,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        onBackTap: () {
          logoutDialog(context);
        },
        requireLeading: true,
        title: "",
      ),
      backgroundColor: AppColors.pageBackground.forLightMode(context),
      body: _buildAvatar(context),
      bottomNavigationBar: _buildBottomInformation(context),
    );
  }

  /// Build center logo
  Widget _buildCenterLogo(BuildContext context) {
    SubscriptionInformationCubit cubit = context.read<SubscriptionInformationCubit>();
    return BlocConsumer<SubscriptionInformationCubit, SubscriptionInformationState>(
      listener: buildBlocListener,
      builder: (_, __) {
        return Center(child: _buildAvatar(context));
      },
    );
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(BuildContext context, SubscriptionInformationState state) async {
    if (!mounted) {
      return;
    }
    if (state is UserStatusSubscribed) {
      context.read<SubscriptionInformationCubit>().handleSplashNavigation(context);
    }
  }

  /// build app logo
  Widget _buildAvatar(BuildContext context) {
    return BlocConsumer<AppPreferencesCubit, AppPreferencesState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.watch<AppPreferencesCubit>();
        final isDark = cubit.isDarkModeEnabled;

        return isDark
            ? Container(
                height: AppValues.screenHeight,
                decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                child: Center(
                  child: SizedBox(height: AppValues.screenWidth * 0.8, child: AppAssets.splashLogoDarkThemeImg.toAssetImage()),
                ),
              )
            : Container(
                height: AppValues.screenHeight,
                decoration: const BoxDecoration(color: AppColors.white),
                width: double.infinity,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: SizedBox(height: AppValues.screenWidth * 0.9, child: AppAssets.splashLogoLightThemeImg.toAssetImage()),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildBottomInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Unlock Access",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          8.verticalSpace,
          Text(
            "You don't have active subscription, app won't be accessible. Kindly purchase subscription plan from the website https://mashrou3.com",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
