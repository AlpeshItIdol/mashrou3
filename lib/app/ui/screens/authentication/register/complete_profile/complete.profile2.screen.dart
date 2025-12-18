import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/resources/app_strings.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../model/vendor_list_response.model.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/custom_stepper_widget.dart';
import '../../../property_details/sub_screens/banks_list/model/banks_list_response_model.dart';
import 'cubit/complete_profile_cubit.dart';

class CompleteProfile2Screen extends StatefulWidget {
  const CompleteProfile2Screen({super.key});

  @override
  State<CompleteProfile2Screen> createState() => _CompleteProfile2ScreenState();
}

class _CompleteProfile2ScreenState extends State<CompleteProfile2Screen>
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
                              currentStep: 4,
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
                                InputFormatters()
                                    .textInputFormatterWithSpecialCharacters,
                              ],
                              obscureText: false,
                              validator: (value) {
                                return validateCompanyName(context, value);
                              },
                            ),
                            12.verticalSpace,

                            /// Vendor Type widget
                            ///
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${appStrings(context).lblVendorType} *" ??
                                        "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.black3D
                                                .forLightMode(context))),
                                5.verticalSpace,
                                InkWell(
                                  onTap: () async {
                                    final selectedVendors =
                                        await showVendorsBottomSheet(
                                            context, cubit.vendorList ?? []);
                                    // final vendor = await showVendorsBottomSheet(
                                    //   context,
                                    //   cubit.vendorList ?? [],
                                    // );

                                    if (selectedVendors != null) {
                                      setState(() {
                                        cubit.selectedVendorList =
                                            selectedVendors;
                                        printf("${cubit.selectedVendor}");
                                      });
                                      // cubit.countryName = country.name ?? "";
                                      // cubit.countryFlag = country.emoji ?? "";
                                    }

                                    // if (vendor != null) {
                                    //   setState(() {
                                    //     cubit.selectedVendor = vendor;
                                    //     printf("${cubit.selectedVendor}");
                                    //   });
                                    //   // cubit.countryName = country.name ?? "";
                                    //   // cubit.countryFlag = country.emoji ?? "";
                                    // }
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 16, vertical: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      border:
                                          Border.all(color: AppColors.greyE8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              cubit.selectedVendorList
                                                      .isNotEmpty
                                                  ? cubit.selectedVendorList
                                                      .map((vendor) =>
                                                          vendor.title ?? "")
                                                      .join(
                                                          ", ") // Joins titles with a comma
                                                  : appStrings(context)
                                                          .lblSelectVendor ??
                                                      "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SVGAssets.arrowDownIcon
                                            .toSvg(context: context),
                                      ],
                                    ),
                                  ),
                                ),
                                12.verticalSpace,
                              ],
                            ).showIf(
                                cubit.selectedUserRole == AppStrings.vendor),
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

                            /// Website Link widget
                            ///
                            MyTextFormField(
                              fieldName: appStrings(context).lblWebsiteLink,
                              controller: cubit.websiteLinkCtl,
                              focusNode: cubit.websiteLinkFn,
                              isMandatory: false,
                              maxLines: 2,
                              // inputFormatters: [InputFormatters().emailInputFormatter],
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                // InputFormatters().urlInputFormatter,
                              ],
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
  void buildBlocListener(BuildContext context, CompleteProfileState state) {
    if (state is CompleteProfileLoading) {
      // OverlayLoadingProgress.start(context);
    } else if (state is CompleteProfileSuccess) {
    } else if (state is CompleteProfileError) {
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
    if (cubit.selectedUserRole == AppStrings.vendor &&
        cubit.selectedVendorList.isEmpty) {
      Utils.showErrorMessage(
          context: context, message: appStrings(context).vendorTypeEmptyError);
      return false;
    }

    return true;
  }

  /// Vendors Type Bottom Sheet
  ///
  Future<List<VendorListData>?> showVendorsBottomSheet(
      BuildContext context, List<VendorListData> vendors) {
    CompleteProfileCubit cubit = context.read<CompleteProfileCubit>();
    final itemCount = vendors.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<List<VendorListData>?>(
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
                  Text(
                    appStrings(context).lblSelectVendor ?? "",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black3D.forLightMode(context)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(
                          context,
                          cubit.selectedVendorList.isEmpty
                              ? null
                              : cubit
                                  .selectedVendorList); // Return null if no vendors selected
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
                      final vendor = vendors[index];
                      return InkWell(
                        onTap: () {
                          cubit.selectedVendorList.clear();
                          cubit.selectedVendorList.add(vendor);

                          print(cubit.selectedVendorList.length);
                          Navigator.pop(
                              context,
                              cubit
                                  .selectedVendorList); // Close sheet with selected vendor
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                vendor.title ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppColors.black14
                                          .forLightMode(context),
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
                      itemCount: vendors.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final vendor = vendors[index];
                        return InkWell(
                          onTap: () {
                            cubit.selectedVendorList.clear();
                            cubit.selectedVendorList.add(vendor);
                            print(cubit.selectedVendorList.length);
                            Navigator.pop(
                                context,
                                cubit
                                    .selectedVendorList); // Close sheet with selected vendor
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  vendor.title ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.black14
                                            .forLightMode(context),
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
    if (context.read<CompleteProfileCubit>().selectedUserRole ==
        AppStrings.vendor) {
      if (formKey.currentState!.validate() && validate(context)) {
        context.pushNamed(Routes.kCompleteProfile3Screen);
      }
    } else {
      if (formKey.currentState!.validate()) {
        context.pushNamed(Routes.kCompleteProfile3Screen);
      }
    }
  }
}
