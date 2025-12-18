import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/country_selection_widget.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';

import '../../../../../config/resources/app_assets.dart';
import '../../../../../config/resources/app_constants.dart';
import '../../../../../config/resources/app_values.dart';
import '../../../../../config/utils.dart';
import '../../../../../utils/app_localization.dart';
import '../../../../../utils/ui_components.dart';
import '../../../../../utils/validators.dart';
import '../../../../db/app_preferences.dart';
import '../../../../navigation/routes.dart';
import '../../../custom_widget/common_button.dart';
import '../../../custom_widget/loader/overlay_loading_progress.dart';
import '../component/bloc/country_selection_cubit.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    context.read<LoginCubit>().mobileNumberCtl.clear();

    context.read<LoginCubit>().mobileNumberFn.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    if (context.read<LoginCubit>().formKey.currentState != null) {
      context.read<LoginCubit>().formKey.currentState?.reset(); // Reset the form validation state
    }
    context.read<LoginCubit>().getData(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<LoginCubit>().mobileNumberFn.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    if (context.read<LoginCubit>().formKey.currentState != null) {
      context.read<LoginCubit>().formKey.currentState?.reset(); // Reset the form validation state
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = context.read<LoginCubit>();
    return BlocConsumer<LoginCubit, LoginState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Scaffold(
              body: SafeArea(
                top: false,
                child: SingleChildScrollView(
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

                                bottomRight: Radius.circular(24), // Curved top-right corner
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
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: appStrings(context).lblLets,
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                    ),
                                    const TextSpan(
                                      text: "  ",
                                    ),
                                    TextSpan(
                                      text: appStrings(context).lblLogIn,
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.colorPrimary,
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
                                appStrings(context).lblLoginScreenMessage,
                                textAlign: TextAlign.start,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400),
                              ),
                              12.verticalSpace,

                              /// Country selection widget
                              ///

                              BlocListener<CountrySelectionCubit, CountrySelectionState>(
                                  listener: (context, state) {
                                    if (state is CountrySelectionUpdated) {
                                      cubit.countryCode = state.country.phoneCode ?? "+962";
                                      cubit.countryCodeStr = state.country.countryCode ?? "";
                                      printf("Code - ${state.country.phoneCode}");
                                      setState(() {});
                                    }
                                  },
                                  child: const CountrySelectionWidget()),

                              12.verticalSpace,

                              MyTextFormField(
                                controller: cubit.mobileNumberCtl,
                                focusNode: cubit.mobileNumberFn,
                                fieldName: appStrings(context).lblMobileNumber,
                                isShowPrefixText: true,
                                prefixText: cubit.countryCode,
                                isMandatory: true,
                                isShowFieldName: true,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  InputFormatters().numberInputFormatterWithoutDot,
                                  PhoneNumberInputFormatter.getFormatter(cubit.countryCodeStr),
                                  // LengthLimitingTextInputFormatter(15),
                                ],
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).unfocus();
                                },
                                readOnly: false,
                                obscureText: false,
                                validator: (value) {
                                  return validatePhoneNumber(showErrorForEmpty: true, context, value, cubit.countryCodeStr);
                                },
                              ),
                              28.verticalSpace,
                              CommonButton(
                                onTap: () {
                                  if (cubit.formKey.currentState!.validate()) {
                                    cubit.login(context);
                                  }
                                },
                                title: appStrings(context).btnSendVerificationCode,
                              ),
                              18.verticalSpace,
                              Center(
                                child: RichText(
                                  textScaler: TextScaler.linear(MediaQuery.of(context).textScaler.scale(1.0)),
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
                                    children: [
                                      TextSpan(
                                        text: appStrings(context).textDontHaveAccount,
                                      ),
                                      const TextSpan(
                                        text: " ",
                                      ),
                                      TextSpan(
                                        text: appStrings(context).textSignUpNow,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontWeight: FontWeight.w400, color: AppColors.colorPrimary),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.read<LoginCubit>().mobileNumberCtl.clear();
                                            context.read<LoginCubit>().selectedCountry = AppConstants.defaultCountry;
                                            context.read<CountrySelectionCubit>().countryFlag = AppConstants.defaultCountryFlag;
                                            context.read<CountrySelectionCubit>().countryCode = AppConstants.defaultCountryCode;
                                            context.read<CountrySelectionCubit>().countryName = AppConstants.defaultCountryName;
                                            context.read<CountrySelectionCubit>().selectedCountryStateUpdate(AppConstants.defaultCountry);

                                            // Unfocus any input fields
                                            context.read<LoginCubit>().mobileNumberFn.unfocus();
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            context.pushNamed(Routes.kRegisterStep1Screen).then((value) {
                                              context.read<LoginCubit>().countryCode = "+962";
                                              context.read<LoginCubit>().selectedCountry = AppConstants.defaultCountry;
                                              context.read<CountrySelectionCubit>().countryFlag = AppConstants.defaultCountryFlag;
                                              context.read<CountrySelectionCubit>().countryCode = AppConstants.defaultCountryCode;
                                              context.read<CountrySelectionCubit>().countryName = AppConstants.defaultCountryName;
                                              context.read<CountrySelectionCubit>().selectedCountryStateUpdate(AppConstants.defaultCountry);

                                              // Reset the form's validation state
                                              if (cubit.formKey.currentState != null) {
                                                cubit.formKey.currentState?.reset();
                                              }
                                            });
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: UIComponent.customInkWellWidget(
                  onTap: () {
                    // context.goNamed(Routes.kWelcomeScreen);
                  },
                  child: SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 16,
                        end: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UIComponent.customInkWellWidget(
                            onTap: () async {
                              // Unfocus any input fields
                              context.read<LoginCubit>().mobileNumberFn.unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();

                              // Reset the form's validation state
                              if (cubit.formKey.currentState != null) {
                                cubit.formKey.currentState?.reset();
                              }

                              final appPreferences = GetIt.I<AppPreferences>();
                              await appPreferences.isGuestUser(value: true);
                              await appPreferences.setUserRole(AppStrings.guest);
                              context.goNamed(
                                Routes.kDashboard,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appStrings(context).textSkipLogin,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
                                ),
                                5.horizontalSpace,
                                Transform(
                                  alignment: Alignment.center,
                                  transform:
                                      TextDirection.rtl == Directionality.of(context) ? Matrix4.rotationY(math.pi) : Matrix4.identity(),
                                  child: SVGAssets.circleArrowRightRoundIcon.toSvg(
                                    context: context,
                                    color: Theme.of(context).highlightColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(BuildContext context, LoginState state) async {
    if (state is LoginLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is APISuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is LoginSuccess) {
      OverlayLoadingProgress.stop();
      /*Future.delayed(Duration(milliseconds: 600), () {
        Utils.snackBar(
          context: context,
          message: "OTP - ${state.loginResponse.loginResponseData?.users?.otp}",
        );
      });
*/
      context
          .pushNamed(
        Routes.kOtpVerificationScreen,
        extra: context.read<LoginCubit>().mobileNumberWithCountryCode,
      )
          .then((value) {
        context.read<LoginCubit>().mobileNumberCtl.clear();
        context.read<LoginCubit>().selectedCountry = AppConstants.defaultCountry;
        // Unfocus any input fields
        context.read<LoginCubit>().mobileNumberFn.unfocus();
        FocusManager.instance.primaryFocus?.unfocus();

        // Reset the form's validation state
        if (context.read<LoginCubit>().formKey.currentState != null) {
          context.read<LoginCubit>().formKey.currentState?.reset();
        }
      });
    } else if (state is LoginError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    }
  }
}
