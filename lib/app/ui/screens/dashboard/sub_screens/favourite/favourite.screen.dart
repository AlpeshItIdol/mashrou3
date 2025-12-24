import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/filter/cubit/fav_filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/cubit/property_details_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/add_rating_cubit.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_constants.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../../model/property/property_list_response_model.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../../custom_widget/toggle_widget/toggle_cubit.dart';
import '../../../../custom_widget/toggle_widget/toggle_row_item.dart';
import '../home/components/property_list_item.dart';
import 'cubit/favourite_cubit.dart';

class FavouriteScreen extends StatefulWidget with AppBarMixin {
  FavouriteScreen({
    super.key,
  });

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final PagingController<int, PropertyData> favScreenPagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    context.read<FavouriteCubit>().refreshData(context);
    favScreenPagingController.addPageRequestListener((pageKey) {
      context.read<FavouriteCubit>().getPropertyList(pageKey: pageKey);
    });
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
        child: BlocConsumer<FavouriteCubit, FavouriteState>(
          listener: buildBlocListener,
          builder: (context, state) {
            FavouriteCubit cubit = context.read<FavouriteCubit>();

            return BlocListener<AddRatingCubit, AddRatingState>(
              listener: (context, state) {
                if (state is AddRatingReviewSuccess) {
                  Future.delayed(Duration.zero, () async {
                    favScreenPagingController.refresh();
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    BlocListener<PropertyDetailsCubit, PropertyDetailsState>(
                      listener: (context, state) {
                        if (state is AddedToFavoriteForPropertyDetail) {
                          Future.delayed(Duration.zero, () async {
                            favScreenPagingController.refresh();
                          });
                        }
                      },
                      child: BlocConsumer<FavFilterCubit, FavFilterState>(
                        listener: (context, state) {
                          FilterRequestModel? filterRequestModel;
                          if (state is FavApplyPropertyFilter) {
                            filterRequestModel = state.filterRequestModel;
                            cubit.updateFilterRequestModel(filterRequestModel);
                            Future.delayed(Duration.zero, () async {
                              favScreenPagingController.refresh();
                            });
                          } else if (state is FavFilterReset) {
                            cubit
                                .updateFilterRequestModel(FilterRequestModel());
                            Future.delayed(Duration.zero, () async {
                              favScreenPagingController.refresh();
                            });
                          }
                        },
                        builder: (context, state) {
                          return BlocBuilder<ToggleCubit, int>(
                            builder: (context, selectedIndex) {
                              if (cubit.selectedItemIndex != selectedIndex) {
                                cubit.selectedItemIndex = selectedIndex;

                                if (selectedIndex >= 0) {
                                  cubit.selectedCategoryId = AppConstants
                                      .propertyCategory[selectedIndex].sId;

                                  Future.delayed(Duration.zero, () {
                                    printf(
                                        "Selected Category ID: ${cubit.selectedCategoryId}");
                                    favScreenPagingController.refresh();
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
                    ),
                    20.verticalSpace,
                    Text(
                      appStrings(context).lblFavorites,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                    16.verticalSpace,
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
  Widget _buildLazyLoadPropertyList(
      BuildContext context, FavouriteCubit cubit, FavouriteState state) {
    return PagedListView<int, PropertyData>.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) {
        return 12.verticalSpace;
      },
      pagingController: favScreenPagingController,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<PropertyData>(
        firstPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: EdgeInsets.zero,
            child: UIComponent.getSkeletonProperty(),
          );
        },
        itemBuilder: (context, item, index) {
          return PropertyListItem(
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
            isVisitor: cubit.isVendor == true ? false : true,
            isSoldOut: item.isSoldOut ?? false,
            propertyPrice: item.price?.amount?.toString(),
            propertyLocation:
                '${item.city?.isNotEmpty == true ? item.city : ''}'
                '${(item.city?.isNotEmpty == true && item.country?.isNotEmpty == true) ? ', ' : ''}'
                '${item.country?.isNotEmpty == true ? item.country : ''}',
            propertyArea: Utils.formatArea(
                '${item.area?.amount ?? ''}', item.area?.unit ?? ''),
            propertyRating: item.rating.toString() ?? '0',
            onPropertyTap: () {
              context.pushNamed(Routes.kPropertyDetailScreen, pathParameters: {
                RouteArguments.propertyId: item.sId ?? "0",
                RouteArguments.propertyLat:
                    (item.propertyLocation?.latitude ?? 0.00).toString(),
                RouteArguments.propertyLng:
                    (item.propertyLocation?.longitude ?? 0.00).toString(),
              }).then((value) {
                if (value != null && value == true) {
                  // _pagingController.refresh();
                }
              });
            },
            isFavorite: item.favorite ?? cubit.isFavorite,
            isLocked: item.isLocked,
            isLockedByMe: item.isLockedByMe,
            offerData: item.offerData,
            onFavouriteToggle: (isFavourite) async {
              favScreenPagingController.refresh();

              await cubit
                  .addRemoveFavorite(
                      propertyId: item.sId ?? "", isFav: isFavourite)
                  .then((value) {
                Future.delayed(Duration.zero, () async {
                  if (!mounted) return;
                  favScreenPagingController.refresh();
                });
              });
            },
            propertyPriceCurrency: item.price?.currencySymbol ?? '',
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: UIComponent.noDataWidgetWithInfo(
                title: appStrings(context).yourFavoritesIsEmpty,
                info: appStrings(context).yourFavoritesIsEmptyData,
                context: context,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(BuildContext context, FavouriteState state) {
    if (state is FavouriteLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is AddedToFavorite) {
      OverlayLoadingProgress.stop();
      Utils.snackBar(
        context: context,
        message: state.successMessage,
      );
    } else if (state is PropertyFavListSuccess) {
      if (state.isLastPage) {
        favScreenPagingController.appendLastPage(state.propertyList);
      } else {
        favScreenPagingController.appendPage(
            state.propertyList, state.currentKey + 1);
      }
    } else if (state is NoPropertyFavFoundState) {
      favScreenPagingController.appendLastPage([]);
      OverlayLoadingProgress.stop();
    } else if (state is PropertyFavListRefresh) {
      favScreenPagingController.refresh();
    } else if (state is FavCategoryUpdated) {
      OverlayLoadingProgress.stop();
    } else if (state is FavFilterModelUpdate) {
      OverlayLoadingProgress.stop();
    } else if (state is PropertyListError) {
      favScreenPagingController.appendLastPage([]);
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    } else if (state is FavouriteError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
