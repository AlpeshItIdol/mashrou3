import 'package:any_link_preview/any_link_preview.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/model/country_list_model.dart';
import 'package:mashrou3/app/model/property/property_category_response_model.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/common_button_with_icon.dart';
import 'package:mashrou3/app/ui/custom_widget/common_row_bottons.dart';
import 'package:mashrou3/app/ui/custom_widget/custom_stepper_widget.dart';
import 'package:mashrou3/app/ui/custom_widget/file_picker_widget/cubit/file_picker_cubit.dart';
import 'package:mashrou3/app/ui/custom_widget/file_picker_widget/file_picker_widget.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/cubit/add_edit_property_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/model/sub_category_response_model.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/country_selection_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:mashrou3/utils/validators.dart';

import '../../../../config/utils.dart';
import '../../../../utils/app_localization.dart';
import '../../../../utils/input_formatters.dart';
import '../../../model/property/currency_list_response_model.dart';
import '../../../navigation/app_router.dart';
import '../../screens/app_prefereces/cubit/app_preferences_cubit.dart';
import '../../screens/authentication/component/mobile_number_with_country_widget_for_property.dart';
import 'component/country_bottomsheet_widget.dart';

class AddEditPropertyScreen1 extends StatefulWidget {
  const AddEditPropertyScreen1({
    super.key,
    required this.sId,
    required this.isForInReview,
  });

  final String sId;
  final bool isForInReview;

  @override
  State<AddEditPropertyScreen1> createState() => _AddEditPropertyScreen1State();
}

class _AddEditPropertyScreen1State extends State<AddEditPropertyScreen1> with AppBarMixin {
  List<String> underConstruction = [];
  final formKeyStep1 = GlobalKey<FormState>();
  bool isRedirecting = false;

