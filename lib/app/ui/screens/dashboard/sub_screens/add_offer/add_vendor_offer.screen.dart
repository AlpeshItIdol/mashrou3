import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/model/property/currency_list_response_model.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/component/country_bottomsheet_widget.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../model/offers/my_offers_list_response_model.dart';
import '../../../../custom_widget/app_bar_mixin.dart';
import '../../../../custom_widget/file_picker_widget/cubit/file_picker_cubit.dart';
import '../../../../custom_widget/file_picker_widget/file_picker_widget.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../../custom_widget/text_form_fields/my_text_form_field.dart';
import '../my_offers_list/cubit/my_offers_list_cubit.dart';
import 'cubit/add_vendor_cubit.dart';

class AddVendorOfferScreen extends StatefulWidget {
  final OfferData offerDataModel;

  const AddVendorOfferScreen({super.key, required this.offerDataModel});

  @override
  State<AddVendorOfferScreen> createState() => _AddVendorOfferScreenState();
}

class _AddVendorOfferScreenState extends State<AddVendorOfferScreen>
    with AppBarMixin {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    formKey.currentState?.reset();

    super.initState();
    context.read<AddVendorOfferCubit>().getData(context, widget.offerDataModel);
  }

  @override
  Widget build(BuildContext context) {
    AddVendorOfferCubit cubit = context.read<AddVendorOfferCubit>();
    return BlocConsumer<AddVendorOfferCubit, AddVendorOfferState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                  title: cubit.isUpdate
                      ? appStrings(context).lblUpdateOffer
                      : appStrings(context).lblCreateOffers,
                  context: context,
                  requireLeading: true),
              bottomNavigationBar: UIComponent.customInkWellWidget(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (cubit.isUpdate) {
                      cubit.updateOffer(
                          context, widget.offerDataModel.sId ?? "");
                    } else {
                      cubit.submitAddOffer();
                    }
                  }
                },
                child: Container(
                  height: 90,
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SVGAssets.myOfferIcon.toSvg(
                                      context: context,
                                      color: AppColors.colorLightPrimary),
                                  6.horizontalSpace,
                                  Text(
                                    cubit.isUpdate
                                        ? appStrings(context).lblUpdateOffer
                                        : appStrings(context).addOffer,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.colorLightPrimary),
                                  ),
                                ],
                              ),
                              SVGAssets.arrowRightIcon.toSvg(
                                  context: context,
                                  color: AppColors.colorLightPrimary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                              /// Offer Title widget
                              ///
                              MyTextFormField(
                                fieldName: appStrings(context).lblOfferTitle,
                                controller: cubit.titleCtl,
                                focusNode: cubit.titleFn,
                                isMandatory: true,
                                maxLines: 2,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context)
                                      .requestFocus(cubit.arabicTitleFn);
                                },
                                readOnly: false,
                                inputFormatters: [
                                  InputFormatters().emojiRestrictInputFormatter,
                                ],
                                obscureText: false,
                                validator: (value) {
                                  return validateOfferTitle(context, value);
                                },
                              ),
                              12.verticalSpace,
                              MyTextFormField(
                                fieldName: appStrings(context).lblOfferArabicTitle,
                                controller: cubit.arabicTitleCtl,
                                focusNode: cubit.arabicTitleFn,
                                isMandatory: true,
                                maxLines: 2,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context)
                                      .requestFocus(cubit.costFn);
                                },
                                readOnly: false,
                                inputFormatters: [
                                  InputFormatters().emojiRestrictInputFormatter,
                                ],
                                obscureText: false,
                                validator: (value) {
                                  return validateOfferTitle(context, value);
                                },
                              ),
                              12.verticalSpace,

                              /// Offer Cost widget
                              ///
                              UIComponent.mandatoryLabel(
                                  context: context,
                                  label: appStrings(context).lblOfferCost),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          5.verticalSpace,
                                          InkWell(
                                            onTap: () async {
                                              final currency =
                                                  await showCurrencyBottomSheet(
                                                      context: context,
                                                      currency:
                                                          cubit.currencyList ??
                                                              []);

                                              if (currency != null) {
                                                setState(() {
                                                  cubit.selectedCurrency =
                                                      currency;
                                                  printf(
                                                      "${cubit.selectedCurrency.currencyName} - ${cubit.selectedCurrency.currencySymbol}");
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16)),
                                                border: Border.all(
                                                    color: AppColors.greyE8
                                                        .adaptiveColor(context,
                                                            lightModeColor:
                                                                AppColors
                                                                    .greyE8,
                                                            darkModeColor:
                                                                AppColors
                                                                    .black2E)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    child: Text(
                                                      cubit.selectedCurrency
                                                              .currencySymbol ??
                                                          'د.أ',
                                                      // Display selected flag emoji
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                              color: AppColors
                                                                  .black14
                                                                  .adaptiveColor(
                                                                context,
                                                                lightModeColor:
                                                                    AppColors
                                                                        .black14,
                                                                darkModeColor:
                                                                    AppColors
                                                                        .white,
                                                              )),
                                                    ),
                                                  ),
                                                  SVGAssets.arrowDownIcon.toSvg(
                                                      context: context,
                                                      color: Theme.of(context)
                                                          .focusColor),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  10.horizontalSpace,
                                  Expanded(
                                    flex: 9,
                                    child: MyTextFormField(
                                      controller: cubit.costCtl,
                                      focusNode: cubit.costFn,
                                      isMandatory: true,
                                      isShowFieldName: false,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      inputFormatters: [
                                        InputFormatters().twoDecimalRestrict,
                                      ],
                                      readOnly: false,
                                      obscureText: false,
                                      validator: (value) {
                                        return validateOfferCost(
                                            context, value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              12.verticalSpace,

                              /// Upload Documents widget
                              ///
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appStrings(context).lblPortfolio,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              color: AppColors.black3D
                                                  .adaptiveColor(context,
                                                      lightModeColor:
                                                          AppColors.black3D,
                                                      darkModeColor:
                                                          AppColors.greyB0))),
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
                                            final imageList =
                                                cubit.documentsList;
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
                              12.verticalSpace,

                              /// Description field
                              ///
                              MyTextFormField(
                                fieldName: appStrings(context).lblDescription,
                                controller: cubit.descriptionCtl,
                                focusNode: cubit.descriptionFn,
                                isMandatory: true,
                                maxLines: null,
                                minLines: 5,
                                keyboardType: TextInputType.multiline,
                                onFieldSubmitted: (v) {
                                  // FocusScope.of(context).requestFocus(cubit.addressFn);
                                },
                                inputFormatters: [
                                  InputFormatters().emojiRestrictInputFormatter,
                                ],
                                textInputAction: TextInputAction.newline,
                                readOnly: false,
                                obscureText: false,
                                validator: (value) {
                                  return validateDescriptionField(
                                      context, value);
                                },
                              ),
                              MyTextFormField(
                                fieldName: appStrings(context).lblDescriptionArabic,
                                controller: cubit.arabicDescriptionCtl,
                                focusNode: cubit.arabicDescriptionFn,
                                isMandatory: true,
                                maxLines: null,
                                minLines: 5,
                                keyboardType: TextInputType.multiline,
                                onFieldSubmitted: (v) {
                                  // FocusScope.of(context).requestFocus(cubit.addressFn);
                                },
                                inputFormatters: [
                                  InputFormatters().emojiRestrictInputFormatter,
                                ],
                                textInputAction: TextInputAction.newline,
                                readOnly: false,
                                obscureText: false,
                                validator: (value) {
                                  return validateDescriptionField(
                                      context, value);
                                },
                              ),
                              12.verticalSpace,
                            ],
                          ),
                        ),
                      ]),
                ),
              ));
        });
  }

  Future<CurrencyListData?> showCurrencyBottomSheet(
      {required BuildContext context,
      required List<CurrencyListData> currency}) {
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
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
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
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 14.0),
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
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 14.0),
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

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, AddVendorOfferState state) async {
    if (state is SubmitOfferLoading || state is GetOfferDetailsLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is SubmitOfferSuccess) {
      OverlayLoadingProgress.stop();
      await context.read<MyOffersListCubit>().updateTabIndex(1);
      context.pop(true);
      Utils.snackBar(context: context, message: state.message);
    } else if (state is UpdateOfferSuccess) {
      OverlayLoadingProgress.stop();
      context.pop(true);
      Utils.snackBar(context: context, message: state.message);
    } else if (state is GetOfferDetailsLoaded) {
      OverlayLoadingProgress.stop();
    } else if (state is GetOfferDataLoaded) {
    } else if (state is SubmitOfferFailure) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
