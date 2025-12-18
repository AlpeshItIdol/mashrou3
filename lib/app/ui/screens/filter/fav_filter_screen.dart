import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/model/city_list_response_model.dart';
import 'package:mashrou3/app/model/country_list_model.dart';
import 'package:mashrou3/app/model/property/currency_list_response_model.dart';
import 'package:mashrou3/app/model/property/property_category_response_model.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/common_row_bottons.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/component/country_bottomsheet_widget.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/select_country_cubit.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/select_country_selection_widget.dart';
import 'package:mashrou3/app/ui/screens/filter/cubit/fav_filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_status_list_response_model.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';
import 'package:mashrou3/utils/location_manager.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:mashrou3/utils/validators.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../custom_widget/bottom_sheet_with_pagination/bottom_sheet_with_pagination.dart';
import 'filter_screen.dart';

class FavFilterScreen extends StatefulWidget {
  const FavFilterScreen({super.key});

  @override
  State<FavFilterScreen> createState() => _FavFilterScreenState();
}

class _FavFilterScreenState extends State<FavFilterScreen> with AppBarMixin {
  List<String> underConstruction = [];
  bool isSnackbarVisible = false;

  @override
  void initState() {
    context.read<FavFilterCubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavFilterCubit, FavFilterState>(
      listener: (context, state) {
        // Check if the state is one of the failure states
        if (state is FavFilterStatusFailure ||
            state is FavFilterCurrencyFailure ||
            state is FavFilterCountryFailure ||
            state is FavFilterCityFailure ||
            state is FavFilterNeighbourhoodFailure) {
          String errorMessage = '';

          if (state is FavFilterStatusFailure) {
            errorMessage = state.errorMessage;
          } else if (state is FavFilterCurrencyFailure) {
            errorMessage = state.errorMessage;
          } else if (state is FavFilterCountryFailure) {
            errorMessage = state.errorMessage;
          } else if (state is FavFilterCityFailure) {
            errorMessage = state.errorMessage;
          } else if (state is FavFilterNeighbourhoodFailure) {
            errorMessage = state.errorMessage;
          }

          if (!isSnackbarVisible && errorMessage.contains('No internet')) {
            Utils.showErrorMessage(
              context: context,
              message: appStrings(context).noInternetConnection,
            );
            isSnackbarVisible = true;
          } else if (errorMessage.isNotEmpty) {
            Utils.showErrorMessage(
              context: context,
              message: errorMessage,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(
              context: context,
              requireLeading: true,
              title: appStrings(context).filter),
          bottomNavigationBar: ButtonRow(
            leftButtonText: appStrings(context).clearFilter,
            rightButtonText: appStrings(context).applyFilter,
            onLeftButtonTap: () {
              context.read<FavFilterCubit>().clearFilters(context);
              context.pop();
            },
            onRightButtonTap: () async {
              if (validateFilters(context)) {
                if (!context.mounted) return;
                context.read<FavFilterCubit>().applyFilter(context);
                Navigator.pop(context);
              }
            },
            leftButtonBgColor: Theme.of(context).cardColor,
            leftButtonBorderColor: Theme.of(context).primaryColor,
            leftButtonTextColor: Theme.of(context).primaryColor,
            isLeftButtonGradient: false,
            isLeftButtonBorderRequired: true,
          ),
          body: _buildBlocConsumer,
        );
      },
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    var cubit = context.read<FavFilterCubit>();
    return BlocConsumer<FavFilterCubit, FavFilterState>(
      listener: buildBlocListener,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                30.verticalSpace,

                /// Range Slider
                buildFilterComponent('radius'),

                /// Under Construction
                buildFilterComponent('underConstruction'),

                // /// Property Furnished status
                // buildFilterComponent("furnished"),

                /// Virtual Tour
                buildFilterComponent("virtualTour"),

                /// Country selection widget
                buildFilterComponent("country"),

                /// City Widget
                buildFilterComponent("city"),

                /// Neighborhood Multi Selection Widget
                buildFilterComponent("neighborhood"),

                /// Sold Out
                buildFilterComponent("isSold").hideIf(cubit.isVendor),

                /// Leasing Company
                buildFilterComponent("leasingCompany"),

                /// Price
                buildFilterComponent("price"),

                /// Area
                buildFilterComponent("area"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget radiusSliderWithLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(
          text: appStrings(context).selectRadius,
          textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.black14.adaptiveColor(
                context,
                lightModeColor: AppColors.black14,
                darkModeColor: AppColors.greyB0,
              )),
        ),
        8.verticalSpace,
        radiusSliderWidget(context: context),
        18.verticalSpace,
      ],
    );
  }

  Widget underConstructionFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(text: appStrings(context).underConstruction),
        5.verticalSpace,
        InkWell(
          onTap: () async {
            final status = await showCustomBottomSheet(
                context,
                appStrings(context).underConstructionStatus,
                getYesNoData(context));

            if (status != null) {
              setState(() {
                cubit.selectedConstructionStatus = status;
                printf(cubit.selectedConstructionStatus);
              });
            }
          },
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                  color: AppColors.greyE8.adaptiveColor(context,
                      lightModeColor: AppColors.greyE8,
                      darkModeColor: AppColors.black2E)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlocListener<FavFilterCubit, FavFilterState>(
                      listener: (context, state) {},
                      child: Text(
                        cubit.selectedConstructionStatus ??
                            appStrings(context).select,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: cubit.selectedConstructionStatus != null
                                ? Theme.of(context).primaryColor
                                : AppColors.black14.adaptiveColor(context,
                                    lightModeColor: AppColors.black14,
                                    darkModeColor: AppColors.grey77),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SVGAssets.arrowDownIcon.toSvg(
                    context: context, color: Theme.of(context).highlightColor),
              ],
            ),
          ),
        ),
        18.verticalSpace,
      ],
    );
  }

  Widget priceValueComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(text: appStrings(context).lblCurrency),
        5.verticalSpace,
        InkWell(
          onTap: () async {
            final currency = await showCurrencyBottomSheet(
              context: context,
              currency: cubit.currencyList ?? [],
            );

            if (currency != null) {
              setState(() {
                cubit.selectedCurrency = currency;
                printf("${cubit.selectedCurrency}");
              });
            }
          },
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                  color: AppColors.greyE8.adaptiveColor(context,
                      lightModeColor: AppColors.greyE8,
                      darkModeColor: AppColors.black2E)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlocListener<FavFilterCubit, FavFilterState>(
                      listener: (context, state) {},
                      child: Text(
                        cubit.selectedCurrency.currencySymbol ??
                            appStrings(context).select,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: cubit.selectedCurrency.currencySymbol != null
                                ? Theme.of(context).primaryColor
                                : AppColors.black14.adaptiveColor(context,
                                    lightModeColor: AppColors.black14,
                                    darkModeColor: AppColors.grey77),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SVGAssets.arrowDownIcon.toSvg(
                    context: context, color: Theme.of(context).highlightColor),
              ],
            ),
          ),
        ),
        18.verticalSpace,
      ],
    );
  }

  Widget virtualTourFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(text: appStrings(context).threeDTour),
        5.verticalSpace,
        InkWell(
          onTap: () async {
            final status = await showCustomBottomSheet(
                context,
                appStrings(context).underConstructionStatus,
                getYesNoData(context));

            if (status != null) {
              setState(() {
                cubit.selectedVirtualTourStatus = status;
                printf(cubit.selectedVirtualTourStatus);
              });
            }
          },
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                  color: AppColors.greyE8.adaptiveColor(context,
                      lightModeColor: AppColors.greyE8,
                      darkModeColor: AppColors.black2E)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlocListener<FavFilterCubit, FavFilterState>(
                      listener: (context, state) {},
                      child: Text(
                        cubit.selectedVirtualTourStatus ??
                            appStrings(context).select,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: cubit.selectedVirtualTourStatus != null
                                ? Theme.of(context).primaryColor
                                : AppColors.black14.adaptiveColor(context,
                                    lightModeColor: AppColors.black14,
                                    darkModeColor: AppColors.grey77),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SVGAssets.arrowDownIcon.toSvg(
                    context: context, color: Theme.of(context).highlightColor),
              ],
            ),
          ),
        ),
        18.verticalSpace,
      ],
    );
  }

  Widget countrySelectionFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocListener<SelectCountryCubit, SelectCountryState>(
            listener: (context, state) {
              if (state is CountrySelectionUpdated) {
                cubit.selectedCountry.name = state.country.name;
                cubit.selectedCountryId = state.country.sId ?? "0";
                cubit.isSelectedCountry = true;
                setState(() {});
              } else if (state is CountryDetailsLoaded) {
                printf("New - ");
              }
            },
            child: BlocListener<FavFilterCubit, FavFilterState>(
              listener: (context, state) {},
              child: SelectCountrySelectionWidget(
                initialCountry: cubit.selectedCountry,
              ),
            )),
        18.verticalSpace,
      ],
    );
  }

  Widget citySelectionFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return BlocListener<FavFilterCubit, FavFilterState>(
      listener: (context, state) {},
      child: BlocListener<SelectCountryCubit, SelectCountryState>(
        listener: (context, state) {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(text: appStrings(context).lblCity),
            5.verticalSpace,
            InkWell(
              onTap: cubit.isSelectedCountry == true
                  ? () async {
                      // if (cubit.selectedCountryId.isNotEmpty) {
                      //   context
                      //       .pushNamed(Routes.kCityListScreen,
                      //           extra: cubit.selectedCountryId)
                      //       .then((value) {
                      //     if (value != null) {
                      //       setState(() {
                      //         cubit.selectedCity = value as Cities;
                      //         cubit.selectedCity.name =
                      //             cubit.selectedCity.name ?? "";
                      //         printf("${cubit.selectedCity}");
                      //       });
                      //     }
                      //   });
                      // }
                      final city = await showModalBottomSheet<Cities>(
                        context: context,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        builder: (_) => CityListBottomSheet(
                          selectedCountryId: cubit.selectedCountryId ?? "",
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
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: cubit.isSelectedCountry == true
                      ? AppColors.white.adaptiveColor(context,
                          lightModeColor: AppColors.white,
                          darkModeColor: AppColors.black14)
                      : AppColors.greyF1.adaptiveColor(context,
                          lightModeColor: AppColors.greyF1,
                          darkModeColor: AppColors.black48),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(
                      color: cubit.isSelectedCountry == true
                          ? AppColors.greyE9.adaptiveColor(context,
                              lightModeColor: AppColors.greyE9,
                              darkModeColor: AppColors.black2E)
                          : AppColors.greyF1.adaptiveColor(context,
                              lightModeColor: AppColors.greyF1,
                              darkModeColor: AppColors.black2E)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          cubit.selectedCity.name ?? appStrings(context).select,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: cubit.isSelectedCountry == true
                                      ? Theme.of(context).primaryColor
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
                            : Theme.of(context).primaryColor.withOpacity(0.5)),
                  ],
                ),
              ),
            ),
            18.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget neighborhoodFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(text: appStrings(context).propertyNeighborhoodType),
        6.verticalSpace,
        BlocListener<FavFilterCubit, FavFilterState>(
          listener: (context, state) {},
          child: BlocBuilder<FavFilterCubit, FavFilterState>(
            builder: (context, state) {
              return ExpansionTile(
                  collapsedShape: ContinuousRectangleBorder(
                      side: BorderSide(
                          color: AppColors.greyE9.adaptiveColor(context,
                              lightModeColor: AppColors.greyE9,
                              darkModeColor: AppColors.black2E),
                          width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  shape: ContinuousRectangleBorder(
                      side: BorderSide(
                          color: AppColors.greyE9.adaptiveColor(context,
                              lightModeColor: AppColors.greyE9,
                              darkModeColor: AppColors.black2E),
                          width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  title: Text(
                    appStrings(context).select,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.grey77, fontWeight: FontWeight.w400),
                  ),
                  initiallyExpanded: false,
                  dense: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(
                          color: AppColors.greyE9.adaptiveColor(context,
                              lightModeColor: AppColors.greyE9,
                              darkModeColor: AppColors.black2E)),
                    ),
                    ListView.separated(
                      itemCount: cubit.neighborhoodTypes.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final neighbourhood = cubit.neighborhoodTypes[index];
                        final isSelected = cubit.selectedNeighborhoodTypes
                            .contains(neighbourhood);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                cubit.selectedNeighborhoodTypes
                                    .remove(neighbourhood);
                              } else {
                                cubit.selectedNeighborhoodTypes
                                    .add(neighbourhood);
                              }
                            });

                            (context as Element).markNeedsBuild();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                isSelected
                                    ? SVGAssets.checkboxEnableIcon.toSvg(
                                        height: 18, width: 18, context: context)
                                    : SVGAssets.checkboxDisableIcon.toSvg(
                                        height: 18,
                                        width: 18,
                                        context: context),
                                10.horizontalSpace,
                                Flexible(
                                  child: Text(neighbourhood.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: AppColors.black14
                                                .forLightMode(context),
                                          )),
                                )
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
                                darkModeColor: AppColors.black2E),
                          ),
                        );
                      },
                    ),
                  ]);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            top: 6,
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: cubit.selectedNeighborhoodTypes.map((amenity) {
              return Chip(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 4, vertical: 2),
                backgroundColor: AppColors.colorBgPrimary.adaptiveColor(context,
                    lightModeColor: AppColors.colorBgPrimary,
                    darkModeColor: AppColors.black2E),
                side: BorderSide(
                  color: AppColors.colorBgPrimary.adaptiveColor(
                    context,
                    lightModeColor: AppColors.colorBgPrimary,
                    darkModeColor: AppColors.black2E,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                iconTheme: IconThemeData(
                  color: Theme.of(context)
                      .highlightColor, // Set the delete icon color to red
                ),
                label: Text(
                  amenity.name ?? "",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.colorPrimary.adaptiveColor(context,
                          lightModeColor: AppColors.colorPrimary,
                          darkModeColor: AppColors.white),
                      fontWeight: FontWeight.w400),
                ),
                onDeleted: () {
                  setState(() {
                    cubit.selectedNeighborhoodTypes.remove(amenity);
                    printf("${cubit.selectedNeighborhoodTypes}");
                  });
                },
              );
            }).toList(),
          ),
        ).showIf(cubit.selectedNeighborhoodTypes.isNotEmpty),
        16.verticalSpace,
      ],
    );
  }

  Widget bankLeasingFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(text: appStrings(context).bankLeaseCompany),
        5.verticalSpace,
        UIComponent.customInkWellWidget(
          onTap: () async {
            final status = await showCustomBottomSheet(
                context,
                "${appStrings(context).select} ${appStrings(context).bankLeaseCompany}",
                getYesNoData(context));

            if (status != null) {
              setState(() {
                cubit.selectedBankLeasingStatus = status;
                printf(cubit.selectedBankLeasingStatus);
              });
            }
          },
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                  color: AppColors.greyE8.adaptiveColor(context,
                      lightModeColor: AppColors.greyE8,
                      darkModeColor: AppColors.black2E)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlocListener<FavFilterCubit, FavFilterState>(
                      listener: (context, state) {},
                      child: Text(
                        cubit.selectedBankLeasingStatus ??
                            appStrings(context).select,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: cubit.selectedBankLeasingStatus != null
                                ? Theme.of(context).primaryColor
                                : AppColors.black14.adaptiveColor(context,
                                    lightModeColor: AppColors.black14,
                                    darkModeColor: AppColors.grey77),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SVGAssets.arrowDownIcon.toSvg(
                    context: context, color: Theme.of(context).highlightColor),
              ],
            ),
          ),
        ),
        18.verticalSpace,
      ],
    );
  }

  Widget soldOutFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(text: appStrings(context).soldOut),
        5.verticalSpace,
        UIComponent.customInkWellWidget(
          onTap: () async {
            final status = await showCustomBottomSheet(
                context,
                "${appStrings(context).select} ${appStrings(context).soldOut}",
                getYesNoData(context));

            if (status != null) {
              setState(() {
                cubit.selectedIsSoldOutStatus = status;
                printf(cubit.selectedIsSoldOutStatus);
              });
            }
          },
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                  color: AppColors.greyE8.adaptiveColor(context,
                      lightModeColor: AppColors.greyE8,
                      darkModeColor: AppColors.black2E)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlocListener<FavFilterCubit, FavFilterState>(
                      listener: (context, state) {},
                      child: Text(
                        cubit.selectedIsSoldOutStatus ??
                            appStrings(context).select,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: cubit.selectedIsSoldOutStatus != null
                                ? Theme.of(context).primaryColor
                                : AppColors.black14.adaptiveColor(context,
                                    lightModeColor: AppColors.black14,
                                    darkModeColor: AppColors.grey77),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SVGAssets.arrowDownIcon.toSvg(
                    context: context, color: Theme.of(context).highlightColor),
              ],
            ),
          ),
        ),
        18.verticalSpace,
      ],
    );
  }

  Widget priceFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        priceValueComponent(context),
        CustomTextLabel(text: appStrings(context).price),
        5.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: MyTextFormField(
                controller: cubit.priceStartCtl,
                focusNode: cubit.priceStartFn,
                isMandatory: false,
                fieldHint: appStrings(context).from,
                isShowFieldName: false,
                keyboardType: const TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  InputFormatters().emojiRestrictInputFormatter,
                  InputFormatters().numberInputFormatterWithoutDot,
                ],
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(cubit.priceEndFn);
                },
                onChanged: (val) {
                  validatePriceFields(context);
                },
                isDisable: false,
                validator: (value) => validatePriceRange(
                  context,
                  value,
                  cubit.priceEndCtl.text,
                  isStartField: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 12,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.black3D.adaptiveColor(context,
                      lightModeColor: AppColors.black3D,
                      darkModeColor: AppColors.greyB0),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ).hide(),
            18.horizontalSpace,
            Expanded(
              flex: 1,
              child: MyTextFormField(
                controller: cubit.priceEndCtl,
                focusNode: cubit.priceEndFn,
                isMandatory: false,
                isShowFieldName: false,
                fieldHint: appStrings(context).to,
                keyboardType: const TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  InputFormatters().emojiRestrictInputFormatter,
                  InputFormatters().numberInputFormatterWithoutDot,
                ],
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (val) {
                  validatePriceFields(context);
                },
                isDisable: false,
                validator: (value) => validatePriceRange(
                  context,
                  cubit.priceStartCtl.text,
                  value,
                  isStartField: false,
                ),
              ),
            ),
          ],
        ),
        18.verticalSpace,
      ],
    );
  }

  Widget areaFilterComponent(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIComponent.titleWithUnit(
            context: context,
            fieldName: appStrings(context).area,
            fieldMetricValue: 'Sq. Meter'),
        5.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: MyTextFormField(
                controller: cubit.areaStartCtl,
                focusNode: cubit.areaStartFn,
                isMandatory: false,
                isShowFieldName: false,
                fieldHint: appStrings(context).from,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  InputFormatters().emojiRestrictInputFormatter,
                  InputFormatters().twoDecimalRestrict,
                  NoLeadingDotInputFormatter()
                ],
                onFieldSubmitted: (v) {},
                onChanged: (val) {
                  validateAreaFields(context);
                },
                isDisable: false,
                validator: (value) => validatePriceRange(
                  context,
                  value,
                  cubit.areaEndCtl.text,
                  isStartField: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 12,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.black3D.adaptiveColor(context,
                      lightModeColor: AppColors.black3D,
                      darkModeColor: AppColors.greyB0),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ).hide(),
            18.horizontalSpace,
            Expanded(
              flex: 1,
              child: MyTextFormField(
                controller: cubit.areaEndCtl,
                focusNode: cubit.areaEndFn,
                isMandatory: false,
                isShowFieldName: false,
                fieldHint: appStrings(context).to,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  InputFormatters().emojiRestrictInputFormatter,
                  InputFormatters().twoDecimalRestrict,
                  NoLeadingDotInputFormatter()
                ],
                onFieldSubmitted: (v) {},
                onChanged: (val) {
                  validateAreaFields(context);
                },
                isDisable: false,
                validator: (value) => validatePriceRange(
                  context,
                  cubit.areaStartCtl.text,
                  value,
                  isStartField: false,
                ),
              ),
            ),
          ],
        ),
        18.verticalSpace,
      ],
    );
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(BuildContext context, FavFilterState state) {}

  Widget buildFilterComponent(String key) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    FilterStatusData? filter =
        context.read<FavFilterCubit>().filterStatusList?.firstWhere(
              (f) => f.key == key && f.isActive == true,
              orElse: () => FilterStatusData(
                  title: '', filterType: '', key: '', isActive: false),
            );

    if (filter == null || filter.isActive == null || !filter.isActive!) {
      switch (key) {
        case 'radius':
          cubit.filterRadiusValue = 0;
          return const SizedBox.shrink();
        case 'underConstruction':
          cubit.selectedConstructionStatus = null;
          return const SizedBox.shrink();
        case 'furnished':
          cubit.selectedFurnishedStatus = PropertyCategoryData();
          return const SizedBox.shrink();
        case 'virtualTour':
          cubit.selectedVirtualTourStatus = null;
          return const SizedBox.shrink();
        case 'country' || 'city':
          cubit.selectedCountryId = "";
          cubit.selectedCountry = CountryListData();
          cubit.isSelectedCountry = false;
          context.read<SelectCountryCubit>().resetToDefault();
          cubit.selectedCity = Cities(name: null, sId: null);
          return const SizedBox.shrink();
        case 'neighborhood':
          cubit.selectedNeighborhoodTypes = [];
          return const SizedBox.shrink();
        case 'isSold':
          cubit.selectedIsSoldOutStatus = null;
          return const SizedBox.shrink();
        case 'leasingCompany':
          cubit.selectedBankLeasingStatus = null;
          return const SizedBox.shrink();
        case 'leasingCompany':
          return const SizedBox.shrink();
        case 'price':
          cubit.priceStartCtl.clear();
          cubit.priceEndCtl.clear();
          return const SizedBox.shrink();
        case 'area':
          cubit.areaStartCtl.clear();
          cubit.areaEndCtl.clear();
          return const SizedBox.shrink();
        default:
          return const SizedBox.shrink();
      }
    }

    switch (key) {
      case 'radius':
        return radiusSliderWithLabel(context);
      case 'underConstruction':
        return underConstructionFilterComponent(context);
      // case 'furnished':
      //   return furnishedFilterComponent(context);
      case 'virtualTour':
        return virtualTourFilterComponent(context);
      case 'country':
        return countrySelectionFilterComponent(context);
      case 'city':
        return citySelectionFilterComponent(context);
      case 'neighborhood':
        return neighborhoodFilterComponent(context);
      case 'isSold':
        return soldOutFilterComponent(context);
      case 'leasingCompany':
        return bankLeasingFilterComponent(context);
      case 'price':
        return priceFilterComponent(context);
      case 'area':
        return areaFilterComponent(context);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Fixed  Data
  List<String> getYesNoData(BuildContext context) {
    return [
      appStrings(context).yes,
      appStrings(context).no,
    ];
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

  /// Reusable BottomSheet
  Future<String?> showCustomBottomSheet(
      BuildContext context, String title, List<String> dataList) {
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
                  Text(title,
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          dataList[index],
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
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
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                  child: Divider(
                    height: 1,
                    color: AppColors.greyE8.adaptiveColor(context,
                        lightModeColor: AppColors.greyE8,
                        darkModeColor: AppColors.grey50),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  bool validateFilters(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();

    for (var filter in cubit.filterStatusList ?? []) {
      if (filter.isActive == true) {
        switch (filter.key) {
          case 'price':
            if (!validatePriceFields(context)) {
              return false;
            }
            break;
          case 'area':
            if (!validateAreaFields(context)) {
              return false;
            }
            break;
          default:
            break;
        }
      }
    }
    return true;
  }

  bool validatePriceFields(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();

    // Trigger validation for both fields
    var startValidation = validatePriceRange(
      context,
      cubit.priceStartCtl.text,
      cubit.priceEndCtl.text,
      isStartField: true,
    );

    var endValidation = validatePriceRange(
      context,
      cubit.priceStartCtl.text,
      cubit.priceEndCtl.text,
      isStartField: false,
    );

    setState(() {});
    return startValidation == null && endValidation == null;
  }

  bool validateAreaFields(BuildContext context) {
    FavFilterCubit cubit = context.read<FavFilterCubit>();
    final isAreaValid = validatePriceRange(
              context,
              cubit.areaStartCtl.text,
              cubit.areaEndCtl.text,
              isStartField: true,
            ) ==
            null &&
        validatePriceRange(
              context,
              cubit.areaStartCtl.text,
              cubit.areaEndCtl.text,
              isStartField: false,
            ) ==
            null;
    setState(() {});
    return isAreaValid;
  }
}

Widget radiusSliderWidget({required BuildContext context}) {
  return BlocBuilder<FavFilterCubit, FavFilterState>(
    builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          4.verticalSpace,
          Text(
            localizedDistanceText(
                context, context.read<FavFilterCubit>().filterRadiusValue),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w400),
          ),
          4.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: SfSliderTheme(
              data: SfSliderThemeData(
                minorTickSize: const Size(0, 0),
                activeTrackHeight: 10,
                overlayRadius: 18,
                inactiveTrackHeight: 10,
                trackCornerRadius: 5,
                thumbStrokeWidth: 2,
                thumbStrokeColor: AppColors.greyE8.adaptiveColor(context,
                    lightModeColor: AppColors.greyE8,
                    darkModeColor: AppColors.grey50),
              ),
              child: Padding(
                padding: EdgeInsets.zero,
                child: SfSlider(
                  min: 0,
                  max: 100,
                  value: context.read<FavFilterCubit>().filterRadiusValue,
                  interval: 20,
                  stepSize: 20,
                  showDividers: false,
                  showLabels: true,
                  activeColor: AppColors.colorPrimary,
                  inactiveColor: AppColors.colorPrimaryIceShade,
                  enableTooltip: false,
                  thumbIcon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  minorTicksPerInterval: 20,
                  onChanged: (dynamic value) async {
                    await LocationManager.checkForPermission();
                    if (!context.mounted) return;
                    context
                        .read<FavFilterCubit>()
                        .updateFilterRadius(value.toInt());
                  },
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
