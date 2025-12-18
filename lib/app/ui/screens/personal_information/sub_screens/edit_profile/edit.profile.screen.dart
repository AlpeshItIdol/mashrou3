import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:place_picker_google/place_picker_google.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/resources/app_constants.dart';
import '../../../../../../config/resources/app_strings.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../model/city_list_response_model.dart';
import '../../../../../model/country_list_model.dart';
import '../../../../../model/language_list_response_model.dart';
import '../../../../custom_widget/bottom_sheet_with_pagination/bottom_sheet_with_pagination.dart';
import '../../../../custom_widget/common_button_with_icon.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../authentication/component/country_bottomsheet_widget/country_bottomsheet_widget.dart';
import '../../../authentication/component/mobile_number_with_country_widget_for_property.dart';
import '../../../authentication/login/model/login_response.model.dart';
import '../../cubit/personal_information_cubit.dart';
import 'cubit/edit_profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with AppBarMixin {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    formKey.currentState?.reset(); // Reset the form validation state
    context.read<EditProfileCubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditProfileCubit cubit = context.read<EditProfileCubit>();
    return BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                context: context,
                requireLeading: true,
                title: appStrings(context).lblEditInformation,
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// First Name widget
                            ///
                            MyTextFormField(
                              fieldName: appStrings(context).lblFirstName,
                              controller: cubit.firstNameCtl,
                              focusNode: cubit.firstNameFn,
                              isMandatory: true,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(cubit.lastNameFn);
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
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(cubit.emailIdFn);
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
                              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                              child: Text(appStrings(context).lblAlternateMobileNumber,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.black3D.forLightMode(context))),
                            ),
                            5.verticalSpace,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: MobileNumberWithCountryWidgetForProperty(
                                      countryList: cubit.countryList ?? [],
                                      verticalPadding: 11,
                                      initialCountry: cubit.selectedAltMobileNoCountry,
                                      onCountrySelected: (CountryListData? country) {
                                        printf("Selected Country: ${country?.name}, Flag: ${country?.emoji}");
                                        cubit.selectedAltMobileNoCountry = country ?? AppConstants.defaultCountry;
                                      },
                                    )),
                                10.horizontalSpace,
                                Expanded(
                                  flex: 9,
                                  child: MyTextFormField(
                                    controller: cubit.mobileNumberCtl,
                                    focusNode: cubit.mobileNumberFn,
                                    fieldName: appStrings(context).lblMobileNumber,
                                    isShowPrefixText: true,
                                    prefixText: cubit.selectedAltMobileNoCountry.phoneCode,
                                    isMandatory: true,
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
                                    readOnly: false,
                                    obscureText: false,
                                    validator: (value) {
                                      // return null;
                                      return validatePhoneNumber(context, value, cubit.selectedAltMobileNoCountry.countryCode ?? "JO");
                                    },
                                  ),
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
                              // inputFormatters: [InputFormatters().emailInputFormatter],
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (v) {
                                // FocusScope.of(context).requestFocus(cubit.addressFn);
                              },
                              textInputAction: TextInputAction.next,
                              readOnly: false,
                              obscureText: false,
                              maxLines: 2,
                              validator: (value) {
                                return validateEmail(context, value?.trim());
                              },
                            ),
                            12.verticalSpace,

                            /// City Widget
                            ///
                            MediaQuery(
                              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                              child: Text("${appStrings(context).lblSelectCity} *",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.black3D.forLightMode(context))),
                            ),
                            5.verticalSpace,
                            InkWell(
                              onTap: cubit.isSelectedCountry == true
                                  ? () async {
                                      final city = await showModalBottomSheet<Cities>(
                                        context: context,
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          ),
                                        ),
                                        builder: (_) => CityListBottomSheet(
                                          selectedCountryId: cubit.selectedCountryId,
                                          searchController: cubit.searchCtl,
                                        ),
                                      );

                                      if (city != null) {
                                        setState(() {
                                          cubit.selectedCity = city;
                                          printf("${cubit.selectedCity}");
                                        });
                                        cubit.searchCtl.clear();
                                      }
                                    }
                                  : () {},
                              child: Container(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: cubit.isSelectedCountry == true
                                      ? AppColors.white
                                          .adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black14)
                                      : AppColors.greyF1,
                                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                                  border: Border.all(
                                      color: cubit.isSelectedCountry == true
                                          ? AppColors.greyE9
                                              .adaptiveColor(context, lightModeColor: AppColors.greyE9, darkModeColor: AppColors.black2E)
                                          : AppColors.greyF1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          cubit.selectedCity.name ?? appStrings(context).lblSelectCity,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: cubit.isSelectedCountry == true
                                                  ? Theme.of(context).primaryColor
                                                  : Theme.of(context).primaryColor.withOpacity(0.5),
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    SVGAssets.arrowDownIcon.toSvg(
                                        context: context,
                                        color: cubit.isSelectedCountry == true
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).primaryColor.withOpacity(0.5)),
                                  ],
                                ),
                              ),
                            ),
                            12.verticalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Company name widget
                                ///
                                MyTextFormField(
                                  fieldName: appStrings(context).lblCompanyName,
                                  controller: cubit.companyNameCtl,
                                  focusNode: cubit.companyNameFn,
                                  isMandatory: true,
                                  maxLines: 2,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    // FocusScope.of(context)
                                    //     .requestFocus(cubit.lastNameFn);
                                  },
                                  readOnly: false,
                                  inputFormatters: [
                                    InputFormatters().textInputFormatterArabicWithSpecialCharacters,
                                  ],
                                  obscureText: false,
                                  validator: (value) {
                                    return validateCompanyName(context, value);
                                  },
                                ),
                                12.verticalSpace,

                                /// Website Link widget
                                ///
                                MyTextFormField(
                                  fieldName: appStrings(context).lblWebsiteLink,
                                  controller: cubit.websiteLinkCtl,
                                  focusNode: cubit.websiteLinkFn,
                                  isMandatory: false,
                                  maxLines: 2,
                                  // inputFormatters: [InputFormatters().emailInputFormatter],
                                  keyboardType: TextInputType.emailAddress,
                                  inputFormatters: [InputFormatters().emojiRestrictInputFormatter],
                                  onFieldSubmitted: (v) {
                                    // FocusScope.of(context).requestFocus(cubit.addressFn);
                                  },
                                  textInputAction: TextInputAction.next,
                                  readOnly: false,
                                  obscureText: false,
                                  validator: (value) {
                                    return validateUrlLink(context, value);
                                  },
                                ),
                                12.verticalSpace,

                                /// Facebook Link widget
                                ///
                                MyTextFormField(
                                  fieldName: appStrings(context).lblFacebookLink,
                                  controller: cubit.facebookLinkCtl,
                                  focusNode: cubit.facebookLinkFn,
                                  isMandatory: false,
                                  maxLines: 2,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(cubit.instagramLinkFn);
                                  },
                                  readOnly: false,
                                  inputFormatters: [
                                    InputFormatters().emojiRestrictInputFormatter,
                                  ],
                                  obscureText: false,
                                  validator: (value) {
                                    return validateFacebookLink(context, value);
                                  },
                                ),
                                12.verticalSpace,

                                /// Instagram Link widget
                                ///
                                MyTextFormField(
                                  fieldName: appStrings(context).lblInstagramLink,
                                  controller: cubit.instagramLinkCtl,
                                  focusNode: cubit.instagramLinkFn,
                                  isMandatory: false,
                                  maxLines: 2,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(cubit.linkedInLinkFn);
                                  },
                                  readOnly: false,
                                  inputFormatters: [
                                    InputFormatters().emojiRestrictInputFormatter,
                                  ],
                                  obscureText: false,
                                  validator: (value) {
                                    return validateInstagramLink(context, value);
                                  },
                                ),
                                12.verticalSpace,

                                /// LinkedIn Link widget
                                ///
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextFormField(
                                      fieldName: appStrings(context).lblLinkedInLink,
                                      controller: cubit.linkedInLinkCtl,
                                      focusNode: cubit.linkedInLinkFn,
                                      isMandatory: false,
                                      maxLines: 2,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        // FocusScope.of(context)
                                        //     .requestFocus(cubit.instagramLinkFn);
                                      },
                                      readOnly: false,
                                      inputFormatters: [
                                        InputFormatters().emojiRestrictInputFormatter,
                                      ],
                                      obscureText: false,
                                      validator: (value) {
                                        return validateLinkedInLink(context, value);
                                      },
                                    ),
                                    12.verticalSpace,
                                  ],
                                ).showIf(cubit.selectedUserRole == AppStrings.owner),

                                /// Twitter and Catalog Link widget
                                ///
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextFormField(
                                      fieldName: appStrings(context).lblTwitterLink,
                                      controller: cubit.twitterLinkCtl,
                                      focusNode: cubit.twitterLinkFn,
                                      isMandatory: false,
                                      maxLines: 2,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        // FocusScope.of(context)
                                        //     .requestFocus(cubit.instagramLinkFn);
                                      },
                                      readOnly: false,
                                      inputFormatters: [
                                        InputFormatters().emojiRestrictInputFormatter,
                                      ],
                                      obscureText: false,
                                      validator: (value) {
                                        return validateXLink(context, value);
                                      },
                                    ),
                                    12.verticalSpace,
                                    MyTextFormField(
                                      fieldName: appStrings(context).lblCatalogLink,
                                      controller: cubit.catalogLinkCtl,
                                      focusNode: cubit.catalogLinkFn,
                                      isMandatory: false,
                                      maxLines: 2,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        // FocusScope.of(context)
                                        //     .requestFocus(cubit.instagramLinkFn);
                                      },
                                      readOnly: false,
                                      inputFormatters: [InputFormatters().emojiRestrictInputFormatter],
                                      obscureText: false,
                                      validator: (value) {
                                        return validateUrlLink(context, value);
                                      },
                                    ),
                                    12.verticalSpace,
                                    MyTextFormField(
                                      fieldName: appStrings(context).lbl3DVirtualTourLink,
                                      controller: cubit.virtualTourLinkCtl,
                                      focusNode: cubit.virtualTourLinkFn,
                                      isMandatory: false,
                                      maxLines: 2,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        // FocusScope.of(context)
                                        //     .requestFocus(cubit.instagramLinkFn);
                                      },
                                      readOnly: false,
                                      inputFormatters: [InputFormatters().emojiRestrictInputFormatter],
                                      obscureText: false,
                                      validator: (value) {
                                        return validateUrlLink(context, value);
                                      },
                                    ),
                                    // 12.verticalSpace,
                                  ],
                                ).showIf(cubit.selectedUserRole == AppStrings.vendor),

                                /// Profile Link widget
                                ///
                                buildProfileLinksWidget().showIf(cubit.selectedUserRole == AppStrings.owner),

                                12.verticalSpace,

                                /// Location Address widget
                                ///
                                buildAddressWidget(),
                                12.verticalSpace,

                                /// Description widget
                                ///
                                ///
                                MyTextFormField(
                                  fieldName: appStrings(context).lblDescription,
                                  controller: cubit.descriptionCtl,
                                  focusNode: cubit.descriptionFn,
                                  isMandatory: true,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  onFieldSubmitted: (v) {
                                    // FocusScope.of(context).requestFocus(cubit.emailIdFn);
                                  },
                                  inputFormatters: [
                                    InputFormatters().emojiRestrictInputFormatter,
                                  ],
                                  maxLines: null,
                                  minLines: 5,
                                  readOnly: false,
                                  obscureText: false,
                                  validator: (value) {
                                    return validateDescription(context, value);
                                  },
                                ),
                                12.verticalSpace,
                              ],
                            ).hideIf(cubit.selectedUserRole == AppStrings.visitor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UIComponent.bottomSheetWithButtonWithGradient(
                              context: context,
                              onTap: () {
                                onSaveClick(context);
                              },
                              buttonTitle: appStrings(context).save),
                        ],
                      )));
        });
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(BuildContext context, EditProfileState state) async {
    if (state is EditProfileLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is EditProfileSuccess) {
      OverlayLoadingProgress.stop();
      // final appPreferences = GetIt.I<AppPreferences>();
      // final verifyResponseData = state.model.verifyResponseData;
      // final user = verifyResponseData?.users;
      // if (verifyResponseData != null && user != null) {
      //   // Set user details and role type
      //   await appPreferences.setUserDetails(verifyResponseData);
      // }
      context.pop();
    } else if (state is APISuccessForEditProfile) {
      OverlayLoadingProgress.stop();
    } else if (state is EditProfileError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    }
  }

  /// Method validation
  ///
  bool validate(BuildContext context) {
    EditProfileCubit cubit = context.read<EditProfileCubit>();
    if (cubit.selectedCity.sId == null || cubit.selectedCity.sId!.isEmpty) {
      Utils.showErrorMessage(context: context, message: appStrings(context).cityEmptyError);
      return false;
    }
    return true;
  }

  /// Country Bottom Sheet.
  ///
  Future<CountryListData?> showCountryBottomSheet(BuildContext context, List<CountryListData> countries) {
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
                  Text(appStrings(context).lblSelectCountry,
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

  /// Profile Link widget.
  ///
  Widget buildProfileLinksWidget() {
    EditProfileCubit cubit = context.read<EditProfileCubit>();
    return Column(
      children: cubit.profileLinksList.asMap().entries.map((entry) {
        final int index = entry.key;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                cubit.profileLinksList.length < 2
                    ? appStrings(context).lblProfileLink
                    : "${appStrings(context).lblProfileLink} ${index + 1}",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.black3D.forLightMode(context))),
            5.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 9,
                  child: MyTextFormField(
                    controller: cubit.profileLinksControllers[index],
                    isShowFieldName: false,
                    obscureText: false,
                    isMandatory: false,
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    readOnly: false,
                    inputFormatters: [InputFormatters().emojiRestrictInputFormatter],
                    validator: (value) {
                      return validateUrlLink(context, value);
                    },
                    onChanged: (val) {
                      cubit.profileLinksList[index] = val;
                      cubit.updateProfileLink(index, val); // Update the question in cubit
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CommonButtonWithIcon(
                      onTap: () {
                        if (index == 0) {
                          if (cubit.profileLinksControllers.length < 3) {
                            cubit.addProfileLink("");
                          } else {
                            Utils.showErrorMessage(context: context, message: appStrings(context).errorMaxLinks);
                          }
                        } else {
                          cubit.deleteProfileLink(index);
                        }
                      },
                      icon: (index == 0) ? SVGAssets.addIcon.toSvg(context: context) : SVGAssets.deleteIcon.toSvg(context: context),
                      borderColor: (index == 0) ? AppColors.greyE8 : AppColors.red00,
                      buttonBgColor: AppColors.white,
                      isGradientColor: false,
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

  /// Address widget.
  ///
  Widget buildAddressWidget() {
    EditProfileCubit cubit = context.read<EditProfileCubit>();
    // Ensure there are enough FocusNodes for all addresses
    while (cubit.addressesFns.length < cubit.addressesList.length) {
      cubit.addressesFns.add(FocusNode());
    }
    return Column(
      children: cubit.addressesList.asMap().entries.map((entry) {
        final int index = entry.key;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Text(
                cubit.addressesList.length < 2 ? appStrings(context).lblAddress : "${appStrings(context).lblAddress} ${index + 1}",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.black3D.forLightMode(context)),
              ),
            ),
            5.verticalSpace,
            cubit.selectedUserRole == AppStrings.vendor
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 9,
                        child: MyTextFormField(
                          fieldName: appStrings(context).lblGoogleLocation,
                          controller: cubit.addressesControllers[index],
                          focusNode: cubit.addressesFns[index],
                          // Use the FocusNode list
                          isMandatory: true,
                          maxLines: 2,
                          obscureText: false,
                          isShowFieldName: false,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          readOnly: true,
                          suffixIcon: SVGAssets.locationBlackIcon.toSvg(height: 22, width: 20, context: context),
                          onTap: () {
                            UIComponent.showPlacePicker(
                              context: context,
                              onPlacePicked: (LocationResult result) {
                                // Create a Location object with the new address and coordinates
                                Location updatedLocation = Location(
                                  latitude: result.latLng?.latitude ?? 0.0,
                                  longitude: result.latLng?.longitude ?? 0.0,
                                  address: result.formattedAddress ?? "",
                                );

                                // Update the address in the controller
                                cubit.addressesControllers[index].text = updatedLocation.address ?? "";

                                // Update the Location object in the addressesList
                                cubit.updateAddress(index, updatedLocation); // Pass the Location object

                                // Optionally update the location coordinates in a global variable
                                cubit.locationLatLng = result.latLng!;
                              },
                              someNullableTextDirection: TextDirection.ltr,
                            );
                          },
                          validator: (value) {
                            return validateLocation(context, value);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CommonButtonWithIcon(
                            onTap: () {
                              if (index == 0) {
                                if (cubit.addressesControllers.length < 3) {
                                  cubit.addAddress(Location()); // Add a new Location
                                  cubit.addressesFns.add(FocusNode()); // Add a new FocusNode
                                } else {
                                  Utils.showErrorMessage(context: context, message: appStrings(context).errorMaxAddresses);
                                }
                              } else {
                                cubit.deleteAddress(index);
                                cubit.addressesFns.removeAt(index); // Remove the FocusNode
                              }
                            },
                            icon: (index == 0) ? SVGAssets.addIcon.toSvg(context: context) : SVGAssets.deleteIcon.toSvg(context: context),
                            borderColor: (index == 0) ? AppColors.greyE8 : AppColors.red00,
                            buttonBgColor: AppColors.white,
                            isGradientColor: false,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: MyTextFormField(
                          fieldName: appStrings(context).lblGoogleLocation,
                          controller: cubit.addressesControllers[index],
                          focusNode: cubit.addressesFns[index],
                          // Use the FocusNode list
                          isMandatory: true,
                          maxLines: 2,
                          obscureText: false,
                          isShowFieldName: false,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          readOnly: true,
                          suffixIcon: SVGAssets.locationBlackIcon.toSvg(height: 22, width: 20, context: context),
                          onTap: () {
                            UIComponent.showPlacePicker(
                              context: context,
                              onPlacePicked: (LocationResult result) {
                                // Create a Location object with the new address and coordinates
                                Location updatedLocation = Location(
                                  latitude: result.latLng?.latitude ?? 0.0,
                                  longitude: result.latLng?.longitude ?? 0.0,
                                  address: result.formattedAddress ?? "",
                                );

                                // Update the address in the controller
                                cubit.addressesControllers[index].text = updatedLocation.address ?? "";

                                // Update the Location object in the addressesList
                                cubit.updateAddress(index, updatedLocation); // Pass the Location object

                                // Optionally update the location coordinates in a global variable
                                cubit.locationLatLng = result.latLng!;
                              },
                              someNullableTextDirection: TextDirection.ltr,
                            );
                          },
                          validator: (value) {
                            return validateLocation(context, value);
                          },
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

  /// Language List BottomSheet
  ///
  Future<LanguageListData?> showLanguageBottomSheet(BuildContext context, List<LanguageListData> languageListData) {
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
                  Text(appStrings(context).lblSelectLanguage,
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
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                languageListData[index].langLongName ?? "",
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
                          color: AppColors.greyE8.adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
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
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  languageListData[index].langLongName ?? "",
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

  Future<void> onSaveClick(BuildContext context) async {
    EditProfileCubit cubit = context.read<EditProfileCubit>();
    if (formKey.currentState!.validate() && validate(context)) {
      cubit.editProfileAPI(context).then((value) async {
        if (!context.mounted) return;
        PersonalInformationCubit personalInformationCubit = context.read<PersonalInformationCubit>();

        await personalInformationCubit.getData(context);
        // context.pop();
      });
    }
  }
}
