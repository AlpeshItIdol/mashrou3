import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/toggle_widget/toggle_cubit.dart';
import 'package:mashrou3/app/ui/custom_widget/toggle_widget/toggle_row_item.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_filter/cubit/owner_filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../custom_widget/custom_tab_bar/custom_tab_bar.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import 'component/approved_property_widget.dart';
import 'component/sold_out_property_widget.dart';
import 'cubit/owner_home_cubit.dart';

class OwnerHomeScreen extends StatefulWidget with AppBarMixin {
  OwnerHomeScreen({
    super.key,
  });

  @override
  State<OwnerHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<OwnerHomeScreen> with AppBarMixin {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();

    context.read<OwnerHomeCubit>().getData(context);
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
                children: [
                  18.verticalSpace,
                  UIComponent.getSkeletonCategories(),
                  24.verticalSpace,
                  UIComponent.getSkeletonProperty()
                ],
              ),
            );
          }
          return _buildBlocConsumer;
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          gradient: AppColors.primaryGradient,
        ),
        child: FloatingActionButton.extended(
          isExtended: true,
          elevation: 0,
          onPressed: () {
            context.pushNamed(Routes.kAddEditPropertyScreen1,
                extra: false,
                pathParameters: {
                  RouteArguments.id: "0",
                }).then((value) {
              if (value != null && value == true) {
                // _pagingController.refresh();
              }
            });
          },
          backgroundColor: Colors.transparent,
          icon: SVGAssets.plusCircleIcon.toSvg(context: context),
          label: Row(
            children: [
              Text(
                appStrings(context).addProperty,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeCategories() async {
    await Future.delayed(const Duration(milliseconds: 00));
    // Fetch or update the propertyCategory list here
    await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);
    await context
        .read<ToggleCubit>()
        .updateCategories(AppConstants.propertyCategory);
  }

  bool isFetchingData = false;

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocProvider(
      create: (context) => ToggleCubit(AppConstants.propertyCategory),
      child: BlocConsumer<OwnerHomeCubit, OwnerHomeState>(
        listener: buildBlocListener,
        builder: (context, state) {
          OwnerHomeCubit cubit = context.read<OwnerHomeCubit>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTabBar(
                  isScrollable:
                      UIComponent.isSystemFontMax(context) ? true : false,
                  expandedHeight: 105,
                  flexibleSpaceBarWidget: Container(
                    color: AppColors.white.adaptiveColor(context,
                        lightModeColor: AppColors.white,
                        darkModeColor: AppColors.black14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          12.verticalSpace,
                          BlocConsumer<OwnerFilterCubit, OwnerFilterState>(
                            listener: (context, state) {
                              FilterRequestModel? filterRequestModel;
                              if (state is ApplyPropertyFilter) {
                                filterRequestModel = state.filterRequestModel;
                                cubit.updateFilterRequestModel(
                                    filterRequestModel);
                                Future.delayed(Duration.zero, () async {
                                  cubit.resetPropertyList();
                                  await cubit.getPropertyList();
                                });
                              } else if (state is FilterReset) {
                                cubit.updateFilterRequestModel(
                                    FilterRequestModel());
                                Future.delayed(Duration.zero, () async {
                                  cubit.resetPropertyList();
                                  await cubit.getPropertyList();
                                });
                              }
                            },
                            builder: (context, state) {
                              return BlocBuilder<ToggleCubit, int>(
                                builder: (context, selectedIndex) {
                                  if (cubit.selectedItemIndex !=
                                      selectedIndex) {
                                    cubit.selectedItemIndex = selectedIndex;

                                    if (selectedIndex >= 0) {
                                      cubit.selectedCategoryId = AppConstants
                                              .propertyCategory[selectedIndex]
                                              .sId ??
                                          "";

                                      cubit.updateSelectedCategoryId(
                                          cubit.selectedCategoryId);
                                      Future.delayed(Duration.zero, () async {
                                        printf(
                                            "Selected Category ID: $selectedCategoryId");
                                        printf(
                                            "searchText--- ${cubit.searchText}");
                                        cubit.resetPropertyList();
                                        if (!context.mounted) return;
                                        OverlayLoadingProgress.start(context);

                                        await cubit.getPropertyList(
                                          hasMoreData: _shouldFetchAll(
                                              selectedCategoryId),
                                        );
                                        OverlayLoadingProgress.stop();
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
                          12.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  tabsList: [
                    Tab(
                      child: Text(
                        appStrings(context).lblApprovedProperties ?? "",
                      ),
                    ),
                    Tab(
                      child: Text(
                        appStrings(context).lblSoldOutProperties ?? "",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  tabsLength: 2,
                  tabBarViewsList: const [
                    ApprovedPropertyListWidget(),
                    SoldOutPropertyListWidget(),
                  ],
                  onTabControllerUpdated: (tabController) {
                    tabController.animateTo(0);
                  },
                  // bool isFetchingData = false;

                  onTabChanged: (index) async {
                    if (isFetchingData) return; // Prevent simultaneous calls

                    isFetchingData = true;
                    try {
                      // Update sold-out state and reset the list
                      cubit.toggleSoldOut(index == 1);
                      cubit.resetPropertyList();

                      printf(
                          "Fetching properties for Category ID: ${cubit.selectedCategoryId}");

                      // Fetch the property list for the selected tab
                      await cubit.getPropertyList(
                        isSoldOut: cubit.isSoldOut,
                        id: cubit.selectedCategoryId,
                      );
                    } catch (error) {
                      printf("Error fetching properties: $error");
                      // Optionally handle the error here
                    } finally {
                      isFetchingData = false; // Allow new API calls
                    }
                  },

                  // onTabChanged: (index) {
                  //
                  //   cubit.toggleSoldOut(index == 1 ? true : false);
                  //   cubit.resetPropertyList();
                  //
                  //   Future.delayed(const Duration(milliseconds: 500), () {
                  //     printf(
                  //         "Selected Category ID: ${cubit.selectedCategoryId}");
                  //     cubit.getPropertyList(
                  //       isSoldOut: cubit.isSoldOut,
                  //       id: cubit.selectedCategoryId,
                  //     );
                  //   });
                  // },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _shouldFetchAll(String? selectedCategoryId) {
    return selectedCategoryId == null || selectedCategoryId.isEmpty;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(BuildContext context, OwnerHomeState state) {
    if (state is OwnerHomeLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is OwnerHomeError) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyListSuccess) {
      OverlayLoadingProgress.stop();
      context.read<OwnerHomeCubit>().searchText = "";
    } else if (state is NoPropertyFoundState) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyListError) {
      OverlayLoadingProgress.stop();
    } else if (state is AddedToFavorite) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyListError) {
      OverlayLoadingProgress.stop();
    } else if (state is APISuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyCategoryListUpdate) {
      OverlayLoadingProgress.stop();
    }
  }
}
