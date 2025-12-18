import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/resources/app_constants.dart';
import '../../../../../../config/resources/app_strings.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../db/app_preferences.dart';
import '../../../../../model/city_list_response_model.dart';
import '../../../../../model/country_list_model.dart';
import '../../../../../model/language_list_response_model.dart';
import '../../../../../model/verify_response.model.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/bottom_sheet_with_pagination/bottom_sheet_with_pagination.dart';
import '../../../../custom_widget/custom_stepper_widget.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../component/country_bottomsheet_widget/country_bottomsheet_widget.dart';
import '../../component/mobile_number_with_country_widget_for_property.dart';
import 'cubit/complete_profile_cubit.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen>
    with AppBarMixin {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // Explicitly reset the form validation state
    // if (formKey.currentState != null) {
    formKey.currentState?.reset(); // Reset the form validation state
    // }
    context.read<CompleteProfileCubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CompleteProfileCubit cubit = context.read<CompleteProfileCubit>();
    return BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                  context: context, appBarHeight: 18, requireLeading: false),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
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
                              currentStep: 3,
                              isSixSteps:
                                  cubit.selectedUserRole == AppStrings.owner ||
                                          cubit.selectedUserRole ==
                                              AppStrings.vendor
                                      ? true
                                      : false,
                            ),
                            18.verticalSpace,
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: appStrings(context).lblComplete ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                  const TextSpan(
                                    text: "  ",
                                  ),
                                  TextSpan(
                                    text: appStrings(context).lblProfile ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.colorPrimary
                                              .forLightMode(context),
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
                              appStrings(context).textFillYourDetails ?? "",
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                            24.verticalSpace,

                            /// First Name widget
                            ///
                            MyTextFormField(
                              fieldName: appStrings(context).lblFirstName,
                              controller: cubit.firstNameCtl,
                              focusNode: cubit.firstNameFn,
                              isMandatory: true,
                              maxLines: 2,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(cubit.lastNameFn);
                              },
                              readOnly: false,
                              inputFormatters: [
                                InputFormatters().textInputFormatter,
                              ],
                              obscureText: false,
                              validator: (value) {
                                return validateFirstName(context, value);
                              },
                            ),
                            12.verticalSpace,

                            /// Last Name widget
                            ///
                            MyTextFormField(
                              fieldName: appStrings(context).lblLastName,
                              controller: cubit.lastNameCtl,
                              focusNode: cubit.lastNameFn,
                              isMandatory: true,
                              maxLines: 2,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(cubit.emailIdFn);
                              },
                              inputFormatters: [
                                InputFormatters().textInputFormatter,
                              ],
                              readOnly: false,
                              obscureText: false,
                              validator: (value) {
                                return validateLastName(context, value);
                              },
                            ),
                            12.verticalSpace,

                            /// Alternate Mobile Number
                            ///
                            MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.0)),
                              child: Text(
                                  appStrings(context)
                                          .lblAlternateMobileNumber ??
                                      "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black3D
                                              .forLightMode(context))),
                            ),
                            5.verticalSpace,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child:
                                        MobileNumberWithCountryWidgetForProperty(
                                      countryList: cubit.countryList ?? [],
                                      verticalPadding: 12,
                                      initialCountry:
                                          cubit.selectedAltMobileNoCountry,
                                      onCountrySelected:
                                          (CountryListData? country) {
                                        printf(
                                            "Selected Country: ${country?.name}, Flag: ${country?.emoji}");
                                        cubit.selectedAltMobileNoCountry =
                                            country ??
                                                AppConstants.defaultCountry;
                                      },
                                    )

                                    // MobileNumberWithCountryWidget(
                                    //   onCountrySelected:
                                    //       (CountryListData? country) {
                                    //     // Handle the returned country here
                                    //     print(
                                    //         "Selected Country: ${country?.name}, Flag: ${country?.emoji}");
                                    //     // You could also update the state of the parent widget if needed
                                    //     cubit.countryCode =
                                    //         country?.phoneCode ?? "962";
                                    //     cubit.countryCodeStr =
                                    //         country?.countryCode ?? "JO";
                                    //     cubit.selectedCountryForFlag =
                                    //         country ?? CountryListData();
                                    //     setState(() {});
                                    //   },
                                    // )
                                    ),
                                10.horizontalSpace,
                                Expanded(
                                  flex: 9,
                                  child: MyTextFormField(
                                    controller: cubit.mobileNumberCtl,
                                    focusNode: cubit.mobileNumberFn,
                                    fieldName:
                                        appStrings(context).lblMobileNumber ??
                                            "",
                                    isMandatory: true,
                                    isShowPrefixText: true,
                                    prefixText: cubit
                                        .selectedAltMobileNoCountry.phoneCode,
                                    isShowFieldName: false,
                                    maxLines: 2,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      InputFormatters()
                                          .numberInputFormatterWithoutDot,
                                      PhoneNumberInputFormatter.getFormatter(
                                          cubit.selectedAltMobileNoCountry
                                                  .countryCode ??
                                              "JO"),
                                      // LengthLimitingTextInputFormatter(15),
                                    ],
                                    onFieldSubmitted: (v) {
                                      // FocusScope.of(context).requestFocus(widget.addressFn);
                                    },
                                    readOnly: false,
                                    obscureText: false,
                                    validator: (value) {
                                      // return null;
                                      return validatePhoneNumber(
                                          context,
                                          value,
                                          cubit.selectedAltMobileNoCountry
                                                  .countryCode ??
                                              "JO");
                                    },
                                  ),

                                  // MyTextFormField(
                                  //   controller: cubit.mobileNumberCtl,
                                  //   focusNode: cubit.mobileNumberFn,
                                  //   fieldName:
                                  //       appStrings(context).lblMobileNumber ??
                                  //           "",
                                  //   isMandatory: true,
                                  //   isShowFieldName: false,
                                  //   keyboardType: TextInputType.number,
                                  //   textInputAction: TextInputAction.next,
                                  //   inputFormatters: [
                                  //     InputFormatters()
                                  //         .numberInputFormatterWithoutDot,
                                  //     LengthLimitingTextInputFormatter(15),
                                  //   ],
                                  //   onFieldSubmitted: (v) {
                                  //     // FocusScope.of(context).requestFocus(widget.addressFn);
                                  //   },
                                  //   readOnly: false,
                                  //   obscureText: false,
                                  //   isDisable: true,
                                  //   validator: (value) {
                                  //     return validatePhoneNumber(context, value);
                                  //   },
                                  // ),
                                ),
                              ],
                            ),
                            12.verticalSpace,

                            /// Email Id field
                            ///
                            MyTextFormField(
                              fieldName: appStrings(context).lblEmailID,
                              controller: cubit.emailIdCtl,
                              focusNode: cubit.emailIdFn,
                              isMandatory: true,
                              maxLines: 2,
                              // inputFormatters: [InputFormatters().emailInputFormatter],
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (v) {
                                // FocusScope.of(context).requestFocus(cubit.addressFn);
                              },
                              textInputAction: TextInputAction.next,
                              readOnly: false,
                              obscureText: false,
                              validator: (value) {
                                return validateEmail(context, value?.trim());
                              },
                            ),
                            12.verticalSpace,

                            /// City Widget
                            ///
                            MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.0)),
                              child: Text(
                                  "${appStrings(context).lblSelectCity} *",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black3D
                                              .forLightMode(context))),
                            ),
                            5.verticalSpace,
                            InkWell(
                              onTap: cubit.isSelectedCountry == true
                                  ? () async {
                                      final selectedCity =
                                          await showModalBottomSheet<Cities>(
                                        context: context,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          ),
                                        ),
                                        builder: (_) => CityListBottomSheet(
                                          selectedCountryId:
                                              cubit.selectedCountryId,
                                          searchController: cubit.searchCtl,
                                        ),
                                      );

                                      if (selectedCity != null) {
                                        printf(
                                            'Selected City: ${selectedCity.name}');
                                        setState(() {
                                          cubit.selectedCity = selectedCity;
                                          printf("${cubit.selectedCity}");
                                        });
                                        cubit.searchCtl.clear();
                                      }
                                    }
                                  : () {},
                              child: Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: cubit.isSelectedCountry == true
                                      ? AppColors.white.adaptiveColor(context,
                                          lightModeColor: AppColors.white,
                                          darkModeColor: AppColors.black14)
                                      : AppColors.greyF1,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  border: Border.all(
                                      color: cubit.isSelectedCountry == true
                                          ? AppColors.greyE9.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.greyE9,
                                              darkModeColor: AppColors.black2E)
                                          : AppColors.greyF1),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          cubit.selectedCity.name ??
                                              appStrings(context)
                                                  .lblSelectCity ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: cubit.isSelectedCountry ==
                                                          true
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.5),
                                                  fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    SVGAssets.arrowDownIcon.toSvg(
                                        context: context,
                                        color: cubit.isSelectedCountry == true
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5)),
                                  ],
                                ),
                              ),
                            ),
                            12.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar:
                  BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                      builder: (context, state) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UIComponent.bottomSheetWithButtonWithGradient(
                                  context: context,
                                  onTap: () {
                                    onSaveClick(context);
                                  },
                                  buttonTitle: appStrings(context).btnNext),
                              UIComponent.customInkWellWidget(
                                onTap: () async {
                                  // Reset preferences
                                  final prefs = GetIt.I<AppPreferences>();
                                  await prefs.isGuestUser(value: false);
                                  await prefs.isLoggedIn(value: false);
                                  await prefs.isProfileCompleted(value: false);
                                  await prefs.isVerified(value: false);
                                  await prefs
                                      .setUserDetails(VerifyResponseData());
                                  await prefs.saveUserID(value: "");
                                  await prefs.setUserRole("");
                                  await prefs.saveSelectedCountryID(value: "");

                                  if (!context.mounted) return;
                                  context.goNamed(Routes.kLoginScreen);
                                },
                                child: Container(
                                  color: AppColors.white.adaptiveColor(context,
                                      lightModeColor: AppColors.white,
                                      darkModeColor: AppColors.black2E),
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      start: 16,
                                      end: 16,
                                      bottom: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SVGAssets.circleArrowLeftRoundIcon
                                            .toSvg(context: context),
                                        5.horizontalSpace,
                                        Text(
                                          appStrings(context).textBackToLogin,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )));
        });
  }

  /// Build bloc listener widget.
  void buildBlocListener(BuildContext context, CompleteProfileState state) {
    if (state is CompleteProfileLoading) {
      // OverlayLoadingProgress.start(context);
    } else if (state is CompleteProfileSuccess) {
    } else if (state is CompleteProfileError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }

  /// Method validation
  ///
  bool validate(BuildContext context) {
    CompleteProfileCubit cubit = context.read<CompleteProfileCubit>();
    // if (cubit.selectedLanguage.sId == null ||
    //     cubit.selectedLanguage.sId!.isEmpty) {
    //   Utils.showErrorMessage(
    //       context: context, message: appStrings(context).languageEmptyError);
    //   return false;
    // }

    // if (cubit.selectedCountry.sId == null || cubit.selectedCountry.sId!.isEmpty) {
    //   Utils.showErrorMessage(
    //       context: context,
    //       message: appStrings(context).countryCodeEmptyValidationMsg);
    //   return false;
    // }

    if (cubit.selectedCity.sId == null || cubit.selectedCity.sId!.isEmpty) {
      Utils.showErrorMessage(
          context: context, message: appStrings(context).cityEmptyError);
      return false;
    }
    return true;
  }

  /// Country Bottom Sheet.
  ///
  Future<CountryListData?> showCountryBottomSheet(
      BuildContext context, List<CountryListData> countries) {
    final itemCount = countries.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<CountryListData>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(appStrings(context).lblSelectCountry ?? "",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black3D.forLightMode(context))),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
            isSmall
                ? ListView.separated(
                    itemCount: countries.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          // Return the selected country and close the sheet
                          Navigator.pop(context, countries[index]);
                        },
                        child: CountryListItemWidget(
                          country: countries[index],
                          isOnlyTitle: true,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: AppColors.greyE8.adaptiveColor(context,
                              lightModeColor: AppColors.greyE8,
                              darkModeColor: AppColors.grey50),
                        ),
                      );
                    },
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: countries.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Return the selected country and close the sheet
                            Navigator.pop(context, countries[index]);
                          },
                          child: CountryListItemWidget(
                            country: countries[index],
                            isOnlyTitle: true,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 20.0),
                          child: Divider(
                            height: 1,
                            color: AppColors.greyE8.adaptiveColor(context,
                                lightModeColor: AppColors.greyE8,
                                darkModeColor: AppColors.grey50),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }

  /// Language List BottomSheet
  ///
  Future<LanguageListData?> showLanguageBottomSheet(
      BuildContext context, List<LanguageListData> languageListData) {
    final itemCount = languageListData.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<LanguageListData>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(appStrings(context).lblSelectLanguage ?? "",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black3D.forLightMode(context))),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
            isSmall
                ? ListView.separated(
                    itemCount: languageListData.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          // Return the selected country and close the sheet
                          Navigator.pop(context, languageListData[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                languageListData[index].langLongName ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppColors.black14.forLightMode(
                                          context), // Applied specific color based on theme mode
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: AppColors.greyE8.adaptiveColor(context,
                              lightModeColor: AppColors.greyE8,
                              darkModeColor: AppColors.grey50),
                        ),
                      );
                    },
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: languageListData.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Return the selected country and close the sheet
                            Navigator.pop(context, languageListData[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  languageListData[index].langLongName ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.black14.forLightMode(
                                            context), // Applied specific color based on theme mode
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 20.0),
                          child: Divider(
                            height: 1,
                            color: AppColors.greyE8.adaptiveColor(context,
                                lightModeColor: AppColors.greyE8,
                                darkModeColor: AppColors.grey50),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }

  /// City List BottomSheet
  ///
  Future<Cities?> showCityBottomSheet(
      BuildContext context, List<Cities> cities) {
    final itemCount = cities.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<Cities>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(appStrings(context).lblSelectCity ?? "",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black3D.forLightMode(context))),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
            isSmall
                ? ListView.separated(
                    itemCount: cities.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          // Return the selected country and close the sheet
                          Navigator.pop(context, cities[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                cities[index].name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppColors.black14.forLightMode(
                                          context), // Applied specific color based on theme mode
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: AppColors.greyE8.adaptiveColor(context,
                              lightModeColor: AppColors.greyE8,
                              darkModeColor: AppColors.grey50),
                        ),
                      );
                    },
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: cities.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Return the selected country and close the sheet
                            Navigator.pop(context, cities[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  cities[index].name ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.black14.forLightMode(
                                            context), // Applied specific color based on theme mode
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 20.0),
                          child: Divider(
                            height: 1,
                            color: AppColors.greyE8.adaptiveColor(context,
                                lightModeColor: AppColors.greyE8,
                                darkModeColor: AppColors.grey50),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }

  Future<void> onSaveClick(BuildContext context) async {
    if (formKey.currentState!.validate() && validate(context)) {
      context.pushNamed(Routes.kCompleteProfile2Screen);
    }
  }
}
