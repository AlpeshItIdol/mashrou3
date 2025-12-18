import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/country_selection_cubit.dart';

import 'package:mashrou3/app/ui/screens/authentication/component/country_selection_widget.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';

import '../../../../../../config/resources/app_constants.dart';
import '../../../../../../config/resources/app_strings.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../db/app_preferences.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/common_button.dart';
import '../../../../custom_widget/custom_stepper_widget.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import 'cubit/register_step2_cubit.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen>
    with AppBarMixin {
  @override
  void initState() {
    context.read<RegisterStep2Cubit>().mobileNumberCtl.clear();
    context.read<RegisterStep2Cubit>().selectedCountry =
        AppConstants.defaultCountry;
    context.read<CountrySelectionCubit>().countryFlag =
        AppConstants.defaultCountryFlag;
    context.read<CountrySelectionCubit>().countryCode =
        AppConstants.defaultCountryCode;
    context.read<CountrySelectionCubit>().countryName =
        AppConstants.defaultCountryName;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    context.read<RegisterStep2Cubit>().getData(context);
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RegisterStep2Cubit cubit = context.read<RegisterStep2Cubit>();
    return BlocConsumer<RegisterStep2Cubit, RegisterStep2State>(
      listener: buildBlocListener,
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(context: context, appBarHeight: 58),
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
                          currentStep: 1,
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
                                text: appStrings(context).lblWelcome,
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
                                text: appStrings(context).lblAboard,
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
                          cubit.selectedUserRole == AppStrings.owner
                              ? appStrings(context)
                                  .textSetUpYourRealEstateOwnerAccount
                              : cubit.selectedUserRole == AppStrings.vendor
                                  ? appStrings(context)
                                      .textSetUpYourVendorAccount
                                  : cubit.selectedUserRole == AppStrings.visitor
                                      ? appStrings(context)
                                          .textSetUpYourVisitorAccount
                                      : appStrings(context)
                                          .textSetUpYourAccount,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                        12.verticalSpace,

                        /// Country selection widget
                        ///

                        /// Country selection widget integration
                        BlocListener<CountrySelectionCubit,
                                CountrySelectionState>(
                            listener: (context, state) {
                              if (state is CountrySelectionUpdated) {
                                cubit.countryCode =
                                    state.country.phoneCode ?? "+962";
                                cubit.countryCodeStr =
                                    state.country.countryCode ?? "";
                                printf("Code - ${state.country.phoneCode}");
                                setState(() {});
                              }
                            },
                            child: const CountrySelectionWidget()),

                        12.verticalSpace,

                        /// Mobile number field
                        ///

                        BlocBuilder<RegisterStep2Cubit, RegisterStep2State>(
                            builder: (context, state) => MyTextFormField(
                                  controller: cubit.mobileNumberCtl,
                                  focusNode: cubit.mobileNumberFn,
                                  fieldName:
                                      appStrings(context).lblMobileNumber,
                                  isShowPrefixText: true,
                                  prefixText: cubit.countryCode,
                                  isMandatory: true,
                                  isShowFieldName: true,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    InputFormatters()
                                        .numberInputFormatterWithoutDot,
                                    PhoneNumberInputFormatter.getFormatter(
                                        cubit.countryCodeStr),
                                    // LengthLimitingTextInputFormatter(15),
                                  ],
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  readOnly: false,
                                  obscureText: false,
                                  validator: (value) {
                                    return validatePhoneNumber(
                                        showErrorForEmpty: true,
                                        context,
                                        value,
                                        cubit.countryCodeStr);
                                  },
                                )),
                        28.verticalSpace,

                        /// Button widget
                        ///

                        CommonButton(
                          onTap: () async {
                            if (cubit.formKey.currentState!.validate()) {
                              await cubit.sendVerificationCode(context);
                            }
                          },
                          title: appStrings(context).btnSendVerificationCode,
                        ),
                        12.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Helper method to reset the state of RegisterStep2Cubit
  void _resetRegisterStep2State(BuildContext context) {
    final registerStep2Cubit = context.read<RegisterStep2Cubit>();
    final countrySelectionCubit = context.read<CountrySelectionCubit>();

    // Clear the mobile number controller
    registerStep2Cubit.mobileNumberCtl.clear();

    // Reset selected country
    registerStep2Cubit.selectedCountry = AppConstants.defaultCountry;
    countrySelectionCubit.resetToDefault();
    countrySelectionCubit
        .selectedCountryStateUpdate(AppConstants.defaultCountry);

    // Unfocus any active field
    registerStep2Cubit.mobileNumberFn.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    // Explicitly reset the form validation state
    registerStep2Cubit.formKey.currentState?.reset();
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, RegisterStep2State state) async {
    if (state is RegisterStep2Loading) {
      OverlayLoadingProgress.start(context);
    } else if (state is RegisterStep2Initial) {
      OverlayLoadingProgress.stop();
    } else if (state is ClearValueStateInit) {
      OverlayLoadingProgress.stop();
    } else if (state is ClearValueState) {
      OverlayLoadingProgress.stop();
      context.read<RegisterStep2Cubit>().mobileNumberCtl.clear();
      context.read<RegisterStep2Cubit>().selectedCountry =
          AppConstants.defaultCountry;
      context.read<CountrySelectionCubit>().countryFlag =
          AppConstants.defaultCountryFlag;
      context.read<CountrySelectionCubit>().countryCode =
          AppConstants.defaultCountryCode;
      context.read<CountrySelectionCubit>().countryName =
          AppConstants.defaultCountryName;
      context.read<RegisterStep2Cubit>().mobileNumberCtl.clear();
      context.read<RegisterStep2Cubit>().selectedCountry =
          AppConstants.defaultCountry;
      FocusManager.instance.primaryFocus?.unfocus();
      // Explicitly reset the form validation state
      if (context.read<RegisterStep2Cubit>().formKey.currentState != null) {
        context
            .read<RegisterStep2Cubit>()
            .formKey
            .currentState
            ?.reset(); // Reset the form validation state
      }
    } else if (state is APISuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is RegisterStep2Success) {
      OverlayLoadingProgress.stop();
      /*Utils.snackBar(
        context: context,
        message: "OTP - ${state.model.data?.users?.otp}",
      );*/

      if (state.model.data?.users?.profileComplete == true) {
        await GetIt.I<AppPreferences>().isProfileCompleted(value: true);
        context.goNamed(
          Routes.kDashboard,
        );
      } else {
        context.read<RegisterStep2Cubit>().mobileNumberCtl.clear();
        context.read<RegisterStep2Cubit>().mobileNumberFn.unfocus();
        FocusManager.instance.primaryFocus?.unfocus();

        printf(
            'Controller text after clear: ${context.read<RegisterStep2Cubit>().mobileNumberCtl.text}');

        context
            .pushNamed(
          Routes.kRegisterStep3Screen,
          extra: context.read<RegisterStep2Cubit>().mobileNumberWithCountryCode,
        )
            .then((value) {
          // Explicitly reset the form validation state
          if (context.read<RegisterStep2Cubit>().formKey.currentState != null) {
            context
                .read<RegisterStep2Cubit>()
                .formKey
                .currentState
                ?.reset(); // Reset the form validation state
          }
          // context.read<RegisterStep2Cubit>().mobileNumberCtl.clear();
          context.read<RegisterStep2Cubit>().selectedCountry =
              AppConstants.defaultCountry;
          context.read<CountrySelectionCubit>().resetToDefault();
          context
              .read<CountrySelectionCubit>()
              .selectedCountryStateUpdate(AppConstants.defaultCountry);

          context.read<RegisterStep2Cubit>().selectedCountry =
              AppConstants.defaultCountry;
        });
      }
    } else if (state is RegisterStep2Error) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
      if (state.errorMessage.toLowerCase().contains("exist")) {}
    }
  }
}
