import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/search_text_form_field.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/debouncer.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';
import 'package:mashrou3/utils/location_manager.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../model/property/property_detail_response_model.dart';
import '../../custom_widget/toggle_widget/toggle_cubit.dart';
import '../../custom_widget/toggle_widget/toggle_row_item.dart';
import 'components/recently_visited_properties_list_item.dart';
import 'cubit/recently_visited_properties_cubit.dart';

class RecentlyVisitedPropertiesScreen extends StatefulWidget with AppBarMixin {
  final bool isPropertiesWithOffers;

  RecentlyVisitedPropertiesScreen({
    super.key,
    this.isPropertiesWithOffers = false,
  });

  @override
  State<RecentlyVisitedPropertiesScreen> createState() =>
      _RecentlyVisitedPropertiesScreenState();
}

class _RecentlyVisitedPropertiesScreenState
    extends State<RecentlyVisitedPropertiesScreen> with AppBarMixin {
  String? selectedCategoryId;
  final PagingController<int, PropertyDetailData> _pagingController =
      PagingController(firstPageKey: 1);
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    context.read<RecentlyVisitedPropertiesCubit>().isPropertiesWithOffers =
        widget.isPropertiesWithOffers;
    if (mounted) {
      if (context.mounted) {
        var cubit = context.read<RecentlyVisitedPropertiesCubit>();
        cubit.getData(context);
        _pagingController.addPageRequestListener((pageKey) {
          cubit.getList(
              pageKey: pageKey,
              isPropertiesWithOffers: widget.isPropertiesWithOffers);
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        requireLeading: true,
        title: widget.isPropertiesWithOffers
            ? appStrings(context).lblPropertiesWithOffers
            : appStrings(context).lblRecentlyVisitedProperties,
      ),
      body: _buildBlocConsumer,
      floatingActionButton: widget.isPropertiesWithOffers
          ? BlocConsumer<RecentlyVisitedPropertiesCubit, RecentlyVisitedPropertiesState>(
              listener: (ctx, state) {},
              builder: (context, state) {
                RecentlyVisitedPropertiesCubit cubit =
                    context.read<RecentlyVisitedPropertiesCubit>();

                return cubit.isBtnSelectPropertiesTapped
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildRemoveOffer(context, cubit),
                        ],
                      )
                    : Container();
              },
            )
          : null,
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocProvider(
        create: (context) {
          return ToggleCubit(AppConstants.propertyCategory);
        },
        child: BlocListener<ToggleCubit, int>(
          listener: (context, state) {},
          child: BlocConsumer<RecentlyVisitedPropertiesCubit,
              RecentlyVisitedPropertiesState>(
            listener: buildBlocListener,
            builder: (context, state) {
              RecentlyVisitedPropertiesCubit cubit =
                  context.read<RecentlyVisitedPropertiesCubit>();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    14.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: SearchTextFormField(
                            controller: cubit.searchCtl,
                            fieldHint: appStrings(context).textSearch,
                            onChanged: (value) {
                              if (value.isEmpty &&
                                  MediaQuery.of(context).viewInsets.bottom !=
                                      0) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                              if (value.isEmpty) {
                                setState(() {
                                  cubit.showSuffixIcon = false;
                                });
                              } else {
                                _debouncer.run(() async {
                                  _pagingController.refresh();
                                });
                                cubit.showSuffixIcon = true;
                                cubit.showHideSuffix(cubit.showSuffixIcon);
                              }
                            },
                            showSuffixIcon: cubit.showSuffixIcon,
                            functionSuffix: () {
                              setState(() {
                                cubit.searchCtl.clear();
                              });
                              cubit.showSuffixIcon = false;
                              cubit.showHideSuffix(cubit.showSuffixIcon);
                              FocusManager.instance.primaryFocus?.unfocus();
                              _pagingController.refresh();
                            },
                            suffixIcon: cubit.showSuffixIcon
                                ? SVGAssets.cancelIcon.toSvg(
                                    context: context,
                                    height: 20,
                                    width: 20,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : SVGAssets.searchIcon.toSvg(
                                    context: context,
                                    height: 18,
                                    width: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            onSubmitted: (value) {
                              print("=========on submit");
                              if (value.isEmpty) {
                                setState(() {
                                  cubit.showSuffixIcon = false;
                                });
                              }
                              _debouncer.run(() {
                                _pagingController.refresh();
                              });
                            },
                            inputFormatters: [
                              InputFormatters().emojiRestrictInputFormatter,
                            ],
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.text,
                          )),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: UIComponent.customInkWellWidget(
                              onTap: () {
                                UIComponent.showCustomBottomSheet(
                                    horizontalPadding: 0,
                                    verticalPadding: 8,
                                    context: context,
                                    builder: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 83,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: AppColors.black14,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        24.verticalSpace,
                                        Text(
                                          appStrings(context).lblSortBy,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                        8.verticalSpace,
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount: cubit.sortOptions.length,
                                          itemBuilder: (context, index) {
                                            final option =
                                                cubit.sortOptions[index];

                                            bool isSelected = index ==
                                                (cubit.selectedSortIndex);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                              child: UIComponent
                                                  .customInkWellWidget(
                                                onTap: () async {
                                                  cubit.filterRequestModel ??=
                                                      FilterRequestModel();
                                                  OverlayLoadingProgress.start(
                                                      context);

                                                  bool callAPI = true;
                                                  if (option.title ==
                                                      appStrings(context)
                                                          .textNearest) {
                                                    var position =
                                                        await LocationManager
                                                            .fetchLocation(
                                                      context: context,
                                                      isForSort: true,
                                                    );

                                                    if (position != null) {
                                                      cubit.filterRequestModel!
                                                        ..nearest = "true"
                                                        ..farthest = null
                                                        ..longitude = position
                                                            .longitude
                                                            .toString()
                                                        ..latitude = position
                                                            .latitude
                                                            .toString();
                                                      callAPI = true;
                                                    } else {
                                                      callAPI = false;
                                                    }
                                                  } else if (option.title ==
                                                      appStrings(context)
                                                          .textFurthest) {
                                                    var position =
                                                        await LocationManager
                                                            .fetchLocation(
                                                      context: context,
                                                      isForSort: true,
                                                    );

                                                    if (position != null) {
                                                      cubit.filterRequestModel!
                                                        ..farthest = "true"
                                                        ..nearest = null
                                                        ..longitude = position
                                                            .longitude
                                                            .toString()
                                                        ..latitude = position
                                                            .latitude
                                                            .toString();
                                                      callAPI = true;
                                                    } else {
                                                      callAPI = false;
                                                    }
                                                  } else {
                                                    if (cubit
                                                            .filterRequestModel !=
                                                        null) {
                                                      cubit.filterRequestModel!
                                                        ..nearest = null
                                                        ..farthest = null;
                                                    }
                                                    callAPI = true;
                                                  }

                                                  cubit.selectedSortIndex =
                                                      index;
                                                  _pagingController.refresh();

                                                  if (callAPI) {
                                                    Navigator.pop(context);
                                                  }

                                                  OverlayLoadingProgress.stop();
                                                  print(
                                                      '${option.title} selected');
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? AppColors
                                                            .colorPrimaryShade
                                                            .adaptiveColor(
                                                            context,
                                                            lightModeColor:
                                                                AppColors
                                                                    .colorPrimaryShade,
                                                            darkModeColor:
                                                                AppColors
                                                                    .colorPrimary,
                                                          )
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Rounded corners
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          option.title,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall
                                                                  ?.copyWith(
                                                                    color: AppColors
                                                                        .black14
                                                                        .forLightMode(
                                                                            context),
                                                                  ),
                                                        ),
                                                      ),
                                                      SVGAssets.arrowRightIcon
                                                          .toSvg(
                                                        context: context,
                                                        color: Theme.of(context)
                                                            .highlightColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .symmetric(
                                                      horizontal: 0.0),
                                              child: Divider(
                                                height: 1,
                                                color: AppColors.greyE8
                                                    .adaptiveColor(context,
                                                        lightModeColor:
                                                            AppColors.greyE8,
                                                        darkModeColor:
                                                            AppColors.grey50),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: AppColors.greyE9.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.greyE9,
                                              darkModeColor: AppColors.black3D),
                                          width: 1)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.all(10.0),
                                    child: SvgPicture.asset(
                                      SVGAssets.sortIcon,
                                      height: 26,
                                      width: 26,
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context).focusColor,
                                          BlendMode.srcIn),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ).showIf(widget.isPropertiesWithOffers),
                    BlocBuilder<ToggleCubit, int>(
                      builder: (context, selectedIndex) {
                        if (cubit.selectedItemIndex != selectedIndex) {
                          cubit.selectedItemIndex = selectedIndex;

                          if (selectedIndex >= 0) {
                            selectedCategoryId = AppConstants
                                .propertyCategory[selectedIndex].sId;
                            cubit.updateSelectedCategoryId(selectedCategoryId);
                            Future.delayed(Duration.zero, () async {
                              printf(
                                  "Selected Category ID: $selectedCategoryId");
                              _pagingController.refresh();
                            });
                          }
                        }

                        return ToggleRowItem(
                          cubit: context.read<ToggleCubit>(),
                        );
                      },
                    ),
                    20.verticalSpace,
                    // Select Properties buttons (only for Properties with Offers)
                    if (widget.isPropertiesWithOffers)
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left text showing found estates
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 2.0),
                                child: Text(
                                  "${appStrings(context).textFound} ${cubit.totalProperties} ${foundPropertiesText(context, cubit.totalProperties)}",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).highlightColor,
                                      fontWeight: FontWeight.w500),
                                ).showIf(_pagingController.itemList != null &&
                                    _pagingController.itemList!.isNotEmpty),
                              ),
                            ),

                            // Right buttons
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Row(
                                  children: [
                                    // Button select properties
                                    UIComponent.customInkWellWidget(
                                      onTap: () {
                                        cubit.toggleSelectProperties();
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.greyE8),
                                          color: AppColors.white.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.white,
                                              darkModeColor: AppColors.black2E),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.symmetric(
                                                horizontal: 12.0),
                                            child: Text(appStrings(context).textSelectProperties),
                                          ),
                                        ),
                                      ),
                                    ).showIf(!cubit.isBtnSelectPropertiesTapped),

                                    // Buttons select all and cancel
                                    Row(
                                      children: [
                                        UIComponent.customInkWellWidget(
                                          onTap: () {
                                            final allProperties = _pagingController.itemList ?? <PropertyDetailData>[];
                                            cubit.toggleSelectAllProperties(allProperties);
                                            printf("selectedPropertyList--------${cubit.selectedPropertyList.length}");
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.colorPrimary.adaptiveColor(
                                                    context,
                                                    lightModeColor: AppColors.colorPrimary,
                                                    darkModeColor: AppColors.greyE8),
                                              ),
                                              color: AppColors.white.adaptiveColor(
                                                  context,
                                                  lightModeColor: AppColors.white,
                                                  darkModeColor: AppColors.black2E),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.symmetric(
                                                    horizontal: 12.0),
                                                child: Row(
                                                  children: [
                                                    cubit.isBtnSelectAllPropertiesTapped
                                                        ? SVGAssets.checkboxEnableIcon.toSvg(
                                                            height: 18,
                                                            width: 18,
                                                            context: context)
                                                        : SVGAssets.checkboxBlackDisableIcon.toSvg(
                                                            height: 18,
                                                            width: 18,
                                                            context: context,
                                                            color: AppColors.black14.adaptiveColor(
                                                                context,
                                                                lightModeColor: AppColors.black14,
                                                                darkModeColor: AppColors.white),
                                                          ),
                                                    10.horizontalSpace,
                                                    Text(appStrings(context).textSelectAll),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        UIComponent.customInkWellWidget(
                                          onTap: () {
                                            cubit.isBtnSelectAllPropertiesTapped = false;
                                            cubit.selectedPropertyList.clear();
                                            cubit.toggleSelectProperties();
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: AppColors.greyE8),
                                              color: AppColors.white.adaptiveColor(
                                                  context,
                                                  lightModeColor: AppColors.white,
                                                  darkModeColor: AppColors.black2E),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.symmetric(
                                                    horizontal: 12.0),
                                                child: Text(appStrings(context).cancel),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).showIf(cubit.isBtnSelectPropertiesTapped),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ).showIf(widget.isPropertiesWithOffers &&
                          _pagingController.itemList != null &&
                          _pagingController.itemList!.isNotEmpty),
                    8.verticalSpace.showIf(widget.isPropertiesWithOffers &&
                        _pagingController.itemList != null &&
                        _pagingController.itemList!.isNotEmpty),
                    Expanded(
                      child: _buildLazyLoadProjectList(
                        cubit,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  /// pagination list
  Widget _buildLazyLoadProjectList(RecentlyVisitedPropertiesCubit cubit) {
    return PagedListView<int, PropertyDetailData>.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) {
        return 12.verticalSpace;
      },
      pagingController: _pagingController,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<PropertyDetailData>(
        firstPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: EdgeInsets.zero,
            child: UIComponent.getSkeletonProperty(),
          );
        },
        itemBuilder: (context, item, index) {
          final allProperties = _pagingController.itemList ?? <PropertyDetailData>[];
          final isSelected = cubit.selectedPropertyList.contains(item);
          
          return RecentlyVisitedPropertiesListItem(
            propertyName: item.title ?? '',
            propertyImg: Utils.getLatestPropertyImage(
                    item.propertyFiles ?? [], item.thumbnail ?? "") ??
                "",
            propertyImgCount:
                (Utils.getAllImageFiles(item.propertyFiles ?? []).length +
                        ((item.thumbnail != null && item.thumbnail!.isNotEmpty)
                            ? 1
                            : 0))
                    .toString(),
            propertyPrice: item.price?.amount?.toString(),
            propertyLocation:
                '${item.city?.isNotEmpty == true ? item.city : ''}'
                '${(item.city?.isNotEmpty == true && item.country?.isNotEmpty == true) ? ', ' : ''}'
                '${item.country?.isNotEmpty == true ? item.country : ''}',
            propertyArea: Utils.formatArea(
                '${item.area?.amount ?? ''}', item.area?.unit ?? ''),
            propertyRating: item.rating ?? '0',
            isBankProperty: item.createdByBank ?? false,
            onPropertyTap: () {
              context.pushNamed(Routes.kPropertyDetailScreen, pathParameters: {
                RouteArguments.propertyId:
                    item.propertyIdForPropertiesWithOffers ?? "0",
                RouteArguments.propertyLat:
                    (item.propertyLocation?.latitude ?? 0.00).toString(),
                RouteArguments.propertyLng:
                    (item.propertyLocation?.longitude ?? 0.00).toString(),
              }).then((value) {
                if (value != null && value == true) {}
              });
            },
            requiredFavorite: false,
            isFavorite: item.favorite ?? cubit.isFavorite,
            propertyPriceCurrency: item.price?.currencySymbol ?? '',
            isSoldOut: item.isSoldOut ?? false,
            isVisitor: cubit.isVendor == true ? false : true,
            isLocked: item.isLocked ?? false,
            isLockedByMe: item.isLockedByMe ?? false,
            offerData: item.offerData,
            requiredCheckBox: widget.isPropertiesWithOffers ? cubit.isBtnSelectPropertiesTapped : false,
            isSelected: isSelected,
            onCheckBoxToggle: (isSelectedForCheckbox) async {
              cubit.togglePropertySelection(item, isSelectedForCheckbox, allProperties);
            },
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: UIComponent.noDataWidgetWithInfo(
                title: appStrings(context).emptyPropertyList,
                info: appStrings(context).emptyPropertyListInfo,
                context: context,
              ),
            ),
          );
        },
      ),
    );
  }

  String foundPropertiesText(BuildContext context, int count) {
    if (count == 1) {
      return appStrings(context).lblProperty;
    } else {
      return appStrings(context).lblProperties;
    }
  }

  Widget _buildRemoveOffer(BuildContext context, RecentlyVisitedPropertiesCubit cubit) {
    return BlocConsumer<RecentlyVisitedPropertiesCubit, RecentlyVisitedPropertiesState>(
      listener: (ctx, state) {
        if (state is ToggleSelectAllPropertiesInit) {
          OverlayLoadingProgress.start(context);
        } else if (state is ToggleSelectAllPropertiesUpdate) {
          OverlayLoadingProgress.stop();
        }
      },
      builder: (context, state) {
        return Container(
          height: 48,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
              ),
            ],
            borderRadius: BorderRadius.circular(16),
            gradient: AppColors.primaryGradient,
          ),
          child: FloatingActionButton.extended(
            isExtended: true,
            elevation: 0,
            onPressed: () async {
              if (cubit.selectedPropertyList.isEmpty) {
                Utils.snackBar(
                  context: context,
                  message: appStrings(context).selectPropertyError,
                );
              } else {
                List<String> selectedPropertyIds = cubit.selectedPropertyList
                    .map((property) => property.propertyIdForPropertiesWithOffers ?? property.sId)
                    .whereType<String>()
                    .toList();

                await context.pushNamed(
                  Routes.kAddMyOffersListScreen,
                  extra: selectedPropertyIds,
                  pathParameters: {
                    RouteArguments.offersList: jsonEncode([]),
                    RouteArguments.isMultiple: "true",
                    RouteArguments.isFromDelete: "true",
                  },
                ).then((value) {
                  if (value != null && value == true) {
                    cubit.isBtnSelectPropertiesTapped = false;
                    cubit.isSelectedForCheckbox = false;
                    final allProperties = _pagingController.itemList ?? <PropertyDetailData>[];
                    cubit.toggleSelectAllProperties(allProperties);
                    cubit.isBtnSelectAllPropertiesTapped = false;
                    cubit.selectedPropertyList.clear();
                    _pagingController.refresh();
                  }
                });
              }
            },
            backgroundColor: Colors.transparent,
            icon: SVGAssets.myOfferIcon.toSvg(context: context, color: AppColors.white),
            label: Row(
              children: [
                Text(
                  appStrings(context).removeOffer,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ],
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
  Future<void> buildBlocListener(
      BuildContext context, RecentlyVisitedPropertiesState state) async {
    if (state is RecentlyVisitedPropertiesListSuccess) {
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.propertyList);
      } else {
        _pagingController.appendPage(state.propertyList, state.currentKey + 1);
      }
    }
    if (state is NoRecentlyVisitedPropertiesFoundState) {
      _pagingController.appendLastPage([]);
    } else if (state is RecentlyVisitedPropertiesListError) {
      _pagingController.appendLastPage([]);
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
