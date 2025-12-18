import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../../utils/app_localization.dart';
import '../../../../../utils/debouncer.dart';
import '../../../../../utils/input_formatters.dart';
import '../../../../model/country_list_model.dart';
import '../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../custom_widget/text_form_fields/search_text_form_field.dart';
import 'bloc/country_selection_cubit.dart';
import 'country_bottomsheet_widget/country_bottomsheet_widget.dart';

class CountrySelectionWidget extends StatefulWidget {
  const CountrySelectionWidget({
    super.key,
  });

  @override
  State<CountrySelectionWidget> createState() => _CountrySelectionWidgetState();
}

class _CountrySelectionWidgetState extends State<CountrySelectionWidget> {
  final _debouncer = Debouncer(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    context.read<CountrySelectionCubit>().resetToDefault();
    // context.read<CountrySelectionCubit>().getCountryList(context);
  }

  void filterCountries(String query) {
    setState(() {
      context.read<CountrySelectionCubit>().filteredCountries = context
          .read<CountrySelectionCubit>()
          .countryList!
          .where((country) =>
              country.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    CountrySelectionCubit cubit = context.read<CountrySelectionCubit>();
    return BlocConsumer<CountrySelectionCubit, CountrySelectionState>(
      listener: (context, state) {
        if (state is CountrySelectionUpdated) {
          printf(state.country);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0)),
              child: Text(
                appStrings(context).lblSelectCountry,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black3D.adaptiveColor(context,
                        lightModeColor: AppColors.black3D,
                        darkModeColor: AppColors.greyB0)),
              ),
            ),
            5.verticalSpace,
            InkWell(
              onTap: () async {
                setState(() {
                  cubit.searchCtl.clear();
                });

                cubit.showSuffixIcon = false;
                cubit.showHideSuffix(cubit.showSuffixIcon);
                OverlayLoadingProgress.start(context);

                await cubit.getCountryList(context);
                OverlayLoadingProgress.stop();

                final country = await showCountryBottomSheetWithSearch(
                  context: context,
                );

                if (country != null) {
                  cubit.selectedCountryStateUpdate(country);

                  cubit.countryCode = country.phoneCode ?? "";
                  cubit.countryName = country.name ?? "";
                  cubit.countryFlag = country.emoji ?? "";

                  setState(() {
                    cubit.selectedCountry = country;
                    printf("${cubit.selectedCountry}");
                  });
                }
              },
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16, vertical: 12),
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
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Text(
                            cubit.countryFlag, // Display flag emoji
                            style: const TextStyle(
                                fontSize: 28), // Adjust emoji size
                          ),
                        ),
                        12.horizontalSpace,
                        Container(
                          width: 1,
                          height: 14,
                          color: AppColors.greyE9.adaptiveColor(context,
                              lightModeColor: AppColors.greyE9,
                              darkModeColor: AppColors.black2E),
                        ),
                        12.horizontalSpace,
                        Text(
                          cubit.countryName,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SVGAssets.arrowDownIcon.toSvg(context: context),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Modified showCountryBottomSheet to return the selected country
  Future<CountryListData?> showCountryBottomSheet(
    BuildContext context,
  ) {
    final itemCount =
        context.read<CountrySelectionCubit>().filteredCountries.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<CountryListData>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
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
                      itemCount: context
                          .read<CountrySelectionCubit>()
                          .filteredCountries
                          .length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Return the selected country and close the sheet
                            Navigator.pop(
                                context,
                                context
                                    .read<CountrySelectionCubit>()
                                    .filteredCountries[index]);
                          },
                          child: CountryListItemWidget(
                            country: context
                                .read<CountrySelectionCubit>()
                                .filteredCountries[index],
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
                        itemCount: context
                            .read<CountrySelectionCubit>()
                            .filteredCountries
                            .length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              // Return the selected country and close the sheet
                              Navigator.pop(
                                  context,
                                  context
                                      .read<CountrySelectionCubit>()
                                      .filteredCountries[index]);
                            },
                            child: CountryListItemWidget(
                              country: context
                                  .read<CountrySelectionCubit>()
                                  .filteredCountries[index],
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
          ),
        );
      },
    );
  }

  // Modified showCountryBottomSheet to return the selected country
  Future<CountryListData?> showCountryBottomSheetWithSearch({
    required BuildContext context,
    bool enableSearch = true,
  }) {
    CountrySelectionCubit cubit = context.read<CountrySelectionCubit>();

    return showModalBottomSheet<CountryListData>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        // Check if the keyboard is open
        final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
        return BlocBuilder<CountrySelectionCubit, CountrySelectionState>(
            builder: (context, state) => SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 8,
                      // start: 16,
                      // end: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appStrings(context).lblSelectCountry,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                        if (enableSearch)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SearchTextFormField(
                              controller: cubit.searchCtl,
                              fieldHint: appStrings(context).textSearch,
                              showSuffixIcon: true,
                              inputFormatters: [
                                InputFormatters().emojiRestrictInputFormatter,
                              ],
                              functionSuffix: () async {
                                setState(() {
                                  cubit.searchCtl.clear();
                                });
                                cubit.showSuffixIcon = false;
                                cubit.showHideSuffix(cubit.showSuffixIcon);
                                FocusManager.instance.primaryFocus?.unfocus();

                                await cubit.getCountryList(context);
                              },
                              suffixIcon: cubit.showSuffixIcon
                                  ? SVGAssets.cancelIcon.toSvg(
                                      context: context,
                                      height: 20,
                                      width: 20,
                                      color: AppColors.black34)
                                  : SVGAssets.searchIcon.toSvg(
                                      context: context, height: 18, width: 18),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    cubit.showSuffixIcon = false;
                                  });
                                } else {
                                  _debouncer.run(() async {
                                    OverlayLoadingProgress.start(context);
                                    await cubit.getCountryList(context);
                                    OverlayLoadingProgress.stop();
                                  });
                                  cubit.showSuffixIcon = true;
                                  cubit.showHideSuffix(cubit.showSuffixIcon);
                                }
                              },
                              onSubmitted: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    cubit.showSuffixIcon = false;
                                  });
                                }
                                _debouncer.run(() {
                                  cubit.getCountryList(context);
                                });
                              },
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        if (cubit.filteredCountries.isEmpty)
                          UIComponent.noData(context),
                        if (cubit.filteredCountries.length <= 5)
                          ListView.separated(
                            itemCount: cubit.filteredCountries.length,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(
                                      context, cubit.filteredCountries[index]);
                                },
                                child: CountryListItemWidget(
                                  country: cubit.filteredCountries[index],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
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
                        else
                          SizedBox(
                            height: isKeyboardOpen
                                ? MediaQuery.of(context).size.height * 0.35
                                : MediaQuery.of(context).size.height * 0.5,
                            child: ListView.separated(
                              itemCount: cubit.filteredCountries.length,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context,
                                        cubit.filteredCountries[index]);
                                  },
                                  child: CountryListItemWidget(
                                    country: cubit.filteredCountries[index],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 20.0),
                                  child: Divider(
                                    height: 1,
                                    color: AppColors.greyE8.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.greyE8,
                                        darkModeColor: AppColors.grey50),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ));
      },
    );
  }
}
