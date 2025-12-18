import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/common_row_bottons.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_values.dart';
import '../../../../../../config/resources/text_styles.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../db/app_preferences.dart';
import '../../../../../model/verify_response.model.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/common_button.dart';
import '../../../../custom_widget/custom_alert_dialog.dart';
import 'cubit/undergoing_verification_cubit.dart';

class UndergoingVerificationScreen extends StatefulWidget {
  const UndergoingVerificationScreen({super.key});

  @override
  State<UndergoingVerificationScreen> createState() =>
      _UndergoingVerificationScreenState();
}

class _UndergoingVerificationScreenState
    extends State<UndergoingVerificationScreen> {
  @override
  void initState() {
    context.read<UndergoingVerificationCubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UndergoingVerificationCubit cubit =
        context.read<UndergoingVerificationCubit>();
    return BlocConsumer<UndergoingVerificationCubit,
            UndergoingVerificationState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: AppValues.screenHeight,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SVGAssets.undergoingVerification.toSvg(context: context),
                      40.verticalSpace,
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 28.0),
                        child: Text(
                          appStrings(context)
                              .textYourAccountIsCurrentlyUndergoingVerification,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ),
                      12.verticalSpace,
                      Text(
                        appStrings(context).textPleaseWaitForApproval,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.black3D.forLightMode(context),
                            ),
                      ),
                      30.verticalSpace,
                      UIComponent.customInkWellWidget(
                        onTap: () async {
                          logoutDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsetsDirectional.all(4),
                          width: AppValues.screenWidth / 3.4,
                          height: 48,
                          decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appStrings(context).btnLogOut,
                                  textAlign: TextAlign.center,
                                  style: h16().copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, UndergoingVerificationState state) async {
    if (state is UndergoingVerificationLoading) {
      // OverlayLoadingProgress.start(context);
    } else if (state is UndergoingVerificationSuccess) {
      await GetIt.I<AppPreferences>().isLoggedIn(value: false);
      await GetIt.I<AppPreferences>().isProfileCompleted(value: false);
      await GetIt.I<AppPreferences>().isGuestUser(value: false);
      await GetIt.I<AppPreferences>().isVerified(value: false);
      await GetIt.I<AppPreferences>().isGuestUser(value: false);
      await GetIt.I<AppPreferences>().setUserDetails(VerifyResponseData());
      await GetIt.I<AppPreferences>().saveUserID(value: "");
      await GetIt.I<AppPreferences>().setUserRole("");
      await GetIt.I<AppPreferences>().saveSelectedCountryID(value: "");
      await Future.delayed(const Duration(milliseconds: 300));
      context.goNamed(
        Routes.kLoginScreen,
      );
    } else if (state is UndergoingVerificationError) {
      await GetIt.I<AppPreferences>().isLoggedIn(value: false);
      await GetIt.I<AppPreferences>().isProfileCompleted(value: false);
      await GetIt.I<AppPreferences>().isGuestUser(value: false);
      await GetIt.I<AppPreferences>().isVerified(value: false);
      await GetIt.I<AppPreferences>().isGuestUser(value: false);
      await GetIt.I<AppPreferences>().setUserDetails(VerifyResponseData());
      await GetIt.I<AppPreferences>().saveUserID(value: "");
      await GetIt.I<AppPreferences>().setUserRole("");
      await GetIt.I<AppPreferences>().saveSelectedCountryID(value: "");
      await Future.delayed(const Duration(milliseconds: 300));
      context.goNamed(
        Routes.kLoginScreen,
      );
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
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
            UIComponent.customRTLIcon(
                child: SVGAssets.logoutIcon.toSvg(context: context),
                context: context),
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
                await context.read<UndergoingVerificationCubit>().logout();
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
}
