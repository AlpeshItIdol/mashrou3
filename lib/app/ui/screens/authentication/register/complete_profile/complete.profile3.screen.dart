import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:place_picker_google/place_picker_google.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../db/app_preferences.dart';
import '../../../../../model/vendor_list_response.model.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/common_button_with_icon.dart';
import '../../../../custom_widget/custom_stepper_widget.dart';
import '../../../../custom_widget/file_picker_widget/cubit/file_picker_cubit.dart';
import '../../../../custom_widget/file_picker_widget/file_picker_widget.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import 'cubit/complete_profile_cubit.dart';

class CompleteProfile3Screen extends StatefulWidget {
  const CompleteProfile3Screen({super.key});

  @override
  State<CompleteProfile3Screen> createState() => _CompleteProfile3ScreenState();
}

class _CompleteProfile3ScreenState extends State<CompleteProfile3Screen>
    with AppBarMixin {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CompleteProfileCubit cubit = context.read<CompleteProfileCubit>();
    return BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(context: context, appBarHeight: 58),
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
                              currentStep: 5,
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
                                FocusScope.of(context)
                                    .requestFocus(cubit.instagramLinkFn);
                              },
                              readOnly: false,
                              inputFormatters: [
                                InputFormatters().emojiRestrictInputFormatter
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
                                FocusScope.of(context)
                                    .requestFocus(cubit.linkedInLinkFn);
                              },
                              readOnly: false,
                              inputFormatters: [
                                InputFormatters().emojiRestrictInputFormatter
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
                                  fieldName:
                                      appStrings(context).lblLinkedInLink,
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
                                    InputFormatters()
                                        .emojiRestrictInputFormatter
                                  ],
                                  obscureText: false,
                                  validator: (value) {
                                    return validateLinkedInLink(context, value);
                                  },
                                ),
                                12.verticalSpace,
                              ],
                            ).showIf(
                                cubit.selectedUserRole == AppStrings.owner),

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
                                    InputFormatters()
                                        .emojiRestrictInputFormatter
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
                                  inputFormatters: [
                                    InputFormatters()
                                        .emojiRestrictInputFormatter
                                  ],
                                  obscureText: false,
                                  validator: (value) {
                                    return validateUrlLink(context, value);
                                  },
                                ),
                                12.verticalSpace,
                                MyTextFormField(
                                  fieldName:
                                      appStrings(context).lbl3DVirtualTourLink,
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
                                  inputFormatters: [
                                    InputFormatters()
                                        .emojiRestrictInputFormatter
                                  ],
                                  obscureText: false,
                                  validator: (value) {
                                    return validateUrlLink(context, value);
                                  },
                                ),
                                12.verticalSpace,
                              ],
                            ).showIf(
                                cubit.selectedUserRole == AppStrings.vendor),

                            /// Profile Link widget
                            ///
                            buildProfileLinksWidget().showIf(
                                cubit.selectedUserRole == AppStrings.owner),

                            12.verticalSpace,

                            /// Location widget
                            ///
                            MyTextFormField(
                              fieldName: appStrings(context).lblGoogleLocation,
                              controller: cubit.googleLocationCtl,
                              focusNode: cubit.googleLocationFn,
                              isMandatory: true,
                              maxLines: 2,
                              suffixIcon: SVGAssets.locationBlackIcon.toSvg(
                                  height: 22, width: 20, context: context),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                // FocusScope.of(context)
                                //     .requestFocus(cubit.instagramLinkFn);
                              },
                              readOnly: true,
                              onTap: () async {
                                OverlayLoadingProgress.start(context);
                                 await cubit.getLocation(context);
                                OverlayLoadingProgress.stop();
                                UIComponent.showPlacePicker(
                                    context: context,
                                    onPlacePicked: (LocationResult result) {
                                      printf(
                                          "Selected place: ${result.formattedAddress}");
                                      cubit.googleLocationCtl.text =
                                          result.formattedAddress ?? "";
                                      cubit.locationLatLng = result.latLng!;
                                      cubit.latitude = result.latLng!.latitude;
                                      cubit.longitude = result.latLng!.longitude;
                                    },
                                    someNullableTextDirection:
                                        TextDirection.ltr,
                                    initialLocation: LatLng(
                                        cubit.latitude, cubit.longitude));
                              },
                              obscureText: false,
                              validator: (value) {
                                return validateLocation(context, value);
                              },
                            ),
                            12.verticalSpace,

                            /// Upload Logo widget
                            ///
                            BlocProvider(
                              create: (BuildContext context) =>
                                  FilePickerCubit(),
                              child: BlocConsumer<FilePickerCubit,
                                  FilePickerState>(listener: (context, state) {
                                if (state is FilePickerDataLoading) {}

                                if (state is OnlyImageFilesPickedState) {
                                  final imageList =
                                      state.files.map((e) => e.path).toList();
                                  cubit.companyLogo.addAll(imageList);
                                  var fileName =
                                      cubit.companyLogo.first.split('/').last;
                                  cubit.uploadLogoCtl.text = fileName;
                                  cubit.updateCompanyLogo();
                                }
                              }, builder: (context, state) {
                                return MyTextFormField(
                                  fieldName: appStrings(context).lblUploadLogo,
                                  controller: cubit.uploadLogoCtl,
                                  focusNode: cubit.uploadLogoFn,
                                  isMandatory: true,
                                  maxLines: 2,
                                  suffixIcon: SVGAssets.uploadIcon.toSvg(
                                      height: 22, width: 22, context: context),
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  readOnly: true,
                                  onTap: () async {
                                    await Utils.getStorageReadPermission();

                                    context.read<FilePickerCubit>().pickFiles(
                                        cubit.companyLogo,
                                        true,
                                        "",
                                        "",
                                        context);
                                  },
                                  obscureText: false,
                                  validator: (value) {
                                    return validateCompanyLogo(context, value);
                                  },
                                );
                              }),
                            ),

                            12.verticalSpace,

                            /// Portfolio widget
                            ///
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.0)),
                                  child: Text(appStrings(context).lblPortfolio,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              color: AppColors.black3D
                                                  .forLightMode(context))),
                                ),
                                8.verticalSpace,
                                BlocProvider(
                                  create: (BuildContext context) =>
                                      FilePickerCubit(),
                                  child: BlocConsumer<FilePickerCubit,
                                          FilePickerState>(
                                      bloc: context.read<FilePickerCubit>(),
                                      listener: (context, state) {
                                        if (state is FilesPickedState) {
                                          final imageList = state.files
                                              .map((e) => e.path)
                                              .toList();
                                          cubit.updateAttachments(
                                              imageList, context);
                                        }
                                        if (state is FilesRemovedState) {
                                          final imageList = cubit.portfolioList;
                                          cubit.updateAttachments(
                                              imageList, context);
                                        }
                                      },
                                      builder: (_, state) {
                                        return FilePickerWidget(
                                          key: UniqueKey(),
                                          fileList: cubit.portfolioList,
                                          isEdit: true,
                                          isImageTypeOnly: false,
                                          isProfileImageSelection: false,
                                          maxUploadVal: 10,
                                          isDocument: false,
                                        );
                                      }),
                                ),
                                12.verticalSpace,
                              ],
                            ).showIf(
                                cubit.selectedUserRole == AppStrings.vendor),

                            /// Upload Documents widget
                            ///
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.0)),
                                  child: Text("${appStrings(context).documents} *",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              color: AppColors.black3D
                                                  .forLightMode(context))),
                                ),
                                MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.0)),
                                  child: Text(appStrings(context).signUpDocumentLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                          color: AppColors.black48
                                              .forLightMode(context))),
                                ),MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.0)),
                                  child: Text("1-${appStrings(context).professionalLicence}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                          color: AppColors.black48
                                              .forLightMode(context))),
                                ),MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.0)),
                                  child: Text("2-${appStrings(context).commercialLicence}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                          color: AppColors.black48
                                              .forLightMode(context))),
                                ),
                                8.verticalSpace,
                                BlocProvider(
                                  create: (BuildContext context) =>
                                      FilePickerCubit(),
                                  child: BlocConsumer<FilePickerCubit,
                                          FilePickerState>(
                                      bloc: context.read<FilePickerCubit>(),
                                      listener: (context, state) {
                                        if (state is FilesPickedState) {
                                          final imageList = state.files
                                              .map((e) => e.path)
                                              .toList();
                                          cubit.updateAttachments(
                                              imageList, context);
                                        }
                                        if (state is FilesRemovedState) {
                                          final imageList = cubit.documentsList;
                                          cubit.updateAttachments(
                                              imageList, context);
                                        }
                                      },
                                      builder: (_, state) {
                                        return FilePickerWidget(
                                          key: UniqueKey(),
                                          fileList: cubit.documentsList,
                                          isEdit: true,
                                          isImageTypeOnly: false,
                                          isProfileImageSelection: false,
                                          maxUploadVal: 10,
                                          isDocument: false,
                                        );
                                      }),
                                ),
                              ],
                            ),
                            24.verticalSpace,
                            UIComponent.customInkWellWidget(
                              onTap: () {
                                setState(() {
                                  cubit.isSelected = !cubit.isSelected;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  cubit.isSelected
                                      ? SVGAssets.checkboxEnableIcon.toSvg(
                                          height: 18,
                                          width: 18,
                                          context: context)
                                      : SVGAssets.checkboxDisableIcon.toSvg(
                                          height: 18,
                                          width: 18,
                                          context: context),
                                  10.horizontalSpace,
                                  Flexible(
                                    child: UIComponent.termsAndPrivacyText(
                                        context: context),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar:
                  BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                builder: (context, state) =>
                    UIComponent.bottomSheetWithButtonWithGradient(
                        context: context,
                        onTap: () {
                          onSaveClick(context);
                        },
                        buttonTitle: appStrings(context).btnNext),
              ));
        });
  }

  /// Build bloc listener widget.
  ///
  Future<void> buildBlocListener(
      BuildContext context, CompleteProfileState state) async {
    if (state is CompleteProfileAPILoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is CompleteProfileSuccess) {
      OverlayLoadingProgress.stop();
      final appPreferences = GetIt.I<AppPreferences>();
      final verifyResponseData = state.model.verifyResponseData;
      final user = verifyResponseData?.users;

      if (verifyResponseData != null && user != null) {
        // Set user details and role type
        await appPreferences.setUserDetails(verifyResponseData);
        await appPreferences.saveSelectedCountryID(value: user.country);

        if (user.isVerified == true) {
          // Set isVerified for user
          await appPreferences.isVerified(value: true);

          if (user.profileComplete == true) {
            // Set profile completion and login status
            await appPreferences.isProfileCompleted(value: true);
            if (user.isActive == true) {
              await appPreferences.isActive(value: true);

              if (user.userType == AppStrings.owner) {
                await appPreferences.isLoggedIn(value: true);
                context.goNamed(Routes.kOwnerDashboard);
                return;
              } else {
                await appPreferences.isLoggedIn(value: true);
                context.goNamed(Routes.kDashboard);
                return;
              }
            } else {
              context.goNamed(Routes.kUndergoingVerificationScreen);
            }
          } else {
            // Navigate to the complete profile screen
            context.goNamed(Routes.kCompleteProfileScreen);
          }
        } else {
          // Navigate to the UndergoingVerification screen
          context.goNamed(Routes.kLoginScreen);
        }
      }
    } else if (state is CompleteProfileError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }

  /// Method Validation
  ///
  bool validate(BuildContext context) {
    CompleteProfileCubit cubit = context.read<CompleteProfileCubit>();
    if (cubit.companyLogo.isEmpty) {
      Utils.showErrorMessage(
          context: context, message: appStrings(context).logoEmptyError);
      return false;
    }

    if (cubit.documentsList.isEmpty) {
      Utils.showErrorMessage(
          context: context, message: appStrings(context).documentsEmptyError);
      return false;
    }

    return true;
  }

  /// Profile Link widget.
  ///
  Widget buildProfileLinksWidget() {
    CompleteProfileCubit cubit = context.read<CompleteProfileCubit>();
    return Column(
      children: cubit.profileLinksList.asMap().entries.map((entry) {
        final int index = entry.key;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0)),
              child: Text(
                  cubit.profileLinksList.length < 2
                      ? appStrings(context).lblProfileLink ?? ""
                      : "${appStrings(context).lblProfileLink} ${index + 1}" ??
                          "",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.black3D.forLightMode(context))),
            ),
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
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    readOnly: false,
                    inputFormatters: [
                      InputFormatters().emojiRestrictInputFormatter
                    ],
                    validator: (value) {
                      return validateUrlLink(context, value);
                    },
                    onChanged: (val) {
                      cubit.profileLinksList[index] = val;
                      cubit.updateProfileLink(
                          index, val); // Update the question in cubit
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
                            Utils.showErrorMessage(
                                context: context,
                                message: appStrings(context).errorMaxLinks);
                          }
                        } else {
                          cubit.deleteProfileLink(index);
                        }
                      },
                      icon: (index == 0)
                          ? SVGAssets.addIcon.toSvg(context: context)
                          : SVGAssets.deleteIcon.toSvg(context: context),
                      borderColor:
                          (index == 0) ? AppColors.greyE8 : AppColors.red00,
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

  /// Vendor Bottom Sheet
  ///
  Future<VendorListData?> showVendorsBottomSheet(
      BuildContext context, List<VendorListData> vendors) {
    final itemCount = vendors.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<VendorListData>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(appStrings(context).lblSelectVendor ?? "",
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
                    itemCount: vendors.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            // Return the selected country and close the sheet
                            Navigator.pop(context, vendors[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  vendors[index].title ?? "",
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
                          ));
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
                      itemCount: vendors.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Return the selected country and close the sheet
                            Navigator.pop(context, vendors[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  vendors[index].title ?? "",
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

  /// Button Method
  ///
  Future<void> onSaveClick(BuildContext context) async {
    if (context.read<CompleteProfileCubit>().isSelected) {
      if (formKey.currentState!.validate() && validate(context)) {
        context.read<CompleteProfileCubit>().completeProfileAPI();
      }
    } else {
      Utils.snackBar(
          context: context, message: appStrings(context).kindlyAgreeTerms);
    }
  }
}
