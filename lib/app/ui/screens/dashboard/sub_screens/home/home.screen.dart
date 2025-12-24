import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/home/components/property_list_item.dart';
import 'package:mashrou3/app/ui/screens/filter/cubit/filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/add_rating_cubit.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../custom_widget/toggle_widget/toggle_cubit.dart';
import '../../../../custom_widget/toggle_widget/toggle_row_item.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget with AppBarMixin {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AppBarMixin {
  String? selectedCategoryId;
  bool isFetchingData = false;
  final PagingController<int, PropertyData> homeScreenPagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    context.read<HomeCubit>().getData(context);
    homeScreenPagingController.addPageRequestListener((pageKey) {
      context.read<HomeCubit>().getPropertyList(pageKey: pageKey);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                shrinkWrap: true,
                children: [18.verticalSpace, UIComponent.getSkeletonCategories(), 24.verticalSpace, UIComponent.getSkeletonProperty()],
              ),
            );
          }
          return _buildBlocConsumer;
        },
      ),
      floatingActionButton: BlocConsumer<HomeCubit, HomeState>(
        listener: (ctx, state) {},
        builder: (context, state) {
          HomeCubit cubit = context.read<HomeCubit>();

          return cubit.isBtnSelectPropertiesTapped
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildRemoveOffer(),
                    8.verticalSpace,
                    _buildAddOffer(),
                  ],
                )
              : Container();
        },
      ),
    );
  }

  Future<void> _initializeCategories() async {
    if (!context.mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    // Fetch or update the propertyCategory list here
    await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);
    await context.read<ToggleCubit>().updateCategories(AppConstants.propertyCategory);
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocProvider(
        create: (context) {
          return ToggleCubit(AppConstants.propertyCategory);
        },
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: buildBlocListener,
          builder: (context, state) {
            HomeCubit cubit = context.read<HomeCubit>();

            return BlocListener<AddRatingCubit, AddRatingState>(
              listener: (context, state) {
                if (state is AddRatingReviewSuccess) {
                  Future.delayed(Duration.zero, () async {
                    cubit.resetPropertyList();
                    homeScreenPagingController.refresh();
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    BlocConsumer<FilterCubit, FilterState>(
                      listener: (context, state) {
                        FilterRequestModel? filterRequestModel;
                        if (state is ApplyPropertyFilter) {
                          filterRequestModel = state.filterRequestModel;
                          cubit.updateFilterRequestModel(filterRequestModel);
                          Future.delayed(Duration.zero, () async {
                            cubit.resetPropertyList();
                            homeScreenPagingController.refresh();
                          });
                        } else if (state is FilterReset) {
                          cubit.updateFilterRequestModel(FilterRequestModel());
                          Future.delayed(Duration.zero, () async {
                            cubit.resetPropertyList();
                            homeScreenPagingController.refresh();
                          });
                        }
                      },
                      builder: (context, state) {
                        return BlocBuilder<ToggleCubit, int>(
                          builder: (context, selectedIndex) {
                            if (cubit.selectedItemIndex != selectedIndex) {
                              cubit.selectedItemIndex = selectedIndex;

                              if (selectedIndex >= 0) {
                                selectedCategoryId = AppConstants.propertyCategory[selectedIndex].sId;
                                cubit.updateSelectedCategoryId(selectedCategoryId);
                                Future.delayed(Duration.zero, () async {
                                  printf("Selected Category ID: $selectedCategoryId");
                                  printf("searchText--- ${cubit.searchText}");
                                  cubit.resetPropertyList();
                                  if (!context.mounted) return;
                                  // OverlayLoadingProgress.start(context);
                                  homeScreenPagingController.refresh();
                                  // OverlayLoadingProgress.stop();
                                });
                              }
                            }

                            return ToggleRowItem(
                              cubit: context.read<ToggleCubit>(),
                            );
                          },
                        );
                      },
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appStrings(context).lblPropertyListing,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
                        ),
                        // Items per page dropdown
                        _buildItemsPerPageDropdown(context, cubit),
                      ],
                    ),
                    16.verticalSpace,
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 2.0),
                      child: Text(
                        "${appStrings(context).textFound} ${cubit.totalEstates} ${foundPropertiesText(context, cubit.totalEstates)}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).highlightColor, fontWeight: FontWeight.w500),
                      ).showIf(!cubit.isVendor && homeScreenPagingController.itemList != null && homeScreenPagingController.itemList!.isNotEmpty),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left text showing found estates
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 2.0),
                            child: Text(
                              "${appStrings(context).textFound} ${cubit.totalEstates} ${foundPropertiesText(context, cubit.totalEstates)}",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).highlightColor, fontWeight: FontWeight.w500),
                            ).showIf(homeScreenPagingController.itemList != null && homeScreenPagingController.itemList!.isNotEmpty),
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
                                      color: AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
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
                                        cubit.toggleSelectAllProperties(homeScreenPagingController);
                                        printf("selectedPropertyList--------${cubit.selectedPropertyList.length}");
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.greyE8),
                                          ),
                                          color: AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
                                            child: Row(
                                              children: [
                                                cubit.isBtnSelectAllPropertiesTapped
                                                    ? SVGAssets.checkboxEnableIcon.toSvg(height: 18, width: 18, context: context)
                                                    : SVGAssets.checkboxBlackDisableIcon.toSvg(
                                                        height: 18,
                                                        width: 18,
                                                        context: context,
                                                        color: AppColors.black14.adaptiveColor(context, lightModeColor: AppColors.black14, darkModeColor: AppColors.white),
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
                                          color: AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
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
                        ).showIf(cubit.isVendor && homeScreenPagingController.itemList != null && homeScreenPagingController.itemList!.isNotEmpty),
                      ],
                    ).showIf(cubit.isVendor),
                    8.verticalSpace.showIf(homeScreenPagingController.itemList != null && homeScreenPagingController.itemList!.isNotEmpty),
                    Expanded(
                      child: _buildLazyLoadPropertyList(context, cubit, state),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  /// pagination list
  Widget _buildLazyLoadPropertyList(BuildContext context, HomeCubit cubit, HomeState state) {
    return PagedListView<int, PropertyData>.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) {
        return 12.verticalSpace;
      },
      pagingController: homeScreenPagingController,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<PropertyData>(
        firstPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: EdgeInsets.zero,
            child: UIComponent.getSkeletonProperty(),
          );
        },
        itemBuilder: (context, item, index) {
          final isSelected = cubit.isBtnSelectAllPropertiesTapped || cubit.selectedPropertyList.contains(item);
          return PropertyListItem(
            propertyName: item.title ?? '',
            propertyImg: Utils.getLatestPropertyImage(item.propertyFiles ?? [], item.thumbnail ?? "") ?? "",
            propertyImgCount: (Utils.getAllImageFiles(item.propertyFiles ?? []).length + ((item.thumbnail != null && item.thumbnail!.isNotEmpty) ? 1 : 0)).toString(),
            propertyPrice: item.price?.amount?.toString(),
            propertyLocation: '${item.city?.isNotEmpty == true ? item.city : ''}'
                '${(item.city?.isNotEmpty == true && item.country?.isNotEmpty == true) ? ', ' : ''}'
                '${item.country?.isNotEmpty == true ? item.country : ''}',
            propertyArea: Utils.formatArea('${item.area?.amount ?? ''}', item.area?.unit ?? ''),
            propertyRating: item.rating.toString(),
            isVendor: cubit.isVendor,
            isVisitor: cubit.isVendor == true ? false : true,
            isSoldOut: item.isSoldOut ?? false,
            onPropertyTap: () {
              context.pushNamed(Routes.kPropertyDetailScreen, pathParameters: {
                RouteArguments.propertyId: item.sId ?? "0",
                RouteArguments.propertyLat: (item.propertyLocation?.latitude ?? 0.00).toString(),
                RouteArguments.propertyLng: (item.propertyLocation?.longitude ?? 0.00).toString(),
              }).then((value) {
                if (value != null && value == true) {
                  // _pagingController.refresh();
                }
              });
            },
            requiredFavorite: cubit.isGuest ? false : true,
            requiredCheckBox: cubit.isBtnSelectPropertiesTapped,
            isFavorite: item.favorite ?? cubit.isFavorite,
            isSelected: isSelected,
            isBankProperty: item.createdByBank ?? false,
            isLocked: item.isLocked,
            isLockedByMe: item.isLockedByMe,
            offerData: item.offerData,
            onFavouriteToggle: (isFavourite) async {
              if (isFetchingData) return;
              OverlayLoadingProgress.start(context);
              isFetchingData = true;
              try {
                await cubit
                    .addRemoveFavorite(
                  propertyId: item.sId ?? "",
                  isFav: isFavourite,
                )
                    .then((value) {
                  Future.delayed(Duration.zero, () async {
                    cubit.resetPropertyList();
                    homeScreenPagingController.refresh();
                  });
                });
              } catch (error) {
                printf("Error fetching properties: $error");
              } finally {
                isFetchingData = false;
              }
            },
            onCheckBoxToggle: (isSelectedForCheckbox) async {
              cubit.togglePropertySelection(item, isSelectedForCheckbox, homeScreenPagingController);
            },
            propertyPriceCurrency: item.price?.currencySymbol ?? '',
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

  // Widget _buildItemsPerPageDropdown(BuildContext context, HomeCubit cubit) {
  //   final itemsPerPageOptions = [10, 25, 50, 75, 100];
  //   // RGB(62, 113, 119) color for selected item
  //   const selectedColor = Color.fromRGBO(62, 113, 119, 1.0);
  //
  //   return BlocBuilder<HomeCubit, HomeState>(
  //     builder: (context, state) {
  //       return Container(
  //         padding: const EdgeInsetsDirectional.symmetric(
  //             horizontal: 12, vertical: 4),
  //         decoration: BoxDecoration(
  //           borderRadius: const BorderRadius.all(Radius.circular(8)),
  //           border: Border.all(
  //               color: AppColors.greyE8.adaptiveColor(context,
  //                   lightModeColor: AppColors.greyE8,
  //                   darkModeColor: AppColors.black2E)),
  //           color: AppColors.white.adaptiveColor(context,
  //               lightModeColor: AppColors.white,
  //               darkModeColor: AppColors.black2E),
  //         ),
  //         child: DropdownButton<int>(
  //           value: cubit.itemsPerPage,
  //           isDense: true,
  //           isExpanded: false,
  //           underline: const SizedBox.shrink(),
  //           dropdownColor: AppColors.white.adaptiveColor(context,
  //               lightModeColor: AppColors.white,
  //               darkModeColor: AppColors.black2E),
  //           icon: SVGAssets.arrowDownIcon.toSvg(
  //               context: context,
  //               color: Theme.of(context).highlightColor,
  //               height: 16,
  //               width: 16),
  //           selectedItemBuilder: (BuildContext context) {
  //             return itemsPerPageOptions.map<Widget>((int value) {
  //               return Text(
  //                 "$value",
  //                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //                     color: selectedColor,
  //                     fontWeight: FontWeight.w500),
  //               );
  //             }).toList();
  //           },
  //           items: itemsPerPageOptions.map((int value) {
  //             final isSelected = value == cubit.itemsPerPage;
  //             return DropdownMenuItem<int>(
  //               value: value,
  //               child: Container(
  //                 // padding: const EdgeInsets.symmetric(vertical: 8),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "$value",
  //                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //                           color: isSelected
  //                               ? Colors.white
  //                               : AppColors.black14.adaptiveColor(context,
  //                               lightModeColor: AppColors.black14,
  //                               darkModeColor: AppColors.grey77),
  //                           fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //           onChanged: (int? newValue) {
  //             if (newValue != null && newValue != cubit.itemsPerPage) {
  //               cubit.updateItemsPerPage(newValue);
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildItemsPerPageDropdown(BuildContext context, HomeCubit cubit) {
    final itemsPerPageOptions = [10, 25, 50, 75, 100];
    const selectedColor = Color.fromRGBO(62, 113, 119, 1.0);

    return PopupMenuButton<int>(
      offset: const Offset(0, 40),
      color: AppColors.white.adaptiveColor(
        context,
        lightModeColor: AppColors.white,
        darkModeColor: AppColors.black2E,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        if (value != cubit.itemsPerPage) {
          cubit.updateItemsPerPage(value);
        }
      },
      itemBuilder: (context) {
        return itemsPerPageOptions.map((value) {
          final isSelected = value == cubit.itemsPerPage;

          return PopupMenuItem<int>(
            value: value,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : Colors.transparent,
              ),
              child: Text(
                "$value",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? Colors.white : AppColors.black14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.greyE8.adaptiveColor(
              context,
              lightModeColor: AppColors.greyE8,
              darkModeColor: AppColors.black2E,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${cubit.itemsPerPage}",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: selectedColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, color: selectedColor, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOffer() {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (ctx, state) {
        if (state is ToggleSelectAllPropertiesInit) {
          OverlayLoadingProgress.start(context);
        } else if (state is ToggleSelectAllPropertiesUpdate) {
          OverlayLoadingProgress.stop();
        }
      },
      builder: (context, state) {
        HomeCubit cubit = context.read<HomeCubit>();

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
                // return;
              } else {
                // Validate selected properties for locked status
                final lockedProperties = cubit.selectedPropertyList
                    .where((property) => property.isLockedByMe == true)
                    .toList();
                
                // Check if ALL selected properties are locked (before partial-selection logic)
                if (lockedProperties.length == cubit.selectedPropertyList.length && 
                    cubit.selectedPropertyList.isNotEmpty) {
                  // All properties are locked - show alert and don't proceed
                  await _showAllPropertiesLockedAlert(
                    context: context,
                    lockedCount: lockedProperties.length,
                  );
                  return;
                }
                
                // Check if SOME properties are locked (partial-selection logic)
                if (lockedProperties.isNotEmpty) {
                  // Show alert dialog
                  final shouldProceed = await _showLockedPropertiesAlert(
                    context: context,
                    lockedCount: lockedProperties.length,
                  );
                  
                  if (shouldProceed == true) {
                    // Remove locked properties from selection
                    cubit.selectedPropertyList.removeWhere(
                      (property) => property.isLockedByMe == true,
                    );
                    
                    // Update Select All state if needed
                    final totalProperties = homeScreenPagingController.itemList?.length ?? 0;
                    cubit.isBtnSelectAllPropertiesTapped = 
                        cubit.selectedPropertyList.length == totalProperties && totalProperties > 0;
                    
                    // Update UI if all properties were locked
                    if (cubit.selectedPropertyList.isEmpty) {
                      Utils.snackBar(
                        context: context,
                        message: appStrings(context).selectPropertyError,
                      );
                      return;
                    }
                    
                    // Trigger UI rebuild by calling setState
                    if (mounted) {
                      setState(() {});
                    }
                  } else {
                    // User cancelled, don't proceed
                    return;
                  }
                }
                
                List<String> selectedPropertyIds = cubit.selectedPropertyList
                    .map((property) => property.sId)
                    .whereType<String>() // Filters out null values and ensures type safety
                    .toList();

                await context.pushNamed(
                  Routes.kAddMyOffersListScreen,
                  extra: selectedPropertyIds,
                  pathParameters: {
                    RouteArguments.offersList: jsonEncode([]),
                    RouteArguments.isMultiple: "true",
                    RouteArguments.isFromDelete: "false",
                  },
                ).then((value) {
                  if (value != null && value == true) {
                    cubit.isBtnSelectPropertiesTapped = false;
                    cubit.isSelectedForCheckbox = false;
                    cubit.toggleSelectAllProperties(homeScreenPagingController);
                    cubit.isBtnSelectAllPropertiesTapped = false;
                    cubit.selectedPropertyList.clear();
                  }
                });
              }
            },
            backgroundColor: Colors.transparent,
            icon: SVGAssets.myOfferIcon.toSvg(context: context, color: AppColors.white),
            label: Row(
              children: [
                Text(
                  appStrings(context).applyOffer,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRemoveOffer() {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (ctx, state) {
        if (state is ToggleSelectAllPropertiesInit) {
          OverlayLoadingProgress.start(context);
        } else if (state is ToggleSelectAllPropertiesUpdate) {
          OverlayLoadingProgress.stop();
        }
      },
      builder: (context, state) {
        HomeCubit cubit = context.read<HomeCubit>();

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
                // return;
              } else {
                List<String> selectedPropertyIds = cubit.selectedPropertyList
                    .map((property) => property.sId)
                    .whereType<String>() // Filters out null values and ensures type safety
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
                    cubit.toggleSelectAllProperties(homeScreenPagingController);
                    cubit.isBtnSelectAllPropertiesTapped = false;
                    cubit.selectedPropertyList.clear();
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show alert dialog for locked properties
  Future<bool?> _showLockedPropertiesAlert({
    required BuildContext context,
    required int lockedCount,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 24, bottom: 20.0, left: 20, right: 20),
            decoration: BoxDecoration(
              color: AppColors.white.adaptiveColor(
                context,
                lightModeColor: AppColors.white,
                darkModeColor: AppColors.black2E,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  appStrings(context).applyOffer,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const SizedBox(height: 16.0),
                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "The selected $lockedCount ${lockedCount == 1 ? 'property' : 'properties'} already have an applied offer and will be skipped.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).highlightColor,
                        ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cancel button
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppColors.white.adaptiveColor(
                            context,
                            lightModeColor: AppColors.white,
                            darkModeColor: AppColors.black2E,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: AppColors.greyE8.adaptiveColor(
                                context,
                                lightModeColor: AppColors.greyE8,
                                darkModeColor: AppColors.black2E,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          appStrings(context).cancel,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.black14.adaptiveColor(
                                  context,
                                  lightModeColor: AppColors.black14,
                                  darkModeColor: AppColors.white,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Yes button
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            appStrings(context).yes,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show alert dialog when all selected properties are locked
  Future<void> _showAllPropertiesLockedAlert({
    required BuildContext context,
    required int lockedCount,
  }) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 24, bottom: 20.0, left: 20, right: 20),
            decoration: BoxDecoration(
              color: AppColors.white.adaptiveColor(
                context,
                lightModeColor: AppColors.white,
                darkModeColor: AppColors.black2E,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  appStrings(context).applyOffer,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const SizedBox(height: 16.0),
                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "You can't apply offer again on the same $lockedCount ${lockedCount == 1 ? 'applied property' : 'applied properties'}. Please select different properties.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).highlightColor,
                        ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // OK button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        appStrings(context).ok,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
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
  Future<void> buildBlocListener(BuildContext context, HomeState state) async {
    if (state is PropertyListRefresh) {
      context.read<HomeCubit>().resetPropertyList();
      homeScreenPagingController.refresh();
    } else if (state is ItemsPerPageUpdated) {
      // Reset pagination and refresh property list when items per page changes
      final cubit = context.read<HomeCubit>();
      cubit.resetPropertyList();
      homeScreenPagingController.refresh();
      // Call property list API with page 1 and new itemsPerPage
      await cubit.getPropertyList(pageKey: 1);
    } else if (state is PropertyListSuccess) {
      if (state.isLastPage) {
        homeScreenPagingController.appendLastPage(state.propertyList);
      } else {
        homeScreenPagingController.appendPage(state.propertyList, state.currentKey + 1);
      }
    } else if (state is APISuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyCategoryListUpdate) {
      OverlayLoadingProgress.stop();
    } else if (state is AddedToFavorite) {
      OverlayLoadingProgress.stop();
      Utils.snackBar(
        context: context,
        message: state.successMessage,
      );
    } else if (state is PropertyAddFavError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(context: context, message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    } else if (state is PropertyListError) {
      homeScreenPagingController.appendLastPage([]);
      Utils.showErrorMessage(context: context, message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
      (
        context: context,
        message: state.errorMessage,
      );
    } else if (state is NoPropertyFoundState) {
      homeScreenPagingController.appendLastPage([]);
    }
  }
}
