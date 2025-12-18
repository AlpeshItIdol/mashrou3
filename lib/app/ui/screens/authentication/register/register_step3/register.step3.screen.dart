import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:mashrou3/app/ui/screens/authentication/component/otp_widget/bloc/otp_input_section_cubit.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/authentication/register/register_step3/cubit/register_step3_cubit.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_strings.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../db/app_preferences.dart';
import '../../../../../model/verify_response.model.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/common_button.dart';
import '../../../../custom_widget/custom_stepper_widget.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../component/otp_widget/otp_input_section.dart';

class RegisterStep3Screen extends StatefulWidget {
  final String mobileNumber;

  const RegisterStep3Screen({super.key, required this.mobileNumber});

  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen>
    with AppBarMixin {
  @override
  void initState() {
    context.read<RegisterStep3Cubit>().mobileNumberWithCountryCode =
        widget.mobileNumber;
    context.read<RegisterStep3Cubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegisterStep3Cubit cubit = context.read<RegisterStep3Cubit>();
    return BlocConsumer<RegisterStep3Cubit, RegisterStep3State>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            appBar: buildAppBar(
              context: context,
              appBarHeight: 58,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: cubit.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Custom stepper widget
                          ///

                          CustomStepperWidget(
                            currentStep: 2,
                            isSixSteps: cubit.selectedUserRole ==
                                        AppStrings.owner ||
                                    cubit.selectedUserRole == AppStrings.vendor
                                ? true
                                : false,
                          ),
                          24.verticalSpace,
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: appStrings(context).lblOtp ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.colorPrimary,
                                      ),
                                ),
                                const TextSpan(
                                  text: "  ",
                                ),
                                TextSpan(
                                  text:
                                      appStrings(context).lblVerificationCode ??
                                          "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          8.verticalSpace,
                          Text(
                            appStrings(context).textPleaseEnterOTP ?? "",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                          12.verticalSpace,

                          /// OTP  widget
                          ///

                          OTPInput(formKey: cubit.formKey),

                          20.verticalSpace,

                          /// Button widget
                          ///

                          CommonButton(
                            onTap: () {
                              cubit.verifyOTP(context);
                            },
                            title: appStrings(context).btnVerify ?? "",
                          ),
                          12.verticalSpace,
                          BlocBuilder<OtpInputSectionCubit,
                              OtpInputSectionState>(builder: (context, state) {
                            return CommonButton(
                              onTap: context
                                              .read<OtpInputSectionCubit>()
                                              .start
                                              .toString() ==
                                          "0" &&
                                      !context
                                          .read<OtpInputSectionCubit>()
                                          .isAlreadyExist
                                  ? () {
                                      cubit.resendOtp();
                                    }
                                  : () {},
                              isGradientColor: false,
                              isBorderRequired: true,
                              buttonBgColor: Theme.of(context).canvasColor,
                              borderColor: context
                                          .read<OtpInputSectionCubit>()
                                          .start
                                          .toString() ==
                                      "0"
                                  ? Theme.of(context).primaryColor
                                  : AppColors.grey88,
                              buttonTextColor: context
                                          .read<OtpInputSectionCubit>()
                                          .start
                                          .toString() ==
                                      "0"
                                  ? Theme.of(context).primaryColor
                                  : AppColors.grey88,
                              title: appStrings(context).btnResend ?? "",
                            );
                          }),
                          12.verticalSpace,
                          Center(
                              child: Text(
                                appStrings(context).otpValidateInfo,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor),
                              )),
                          12.verticalSpace,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, RegisterStep3State state) async {
    if (state is RegisterStep3Loading) {
      OverlayLoadingProgress.start(context);
    } else if (state is RegisterStep3Success) {
      OverlayLoadingProgress.stop();
      final registerCubit = context.read<RegisterStep3Cubit>();
      final verifyResponseData =
          state.model.verifyResponseData ?? VerifyResponseData();
      final user = verifyResponseData.users;
      final appPreferences = GetIt.I<AppPreferences>();

      // Function to set common user data in app preferences
      Future<void> setCommonUserData() async {
        await appPreferences.saveApiToken(value: verifyResponseData.token);
        await appPreferences.setUserDetails(verifyResponseData);
        await appPreferences.setUserRole(user?.userType ?? "");
        await appPreferences.saveUserID(value: user?.sId);
        await appPreferences.saveSelectedCountryID(value: user?.country);
        await appPreferences.isGuestUser(value: false);
        await appPreferences.isLoggedIn(value: false);
        await appPreferences.isVerified(value: false);
        await appPreferences.isProfileCompleted(value: false);
        await appPreferences.isActive(value: false);

      }

      // Function to navigate based on user status and profile completion
      Future<void> navigateBasedOnUserStatus() async {
        if (user?.isVerified == true) {
          await appPreferences.isVerified(value: true);

          if (user?.userType == AppStrings.visitor) {
            await appPreferences.isLoggedIn(value: true);
            context.goNamed(Routes.kDashboard);
            return;
          }

          if (user?.profileComplete == true) {
            await appPreferences.isProfileCompleted(value: true);
            if (user?.isActive == true) {
              await appPreferences.isActive(value: true);
              await appPreferences.isLoggedIn(value: true);
              context.goNamed(Routes.kDashboard);
            } else {
              context.goNamed(Routes.kUndergoingVerificationScreen);
            }
          } else {
            context.goNamed(Routes.kCompleteProfileScreen);
          }
        } else {
          context.goNamed(Routes.kLoginScreen);
        }
      }

      if (registerCubit.selectedUserRole == AppStrings.owner ||
          registerCubit.selectedUserRole == AppStrings.vendor) {
        if (user != null) {
          await setCommonUserData();
          await navigateBasedOnUserStatus();
        }
      } else if (registerCubit.selectedUserRole == AppStrings.visitor) {
        if (user != null) {
          await setCommonUserData();
          if (user.isVerified == true) {
            await appPreferences.isVerified(value: true);
            await appPreferences.isLoggedIn(value: true);
            await appPreferences.isGuestUser(value: false);
            context.goNamed(Routes.kDashboard);
          }
        }
      }

      // OverlayLoadingProgress.stop();
      // final registerCubit = context.read<RegisterStep3Cubit>();
      // final verifyResponseData = state.model.verifyResponseData;
      // final user = verifyResponseData?.users;
      // final appPreferences = GetIt.I<AppPreferences>();
      //
      // if (registerCubit.selectedUserRole == AppStrings.owner ||
      //     registerCubit.selectedUserRole == AppStrings.vendor) {
      //   // Set the API token for the user
      //   await appPreferences.saveApiToken(value: verifyResponseData?.token);
      //
      //   if (verifyResponseData != null && user != null) {
      //     // Set user details and role type
      //     await appPreferences.setUserDetails(verifyResponseData);
      //     await appPreferences.setUserRole(user.userType ?? "");
      //     await appPreferences.saveUserID(value: user.sId);
      //     await appPreferences.saveSelectedCountryID(value: user.country);
      //
      //     // Check if the user is verified
      //     if (user.isVerified == true) {
      //       // Set verification status
      //       await appPreferences.isVerified(value: true);
      //
      //       if (user.userType.toString() == AppStrings.visitor) {
      //         await appPreferences.isLoggedIn(value: true);
      //
      //         // Navigate to the dashboard
      //         context.goNamed(Routes.kDashboard);
      //       } else {
      //         if (user.profileComplete == true) {
      //           // Set profile completion and login status
      //           await appPreferences.isProfileCompleted(value: true);
      //
      //           if (user.isActive == true) {
      //             await appPreferences.isActive(value: true);
      //             await appPreferences.isLoggedIn(value: true);
      //
      //             // Navigate to the dashboard
      //             context.goNamed(Routes.kDashboard);
      //           } else {
      //             context.goNamed(Routes.kUndergoingVerificationScreen);
      //           }
      //         } else {
      //           // Navigate to the complete profile screen
      //           context.goNamed(Routes.kCompleteProfileScreen);
      //         }
      //       }
      //     } else {
      //       // Navigate to the UndergoingVerification screen
      //       context.goNamed(Routes.kLoginScreen);
      //     }
      //   }
      // } else if (registerCubit.selectedUserRole == AppStrings.visitor) {
      //   // Set the API token for the user
      //   await appPreferences.saveApiToken(value: verifyResponseData?.token);
      //   if (verifyResponseData != null && user != null) {
      //     // Set user details and role type
      //     await appPreferences.setUserDetails(verifyResponseData);
      //     await appPreferences.setUserRole(user.userType ?? "");
      //     await appPreferences.saveUserID(value: user.sId);
      //     await appPreferences.saveSelectedCountryID(value: user.country);
      //     // Check if the user is verified
      //     if (user.isVerified == true) {
      //       // Set verification status
      //       await appPreferences.isVerified(value: true);
      //       await appPreferences.isLoggedIn(value: true);
      //       // Navigate directly to the dashboard for other user roles
      //       context.pushNamed(Routes.kDashboard);
      //     }
      //   }
      // }
    } else if (state is ResendOtpSuccess) {
      OverlayLoadingProgress.stop();
      context.read<RegisterStep3Cubit>().timerReset(context);
      /*Utils.snackBar(
        context: context,
        message:
            "${state.resendOtpResponse.message} - ${state.resendOtpResponse.data}",
      );*/
    } else if (state is RegisterStep3Error) {
      OverlayLoadingProgress.stop();
      if (state.errorMessage.toLowerCase().contains("exist")) {
        context.read<OtpInputSectionCubit>().isAlreadyExist = true;
      }
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