  @override
  void initState() {
    super.initState();
    printf("sID ==========${widget.sId}");
    printf("Review ==========${widget.isForInReview}");
    context.read<AddEditPropertyCubit>().getData(context, widget.sId, widget.isForInReview);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEditPropertyCubit, AddEditPropertyState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(
            context: context,
            requireLeading: true,
            onBackTap: () {
              UIComponent.showCustomBottomSheet(
                  context: context,
                  builder: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SVGAssets.alertIcon.toSvg(context: context),
                      12.verticalSpace,
                      Text(
                        appStrings(context).wantToGoBackQuit,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      8.verticalSpace,
                      Text(
                        appStrings(context).cancelPropertyInfo,
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      14.verticalSpace,
                      ButtonRow(
                        leftButtonText: appStrings(context).cancel,
                        rightButtonText: appStrings(context).yes,
                        onLeftButtonTap: () {
                          context.pop();
                        },
                        onRightButtonTap: () {
                          context.read<AddEditPropertyCubit>().clearScreen1Controllers();
                          context.goNamed(Routes.kOwnerDashboard);
                        },
                        rightButtonBorderColor: AppColors.colorPrimary,
                        rightButtonBgColor: Theme.of(context).canvasColor,
                        leftButtonBgColor: Theme.of(context).cardColor,
                        leftButtonBorderColor: Theme.of(context).primaryColor,
                        leftButtonTextColor: Theme.of(context).primaryColor,
                        rightButtonTextColor: AppColors.colorPrimary,
                        isLeftButtonGradient: false,
                        isRightButtonGradient: false,
                        isLeftButtonBorderRequired: true,
                        isRightButtonBorderRequired: true,
                      ),
                    ],
                  ));
            },
            title: widget.sId != "0" && widget.sId != "" ? appStrings(context).editProperty : appStrings(context).addProperty,
          ),
          bottomNavigationBar: SafeArea(
            child: ButtonRow(
              leftButtonText: appStrings(context).cancel,
              rightButtonText: appStrings(context).next,
              onLeftButtonTap: () {
                // Handle cancel action
                UIComponent.showCustomBottomSheet(
                    context: context,
                    builder: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SVGAssets.alertIcon.toSvg(context: context),
                        12.verticalSpace,
                        Text(
                          appStrings(context).wantToCancel,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        8.verticalSpace,
                        Text(
                          appStrings(context).cancelPropertyInfo,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        14.verticalSpace,
                        ButtonRow(
                          leftButtonText: appStrings(context).cancel,
                          rightButtonText: appStrings(context).yes,
                          onLeftButtonTap: () {
                            context.pop();
                          },
                          onRightButtonTap: () {
                            if (!isRedirecting) {
                              isRedirecting = true;
                              Future.delayed(Duration(milliseconds: 200), () {
                                context.read<AddEditPropertyCubit>().clearScreen1Controllers();
                                context.goNamed(Routes.kOwnerDashboard);
                                isRedirecting = false;
                              });
                            }
                          },
                          rightButtonBorderColor: AppColors.colorPrimary,
                          rightButtonBgColor: Theme.of(context).canvasColor,
                          leftButtonBgColor: Theme.of(context).cardColor,
                          leftButtonBorderColor: Theme.of(context).primaryColor,
                          leftButtonTextColor: Theme.of(context).primaryColor,
                          rightButtonTextColor: AppColors.colorPrimary,
                          isLeftButtonGradient: false,
                          isRightButtonGradient: false,
                          isLeftButtonBorderRequired: true,
                          isRightButtonBorderRequired: true,
                        ),
                      ],
                    ));
              },
              onRightButtonTap: () async {
                if (!context.mounted) return;
                final cubit = context.read<AddEditPropertyCubit>();
                
                // Remove empty video links before validation and navigation
                cubit.removeEmptyVideoLinks();
                
                if (formKeyStep1.currentState!.validate() &&
                    cubit.selectedPropertyCategory.sId != null &&
                    cubit.selectedPropertySubCategory.sId != null) {
                  if (!isRedirecting) {
                    isRedirecting = true;
                    Future.delayed(const Duration(milliseconds: 200), () {
                      final routes = AppRouter.getAllRoutes();
                      bool alreadyOpen =
                          routes.toList().firstWhereOrNull((element) => element == RoutePaths.kAddEditPropertyScreen2Path) != null;
                      if (!alreadyOpen) {
                        context.pushNamed(Routes.kAddEditPropertyScreen2);
                      }
                      isRedirecting = false;
                    });
                  }
                } else {
                  if (!isRedirecting) {
                    isRedirecting = true;
                    cubit.validateStep1(context);
                    isRedirecting = false;
                  }
                }
              },
              leftButtonBgColor: Theme.of(context).cardColor,
              leftButtonBorderColor: Theme.of(context).primaryColor,
              leftButtonTextColor: Theme.of(context).primaryColor,
              isLeftButtonGradient: false,
              isLeftButtonBorderRequired: true,
            ),
          ),
          body: SingleChildScrollView(
            child: _buildBlocConsumer,
          ),
        );
      },
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<AddEditPropertyCubit, AddEditPropertyState>(
      listener: buildBlocListener,
      builder: (context, state) {
        AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();
        final appPreferencesCubit = context.watch<AppPreferencesCubit>();
        return SingleChildScrollView(
          child: Form(
            key: formKeyStep1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  const CustomStepperWidget(
                    currentStep: 1,
                    isSixSteps: false,
                    isThreeSteps: true,
                  ),
                  16.verticalSpace,
                  Text(
                    appStrings(context).generalInformation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  22.verticalSpace,

                  /// Property category
                  UIComponent.mandatoryLabel(context: context, label: appStrings(context).propertyCategory),
                  5.verticalSpace,
                  InkWell(
                    onTap: () async {
                      final category = await showPropertyCategorySheet(context, cubit.propertyCategoryList ?? []);

                      if (category != null) {
                        setState(() {
                          if (cubit.selectedPropertyCategory != category) {
                            cubit.selectedPropertySubCategory = PropertySubCategoryData();
                          }
                          cubit.selectedPropertyCategory = category;

                          cubit.isCategorySelected = true;

                          printf("${cubit.selectedPropertyCategory}");
                        });

                        cubit.categoryOptions.clear();
                        OverlayLoadingProgress.start(context);
                        await cubit.getPropertySubCategoryList(catId: category.sId ?? "0");
                        await cubit.getPropertyCategoryData(context);
                        OverlayLoadingProgress.stop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                            color: AppColors.greyE8
                                .adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.black2E)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                cubit.selectedPropertyCategory.name ?? appStrings(context).selectPropertyCategory,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: cubit.selectedPropertyCategory.name != null
                                        ? Theme.of(context).primaryColor
                                        : AppColors.black14
                                            .adaptiveColor(context, lightModeColor: AppColors.black14, darkModeColor: AppColors.grey77),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SVGAssets.arrowDownIcon.toSvg(context: context, color: Theme.of(context).highlightColor),
                        ],
                      ),
                    ),
                  ),
                  18.verticalSpace,

                  /// Property sub-category
                  UIComponent.mandatoryLabel(context: context, label: appStrings(context).propertySubCategory),
                  5.verticalSpace,
                  BlocListener<AddEditPropertyCubit, AddEditPropertyState>(
                    listener: (context, state) {
                      if (state is AddEditPropertySubCategorySuccess) {
                        // cubit.propertySubCategoryList?.clear();
                        // cubit.propertySubCategoryList?.addAll(state.dataList ?? []);
                      }
                    },
                    child: InkWell(
                      onTap: cubit.isCategorySelected == true
                          ? () async {
                              final subCategory = await showPropertySubCategorySheet(context, cubit.propertySubCategoryList ?? []);

                              if (subCategory != null) {
                                setState(() {
                                  cubit.selectedPropertySubCategory = subCategory;
                                  printf("${cubit.selectedPropertySubCategory}");
                                });
                                cubit.searchCtl.clear();
                              }
                            }
                          : () {},
                      child: Container(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: cubit.isCategorySelected == true
                              ? AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black14)
                              : AppColors.greyF1.adaptiveColor(context, lightModeColor: AppColors.greyF1, darkModeColor: AppColors.black48),
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                              color: cubit.isCategorySelected == true
                                  ? AppColors.greyE9
                                      .adaptiveColor(context, lightModeColor: AppColors.greyE9, darkModeColor: AppColors.black2E)
                                  : AppColors.greyF1
                                      .adaptiveColor(context, lightModeColor: AppColors.greyF1, darkModeColor: AppColors.black2E)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  cubit.selectedPropertySubCategory.name ?? appStrings(context).selectSubPropertyCategory,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: cubit.isCategorySelected == true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).primaryColor.withOpacity(0.5),
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SVGAssets.arrowDownIcon.toSvg(
                                context: context,
                                color: cubit.isCategorySelected == true
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColor.withOpacity(0.5)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  18.verticalSpace,

                  /// Property title
                  MyTextFormField(
                    controller: cubit.propertyTitleCtl,
                    focusNode: cubit.propertyTitleFn,
                    fieldName: appStrings(context).propertyTitle,
                    isMandatory: true,
                    maxLines: 2,
                    fieldHint: appStrings(context).propertyTitlePlaceholder,
                    isShowFieldName: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      InputFormatters().propertyTitleArabicRegexInputFormatter,
                    ],
                    onFieldSubmitted: (v) {},
                    validator: (value) {
                      return validatePropertyTitle(context, value);
                    },
                  ),
                  18.verticalSpace,

                  /// Property Price
                  ///
                  UIComponent.addFieldLabel(context: context, label: appStrings(context).propertyPrice),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              5.verticalSpace,
                              InkWell(
                                onTap: () async {
                                  final currency = await showCurrencyBottomSheet(context: context, currency: cubit.currencyList ?? []);

                                  if (currency != null) {
                                    setState(() {
                                      cubit.selectedCurrency = currency;
                                      printf("${cubit.selectedCurrency.currencyName} - ${cubit.selectedCurrency.currencySymbol}");
                                      // widget.onCountrySelected(currency);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                                    border: Border.all(
                                        color: AppColors.greyE8
                                            .adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.black2E)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        child: Text(
                                          cubit.selectedCurrency.currencySymbol ?? 'د.أ',
                                          // Display selected flag emoji
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: AppColors.black14.adaptiveColor(
                                                context,
                                                lightModeColor: AppColors.black14,
                                                darkModeColor: AppColors.white,
                                              )),
                                        ),
                                      ),
                                      SVGAssets.arrowDownIcon.toSvg(context: context, color: Theme.of(context).focusColor),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )

                          // MyTextFormField(
                          //   controller: cubit.currencyCtl,
                          //   isMandatory: true,
                          //   keyboardType: TextInputType.text,
                          //   isShowFieldName: false,
                          //   fieldName: appStrings(context).propertyPrice,
                          //   textInputAction: TextInputAction.next,
                          //   suffixIcon:
                          //       SVGAssets.arrowDownIcon.toSvg(context: context),
                          //   onFieldSubmitted: (v) {
                          //     FocusScope.of(context)
                          //         .requestFocus(cubit.propertyPriceFn);
                          //   },
                          //   readOnly: true,
                          //   validator: (String? value) {
                          //     return validateCurrency(context, value);
                          //   },
                          //   onTap: () async {
                          //     OverlayLoadingProgress.start(context);
                          //
                          //     await cubit.getCurrencyList();
                          //     OverlayLoadingProgress.stop();
                          //
                          //     final currency = await showCurrencyBottomSheet(
                          //         context: context,
                          //         currency: cubit.currencyList ?? []);
                          //
                          //     if (currency != null) {
                          //       setState(() {
                          //         cubit.selectedCurrency = currency;
                          //         printf(
                          //             "${cubit.selectedCurrency.currencyName} - ${cubit.selectedCurrency.currencySymbol}");
                          //         // widget.onCountrySelected(currency);
                          //       });
                          //     }
                          //   },
                          //   obscureText: false,
                          // ),
                          ),
                      10.horizontalSpace,
                      Expanded(
                        flex: 9,
                        child: MyTextFormField(
                          controller: cubit.propertyPriceCtl,
                          focusNode: cubit.propertyPriceFn,
                          // fieldName: appStrings(context).propertyPrice,
                          isMandatory: false,
                          fieldHint: appStrings(context).pricePlaceholder,
                          isShowFieldName: false,
                          isShowFieldMetric: true,
                          fieldMetricValue: 'د.أ',
                          keyboardType: const TextInputType.numberWithOptions(),
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            InputFormatters().emojiRestrictInputFormatter,
                            InputFormatters().numberInputFormatterWithoutDot,
                          ],
                          onFieldSubmitted: (v) {},
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  18.verticalSpace,

                  /// Mobile Number
                  ///
                  UIComponent.mandatoryLabel(context: context, label: appStrings(context).lblMobileNumber),
                  5.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: BlocListener<CountrySelectionCubit, CountrySelectionState>(
                              listener: (context, state) {},
                              child: MobileNumberWithCountryWidgetForProperty(
                                countryList: cubit.countryList ?? [],
                                initialCountry: cubit.selectedMobileNoCountry,
                                onCountrySelected: (CountryListData? country) {
                                  printf("Selected Country: ${country?.name}, Flag: ${country?.emoji}");
                                  cubit.updateSelectedMobileCountry(
                                    country ?? AppConstants.defaultCountry,
                                  );

                                },
                              ))),
                      10.horizontalSpace,
                      Expanded(
                        flex: 9,
                        child: BlocListener<AddEditPropertyCubit, AddEditPropertyState>(
                          listener: (context, state) {},
                          child: MyTextFormField(
                            controller: cubit.mobileNumberCtl,
                            focusNode: cubit.mobileNumberFn,
                            fieldName: appStrings(context).lblMobileNumber,
                            isMandatory: true,
                            isShowPrefixText: true,
                            prefixText: cubit.selectedMobileNoCountry.phoneCode,
                            fieldHint: appStrings(context).mobileNumberPlaceholder,
                            isShowFieldName: false,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              InputFormatters().numberInputFormatterWithoutDot,
                              PhoneNumberInputFormatter.getFormatter(cubit.selectedMobileNoCountry.countryCode ?? "JO"),
                              // LengthLimitingTextInputFormatter(15),
                            ],
                            onFieldSubmitted: (v) {
                              // FocusScope.of(context).requestFocus(widget.addressFn);
                            },
                            isDisable: false,
                            validator: (value) {
                              return validatePhoneNumber(
                                  showErrorForEmpty: true, context, value, cubit.selectedMobileNoCountry.countryCode ?? "");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  18.verticalSpace,

                  /// Alternate Mobile Number
                  ///
                  UIComponent.addFieldLabel(context: context, label: appStrings(context).lblAlternateMobileNumber),
                  5.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: BlocListener<CountrySelectionCubit, CountrySelectionState>(
                              listener: (context, state) {},
                              child: MobileNumberWithCountryWidgetForProperty(
                                countryList: cubit.countryList ?? [],
                                initialCountry: cubit.selectedAltMobileNoCountry,
                                onCountrySelected: (CountryListData? country) {
                                  printf("Selected Country: ${country?.name}, Flag: ${country?.emoji}");
                                  // cubit.selectedAltMobileNoCountry = country ?? AppConstants.defaultCountry;
                                  cubit.updateSelectedAltMobileCountry(
                                    country ?? AppConstants.defaultCountry,
                                  );
                                },
                              ))),
                      10.horizontalSpace,
                      Expanded(
                        flex: 9,
                        child: MyTextFormField(
                          controller: cubit.altMobileNumberCtl,
                          focusNode: cubit.altMobileNumberFn,
                          fieldName: appStrings(context).lblAlternateMobileNumber,
                          isMandatory: false,
                          isShowPrefixText: true,
                          prefixText: cubit.selectedAltMobileNoCountry.phoneCode,
                          fieldHint: appStrings(context).altMobileNumberPlaceholder,
                          isShowFieldName: false,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            InputFormatters().numberInputFormatterWithoutDot,
                            PhoneNumberInputFormatter.getFormatter(cubit.selectedAltMobileNoCountry.countryCode ?? "JO"),
                            // LengthLimitingTextInputFormatter(15),
                          ],
                          onFieldSubmitted: (v) {
                            // FocusScope.of(context).requestFocus(widget.addressFn);
                          },
                          isDisable: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return validatePhoneNumber(context, value, cubit.selectedAltMobileNoCountry.countryCode ?? "");
                          },
                        ),
                      ),
                    ],
                  ),
                  18.verticalSpace,

                  /// Property Area
                  MyTextFormField(
                    controller: cubit.propertyAreaCtl,
                    focusNode: cubit.propertyAreaFn,
                    fieldName: appStrings(context).propertyArea,
                    isMandatory: false,
                    fieldHint: appStrings(context).areaPlaceholder,
                    isShowFieldName: true,
                    isShowFieldMetric: true,
                    fieldMetricValue: AppConstants.areaMetric,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      InputFormatters().emojiRestrictInputFormatter,
                      InputFormatters().twoDecimalRestrict,
                    ],
                    onFieldSubmitted: (v) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                  18.verticalSpace,

                  /// 3D tour
                  MyTextFormField(
                    controller: cubit.property3DTourCtl,
                    focusNode: cubit.property3DTourFn,
                    fieldName: appStrings(context).threeDTour,
                    isMandatory: false,
                    fieldHint: appStrings(context).threeDTourLinkPlaceholder,
                    isShowFieldName: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      InputFormatters().emojiRestrictInputFormatter,
                    ],
                    maxLines: 2,
                    onFieldSubmitted: (v) {},
                    validator: (value) => validateLink(context, value),
                  ),
                  18.verticalSpace,

                  /// Property video
                  buildVideoLinksWidget(),
                  18.verticalSpace,

                  /// Property description
                  MyTextFormField(
                    controller: cubit.propertyDescCtl,
                    focusNode: cubit.propertyDescFn,
                    fieldName: appStrings(context).propertyDescription,
                    isMandatory: false,
                    fieldHint: appStrings(context).descriptionPlaceholder,
                    minLines: 5,
                    maxLines: null,
                    isShowFieldName: true,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    inputFormatters: [
                      InputFormatters().emojiRestrictInputFormatter,
                    ],
                    onFieldSubmitted: (v) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                  18.verticalSpace,

                  /// Thumbnail Images
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: Text(appStrings(context).thumbnail,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.black3D
                                    .adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0))),
                      ),
                      8.verticalSpace,
                      BlocProvider(
                        create: (BuildContext mCtx) => FilePickerCubit(),
                        child: BlocConsumer<FilePickerCubit, FilePickerState>(
                            bloc: context.read<FilePickerCubit>(),
                            listener: (context, fileState) {
                              if (fileState is FilesPickedState) {
                                final imageList = fileState.files.map((e) => e.path).toList();
                                context.read<AddEditPropertyCubit>().updateThumbnail(imageList, context);
                              }
                              if (fileState is FilesRemovedState) {
                                final imageList = context.read<AddEditPropertyCubit>().thumbnailImgList;
                                context.read<AddEditPropertyCubit>().updateThumbnail(imageList, context);
                              }
                            },
                            builder: (_, filePickerState) {
                              return FilePickerWidget(
                                key: UniqueKey(),
                                fileList: context.read<AddEditPropertyCubit>().thumbnailImgList,
                                isEdit: true,
                                allowedFileExtensions: [
                                  'jpg',
                                  'jpeg',
                                  'png',
                                  'gif',
                                  'heif',
                                  'heic',
                                ],
                                isImageTypeOnly: true,
                                isProfileImageSelection: true,
                                maxUploadVal: 1,
                                isDocument: false,
                              );
                            }),
                      ),
                    ],
                  ),
                  18.verticalSpace,

                  /// Images
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: Text(appStrings(context).documents,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.black3D
                                    .adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0))),
                      ),
                      8.verticalSpace,
                      BlocProvider(
                        create: (BuildContext mCtx) => FilePickerCubit(),
                        child: BlocConsumer<FilePickerCubit, FilePickerState>(
                            bloc: context.read<FilePickerCubit>(),
                            listener: (context, fileState) {
                              printf("State listener ==>$fileState");
                              if (fileState is FilesPickedState) {
                                final imageList = fileState.files.map((e) => e.path).toList();
                                printf('Attachments ${imageList.length}');

                                context.read<AddEditPropertyCubit>().updateAttachments(imageList, context);
                              }
                              if (fileState is FilesRemovedState) {
                                final imageList = context.read<AddEditPropertyCubit>().propertyAttachmentList;
                                context.read<AddEditPropertyCubit>().updateAttachments(imageList, context);
                              }
                            },
                            builder: (_, filePickerState) {
                              return FilePickerWidget(
                                key: UniqueKey(),
                                fileList: context.read<AddEditPropertyCubit>().propertyAttachmentList,
                                isEdit: true,
                                isImageTypeOnly: false,
                                isProfileImageSelection: false,
                                maxUploadVal: 10,
                                isDocument: false,
                              );
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(BuildContext context, AddEditPropertyState state) {
    if (state is AddEditPropertyFieldsLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is AddPropertyAPILoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is AddPropertyAPISuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is AddEditPropertyFieldsLoaded || state is AddPropertyAPISuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is AddEditPropertyCategoryFailure) {
      Utils.showErrorMessage(
          context: context, message: state.error.contains('No internet') ? appStrings(context).noInternetConnection : state.error);
    } else if (state is AddEditPropertyCountryFetchError) {
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    } else if (state is AddEditPropertySubCategoryFailure) {
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    }
  }

  /// Video Link widget.
  ///
  Widget buildVideoLinksWidget() {
    AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();
    return Column(
      children: cubit.videoLinksList.asMap().entries.map((entry) {
        final int index = entry.key;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cubit.videoLinksList.isNotEmpty
                ? MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: Text(
                      cubit.videoLinksList.length < 2 ? appStrings(context).videoLink : "${appStrings(context).videoLink} ${index + 1}",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color:
                              AppColors.black3D.adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
                    ),
                  )
                : const SizedBox.shrink(),
            5.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 9,
                  child: MyTextFormField(
                    controller: cubit.videoLinksControllers.length > index ? cubit.videoLinksControllers[index] : TextEditingController(),
                    isShowFieldName: false,
                    obscureText: false,
                    fieldHint: appStrings(context).videoTourLinkPlaceholder,
                    isMandatory: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    readOnly: false,
                    maxLines: 2,
                    inputFormatters: [InputFormatters().emojiRestrictInputFormatter],
                    validator: (value) => validateLinkWithDuplicates(context, value, index),
                    onChanged: (val) {
                      cubit.updateVideoLink(index, val);
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10),
                    child: CommonButtonWithIcon(
                      onTap: () {
                        if (index == 0) {
                          if (cubit.videoLinksControllers[index].text.trim().isEmpty) {
                            // Trigger validation if the field is empty
                            Utils.showErrorMessage(context: context, message: appStrings(context).videoTourLinkPlaceholder);
                            return;
                          }

                          if (cubit.videoLinksControllers.length < 3) {
                            cubit.addVideoLink("");
                          } else {
                            Utils.showErrorMessage(context: context, message: appStrings(context).errorMaxVideos);
                          }
                        } else {
                          cubit.deleteVideoLink(index);
                        }
                      },
                      isGradientColor: false,
                      icon: (index == 0)
                          ? SVGAssets.addIcon.toSvg(
                              context: context,
                              color:
                                  AppColors.black.adaptiveColor(context, lightModeColor: AppColors.black, darkModeColor: AppColors.white))
                          : SVGAssets.deleteIcon.toSvg(
                              context: context,
                            ),
                      borderColor: (index == 0)
                          ? AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.black3D)
                          : AppColors.red00,
                      buttonBgColor:
                          AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black14),
                    ),
                  ),
                ),
              ],
            ),
            12.verticalSpace,
          ],
        );
      }).toList(),
    );
  }

  /// Property Category BottomSheet
  ///
  Future<PropertyCategoryData?> showPropertyCategorySheet(BuildContext context, List<PropertyCategoryData> dataList) {
    final itemCount = dataList.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<PropertyCategoryData>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(appStrings(context).selectPropertyCategory,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black3D.forLightMode(context))),
                  ),
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
                    itemCount: dataList.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, dataList[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                dataList[index].name ?? "",
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.black14.forLightMode(context),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
                        ),
                      );
                    },
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: dataList.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, dataList[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  dataList[index].name ?? "",
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: AppColors.black14.forLightMode(context), // Applied specific color based on theme mode
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                          child: Divider(
                            height: 1,
                            color:
                                AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
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

  Future<CurrencyListData?> showCurrencyBottomSheet({required BuildContext context, required List<CurrencyListData> currency}) {
    final itemCount = currency.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<CurrencyListData>(
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
                  Text(appStrings(context).lblSelectCurrency,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                    itemCount: currency.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          // Return the selected country and close the sheet
                          Navigator.pop(context, currency[index]);
                        },
                        child: CurrencyListWidget(
                          currency: currency[index],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 14.0),
                        child: Divider(
                          height: 1,
                          color: AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
                        ),
                      );
                    },
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: currency.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Return the selected country and close the sheet
                            Navigator.pop(context, currency[index]);
                          },
                          child: CurrencyListWidget(
                            currency: currency[index],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 14.0),
                          child: Divider(
                            height: 1,
                            color:
                                AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
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

  /// Property Sub Category BottomSheet
  ///
  Future<PropertySubCategoryData?> showPropertySubCategorySheet(BuildContext context, List<PropertySubCategoryData> dataList) {
    final itemCount = dataList.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<PropertySubCategoryData>(
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
                  Flexible(
                    child: Text(appStrings(context).selectSubPropertyCategory,
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black3D.forLightMode(context))),
                  ),
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
                    itemCount: dataList.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, dataList[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                dataList[index].name ?? "",
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.black14.forLightMode(context),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
                        ),
                      );
                    },
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: dataList.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, dataList[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  dataList[index].name ?? "",
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: AppColors.black14.forLightMode(context), // Applied specific color based on theme mode
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                          child: Divider(
                            height: 1,
                            color:
                                AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
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

  Future<PropertyCategoryData?> showFurnishedDataSheet(BuildContext context, List<PropertyCategoryData> dataList) {
    final itemCount = dataList.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<PropertyCategoryData>(
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
                  Text(appStrings(context).selectFurnished,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black3D.forLightMode(context))),
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
                    itemCount: dataList.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, dataList[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                dataList[index].name ?? "",
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.black14.forLightMode(context),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
                        ),
                      );
                    },
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: dataList.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, dataList[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  dataList[index].name ?? "",
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: AppColors.black14.forLightMode(context), // Applied specific color based on theme mode
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                          child: Divider(
                            height: 1,
                            color:
                                AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
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

  /// under Construction BottomSheet
  ///
  Future<String?> showUnderConstructionBottomSheet(BuildContext context, List<String> dataList) {
    return showModalBottomSheet<String>(
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
                  Text(appStrings(context).underConstructionStatus,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black3D.forLightMode(context))),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
            ListView.separated(
              itemCount: dataList.length,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, dataList[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          dataList[index],
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.black14.forLightMode(context),
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                  child: Divider(
                    height: 1,
                    color: AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

String? validateLinkWithDuplicates(BuildContext context, String? value, int index) {
  AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();

  if ((value ?? "").isNotEmpty) {
    if (!AnyLinkPreview.isValidLink(value!)) {
      return appStrings(context).invalidUrlError;
    }

    bool isDuplicate = cubit.videoLinksList.asMap().entries.any((entry) {
      return entry.key != index && entry.value == value;
    });

    if (isDuplicate) {
      return appStrings(context).errorDuplicateLink;
    }
  }
  //
  // // Check if the list contains any empty value only when the list length > 1
  // if (cubit.videoLinksList.length > 1 &&
  //     cubit.videoLinksList.any((link) => link.isEmpty)) {
  //   return appStrings(context)
  //       .emptyLinkError; // Message for any empty link in the list
  // }
  return null;
}

String? validateDataDuplicates(BuildContext context, String? value, int index) {
  AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();

  if ((value ?? "").isNotEmpty) {
    bool isDuplicate = cubit.locationKeys.asMap().entries.any((entry) {
      return entry.key != index && entry.value == value;
    });

    if (isDuplicate) {
      return appStrings(context).errorDuplicateLink;
    }
  }
  return null;
}
