import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/otp_widget/bloc/otp_input_section_cubit.dart';
import 'package:mashrou3/app/ui/screens/authentication/otp_verification/cubit/otp_verification_cubit.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../config/resources/app_assets.dart';
import '../../../../../config/resources/app_values.dart';
import '../../../../../utils/ui_components.dart';
import '../../../../db/app_preferences.dart';
import '../../../../navigation/routes.dart';
import '../../../custom_widget/common_button.dart';
import '../../../custom_widget/loader/overlay_loading_progress.dart';
import '../component/otp_widget/otp_input_section.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpVerificationScreen({super.key, required this.mobileNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with AppBarMixin {
  @override
  void initState() {
    context.read<OtpVerificationCubit>().mobileNumberWithCountryCode =
        widget.mobileNumber;
    context.read<OtpVerificationCubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OtpVerificationCubit cubit = context.read<OtpVerificationCubit>();
    return BlocConsumer<OtpVerificationCubit, OtpVerificationState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(
                                  24), // Curved top-right corner
                            ),
                            child: Image.asset(
                              AppAssets.welcomeImg,
                              fit: BoxFit.cover,
                              height: AppValues.screenHeight / 2.5,
                              width: AppValues.screenWidth,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Custom stepper widget
                            ///

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
                                    text: appStrings(context)
                                            .lblVerificationCode ??
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
                                if (cubit.formKey.currentState!.validate()) {
                                  cubit.verifyOTP(context);
                                }
                              },
                              title: appStrings(context).btnVerify ?? "",
                            ),
                            12.verticalSpace,
                            BlocBuilder<OtpInputSectionCubit,
                                    OtpInputSectionState>(
                                builder: (context, state) {
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
              bottomNavigationBar: UIComponent.customInkWellWidget(
                onTap: () {
                  context.read<OtpInputSectionCubit>().timer?.cancel();
                  context.pop();
                },
                child: SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 16,
                      end: 16,
                      bottom: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          transform:
                              TextDirection.rtl == Directionality.of(context)
                                  ? Matrix4.identity()
                                  : Matrix4.rotationY(math.pi),
                          child: SVGAssets.circleArrowRightRoundIcon.toSvg(
                            context: context,
                          ),
                        ),
                        5.horizontalSpace,
                        Text(
                          appStrings(context).textBack,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, OtpVerificationState state) async {
    if (state is OtpVerificationLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is OtpVerificationSuccess) {
      OverlayLoadingProgress.stop();

      final appPreferences = GetIt.I<AppPreferences>();
      final verifyResponseData = state.model.verifyResponseData;
      final user = verifyResponseData?.users;
      OtpVerificationCubit cubit = context.read<OtpVerificationCubit>();

      await appPreferences.isGuestUser(value: false);

      if (verifyResponseData != null && user != null) {
        // Set API token for user
        await appPreferences.saveApiToken(value: verifyResponseData.token);
        await appPreferences.saveUserID(value: user.sId);
        await appPreferences.saveSelectedCountryID(value: user.country);
        await appPreferences
            .setSupportDetails(verifyResponseData.support ?? Support());

        // Set user details and role type
        await appPreferences.setUserDetails(verifyResponseData);
        await appPreferences.setUserRole(user.userType ?? "");

        if (user.isVerified == true) {
          // Set isVerified for user
          await appPreferences.isVerified(value: true);

          if (user.userType.toString() == AppStrings.visitor) {
            await appPreferences.isLoggedIn(value: true);

            // Navigate to the dashboard
            context.goNamed(Routes.kDashboard);
          } else {
            if (user.profileComplete == true) {
              // Set profile completion and login status
              await appPreferences.isProfileCompleted(value: true);

              if (user.isActive == true) {
                await appPreferences.isActive(value: true);
                await appPreferences.isLoggedIn(value: true);

                var isSubscriptionEnableByAdmin = await GetIt.I<AppPreferences>().getSubscriptionRequired();

                var isSubscriptionActive = await GetIt.I<AppPreferences>().isSubscriptionEnable();

                print("isSubscriptionEnableByAdmin $isSubscriptionEnableByAdmin");
                print("isSubscriptionActive $isSubscriptionActive");
                if (isSubscriptionEnableByAdmin && !isSubscriptionActive) {
                  if (!context.mounted) return;
                  context.goNamed(Routes.kSubscriptionInformation);
                  return;
                }


                if (user.userType.toString() == AppStrings.vendor) {
                  context.goNamed(Routes.kDashboard);
                } else {
                  // Navigate to the dashboard
                  context.goNamed(Routes.kOwnerDashboard);
                }
              } else {
                context.goNamed(Routes.kUndergoingVerificationScreen);
              }
            } else {
              // Navigate to the complete profile screen
              context.goNamed(Routes.kCompleteProfileScreen);
            }
          }
        } else {
          context.goNamed(Routes.kLoginScreen);
        }
      }
    } else if (state is ResendOtpSuccess) {
      OverlayLoadingProgress.stop();
      context.read<OtpVerificationCubit>().timerReset(context);
      /*Utils.snackBar(
        context: context,
        message:
            "${state.resendOtpResponse.message} - ${state.resendOtpResponse.data}",
      );*/
    } else if (state is OtpVerificationError) {
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
