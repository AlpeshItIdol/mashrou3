import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_filter/cubit/in_review_filter_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_property_details/cubit/owner_property_details_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/resources/app_constants.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../custom_widget/toggle_widget/toggle_cubit.dart';
import '../../../../custom_widget/toggle_widget/toggle_row_item.dart';
import '../../../../screens/dashboard/sub_screens/home/components/property_list_item.dart';
import 'cubit/in_review_cubit.dart';
import 'model/in_review_list_response_model.dart';

class InReviewScreen extends StatefulWidget with AppBarMixin {
  InReviewScreen({
    super.key,
  });

  @override
  State<InReviewScreen> createState() => _InReviewScreenState();
}

class _InReviewScreenState extends State<InReviewScreen> {
  @override
  void initState() {
    context.read<InReviewCubit>().getData(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.read<InReviewCubit>().sortOptions.isEmpty) {
      context
          .read<InReviewCubit>()
          .getSortData(context); // Call your async function here
    }
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
      floatingActionButton: BlocConsumer<InReviewCubit, InReviewState>(
        listener: buildBlocListener,
        builder: (context, state) {
          InReviewCubit cubit = context.read<InReviewCubit>();

          return Container(
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
              onPressed: () async {
                context.pushNamed(Routes.kAddEditPropertyScreen1,
                    extra: true,
                    pathParameters: {RouteArguments.id: "0"}).then((value) {
                  Future.delayed(Duration.zero, () {
                    printf(
                        "Selected Category ID: ${AppConstants.propertyCategory[context.read<InReviewCubit>().selectedItemIndex].sId}");
                    cubit.inReviewPropertyList = [];
                    cubit.filteredPropertyList = [];
                    cubit.currentPage = 1;
                    cubit.totalPage = 1;
                    cubit.hasShownSkeleton = false;
                    cubit.getPropertyList(
                        hasMoreData: false,
                        id: AppConstants
                            .propertyCategory[cubit.selectedItemIndex].sId);
                  });
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
          );
        },
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

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocProvider(
        create: (context) {
          return ToggleCubit(AppConstants.propertyCategory);
        },
        child: BlocConsumer<InReviewCubit, InReviewState>(
          listener: buildBlocListener,
          builder: (context, state) {
            InReviewCubit cubit = context.read<InReviewCubit>();

            return BlocListener<OwnerPropertyDetailsCubit,
                OwnerPropertyDetailsState>(
              listener: (context, state) async {
                if (state is DeletePropertySuccess) {
                  cubit.resetPropertyList();
                  await cubit.getPropertyList();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    BlocConsumer<InReviewFilterCubit, InReviewFilterState>(
                      listener: (context, state) {
                        FilterRequestModel? filterRequestModel;
                        if (state is ApplyInReviewFilter) {
                          filterRequestModel = state.filterRequestModel;
                          cubit.updateFilterRequestModel(filterRequestModel);
                          Future.delayed(Duration.zero, () async {
                            cubit.resetPropertyList();
                            await cubit.getPropertyList();
                          });
                        } else if (state is InReviewFilterReset) {
                          cubit.updateFilterRequestModel(FilterRequestModel());
                          Future.delayed(Duration.zero, () async {
                            cubit.resetPropertyList();
                            await cubit.getPropertyList();
                          });
                        }
                      },
                      builder: (context, state) {
                        return BlocBuilder<ToggleCubit, int>(
                          builder: (context, selectedIndex) {
                            if (cubit.selectedItemIndex != selectedIndex) {
                              cubit.selectedItemIndex = selectedIndex;

                              if (selectedIndex >= 0) {
                                String? selectedCategoryId = AppConstants
                                    .propertyCategory[selectedIndex].sId;
                                cubit.updateSelectedCategoryId(
                                    selectedCategoryId ?? "");
                                Future.delayed(Duration.zero, () {
                                  printf(
                                      "Selected Category ID: ${cubit.selectedCategoryId}");
                                  cubit.inReviewPropertyList = [];
                                  cubit.filteredPropertyList = [];
                                  cubit.currentPage = 1;
                                  cubit.totalPage = 1;
                                  cubit.hasShownSkeleton = false;
                                  cubit.getPropertyList(
                                      hasMoreData: true,
                                      id: cubit.selectedCategoryId);
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
                    Text(
                      appStrings(context).lblMyProperties,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                    16.verticalSpace,
                    Expanded(
                      child: _buildPropertyListContent(context, cubit, state),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _buildPropertyListContent(
      BuildContext context, InReviewCubit cubit, InReviewState state) {
    if (state is InReviewInitial) {
      return Container();
    }

    if (cubit.filteredPropertyList?.isEmpty ?? true) {
      return Center(
        child: UIComponent.noDataWidgetWithInfo(
          title: appStrings(context).emptyPropertyList,
          info: appStrings(context).emptyPropertyListInfo,
          context: context,
        ),
      );
    }

    if (state is NoPropertyFoundState) {
      return Center(
        child: UIComponent.noDataWidgetWithInfo(
          title: appStrings(context).yourReviewListIsEmpty,
          info: appStrings(context).yourReviewListIsEmptyData,
          context: context,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!cubit.isLoadingMore &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 20) {
          cubit.loadMoreProperties(1, context);
        }
        return false;
      },
      child: Skeletonizer(
        enabled: !cubit.hasShownSkeleton &&
            (state is PropertyListLoading || cubit.isLoadingMore),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            if (cubit.filteredPropertyList?.isEmpty ?? true) {
              return Skeletonizer(
                  enabled: true, child: UIComponent.getSkeletonProperty());
            }
            if (index == cubit.filteredPropertyList!.length) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.colorPrimary,
              ));
            }

            PropertyReqData propertyData =
                cubit.filteredPropertyList?[index] ?? PropertyReqData();

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == (cubit.filteredPropertyList?.length ?? 0) - 1
                    ? 78
                    : 0,
              ),
              child: PropertyListItem(
                propertyName: propertyData.title ?? '',
                propertyImg: Utils.getLatestPropertyImage(
                        propertyData.propertyFiles ?? [],
                        propertyData.thumbnail ?? "") ??
                    "",
                propertyImgCount:
                    (Utils.getAllImageFiles(propertyData.propertyFiles ?? [])
                                .length +
                            ((propertyData.thumbnail != null &&
                                    propertyData.thumbnail!.isNotEmpty)
                                ? 1
                                : 0))
                        .toString(),
                propertyPrice: propertyData.price?.amount?.toString(),
                  isVisitor: false,isSoldOut:false,
                propertyLocation:
                    '${propertyData.city?.isNotEmpty == true ? propertyData.city : ''}'
                    '${(propertyData.city?.isNotEmpty == true && propertyData.country?.isNotEmpty == true) ? ', ' : ''}'
                    '${propertyData.country?.isNotEmpty == true ? propertyData.country : ''}',
                propertyArea: Utils.formatArea(
                    '${propertyData.area?.amount ?? ''}',
                    propertyData.area?.unit ?? ''),
                propertyRating: '0',
                requiredDelete: false,
                createdAt: propertyData.createdAt,
                reqStatusText: propertyData.reqStatus
                            ?.toLowerCase()
                            .toString() ==
                        "approved"
                    ? appStrings(context).btnApproved
                    : propertyData.reqStatus?.toLowerCase().toString() ==
                            "pending"
                        ? appStrings(context).btnPending
                        : propertyData.reqStatus?.toLowerCase().toString() ==
                                "rejected"
                            ? appStrings(context).btnRejected
                            : "",
                reqStatus:
                    propertyData.reqStatus?.toLowerCase().toString() ?? "",
                onDeleteTap: () {},
                onPropertyTap: () {
                  context.pushNamed(Routes.kOwnerPropertyDetailScreen,
                      extra: true,
                      pathParameters: {
                        RouteArguments.propertyId: propertyData.sId ?? "0",
                        RouteArguments.propertyLat:
                            (propertyData.propertyLocation?.latitude ?? 0.00)
                                .toString(),
                        RouteArguments.propertyLng:
                            (propertyData.propertyLocation?.longitude ?? 0.00)
                                .toString(),
                      }).then((value) {
                    if (value != null && value == true) {
                      // _pagingController.refresh();
                    }
                  });
                },
                requiredFavorite: false,
                propertyPriceCurrency: propertyData.price?.currencySymbol ?? '',
              ),
            );
          },
          itemCount: (cubit.filteredPropertyList?.length ?? 0) +
              (cubit.isLoadingMore ? 1 : 0),
          separatorBuilder: (context, index) => 12.verticalSpace,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(BuildContext context, InReviewState state) {
    if (state is NoPropertyFoundState) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyListSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyListError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    } else if (state is AddedToFavorite) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyListError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
