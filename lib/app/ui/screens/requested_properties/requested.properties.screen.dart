import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/screens/filter/cubit/filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../db/app_preferences.dart';
import '../../../model/verify_response.model.dart';
import '../../custom_widget/toggle_widget/toggle_cubit.dart';
import '../../custom_widget/toggle_widget/toggle_row_item.dart';
import '../../owner_screens/visit_requests_list/model/visit_requests_list_response.model.dart';
import '../property_details/cubit/property_details_cubit.dart';
import 'components/requested_properties_list_item.dart';
import 'cubit/requested_properties_cubit.dart';

class RequestedPropertiesScreen extends StatefulWidget with AppBarMixin {
  RequestedPropertiesScreen({
    super.key,
  });

  @override
  State<RequestedPropertiesScreen> createState() => _RequestedPropertiesScreenState();
}

class _RequestedPropertiesScreenState extends State<RequestedPropertiesScreen> with AppBarMixin {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<RequestedPropertiesCubit>().getData(context);
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
        title: appStrings(context).lblRequestedProperties,
      ),
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
    );
  }

  Future<void> _initializeCategories() async {
    await Future.delayed(const Duration(milliseconds: 00));
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
        child: BlocConsumer<RequestedPropertiesCubit, RequestedPropertiesState>(
          listener: buildBlocListener,
          builder: (context, state) {
            RequestedPropertiesCubit cubit = context.read<RequestedPropertiesCubit>();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  BlocListener<PropertyDetailsCubit, PropertyDetailsState>(
                    listener: (context, state) {
                      if (state is AddedToFavoriteForPropertyDetail) {
                        Future.delayed(Duration.zero, () async {
                          cubit.resetPropertyList();
                          await cubit.getVisitRequestsList();
                        });
                      }
                    },
                    child: BlocConsumer<FilterCubit, FilterState>(
                      listener: (context, state) {
                        FilterRequestModel? filterRequestModel;
                        if (state is ApplyPropertyFilter) {
                          filterRequestModel = state.filterRequestModel;
                          cubit.updateFilterRequestModel(filterRequestModel);
                        } else if (state is FilterReset) {
                          cubit.updateFilterRequestModel(FilterRequestModel());
                        }

                        Future.delayed(Duration.zero, () async {
                          cubit.resetPropertyList();
                          await cubit.getVisitRequestsList();
                        });
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
                                  cubit.resetPropertyList();
                                  await cubit.getVisitRequestsList(
                                    hasMoreData: _shouldFetchAll(selectedCategoryId),
                                  );
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
                  Expanded(
                    child: _buildPropertyListContent(context, cubit, state),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildPropertyListContent(BuildContext context, RequestedPropertiesCubit cubit, RequestedPropertiesState state) {
    if (state is RequestedPropertiesInitial) {
      return Container();
    }

    if (state is NoRequestedPropertiesFoundState) {
      return Center(
        child: UIComponent.noDataWidgetWithInfo(
          title: appStrings(context).emptyPropertyList,
          info: appStrings(context).emptyPropertyListInfo,
          context: context,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!cubit.isLoadingMore && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 20) {
          cubit.loadMoreProperties(1, context);
        }
        return false;
      },
      child: Skeletonizer(
        enabled: !cubit.hasShownSkeleton && (state is RequestedPropertiesListLoading || cubit.isLoadingMore),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            if (cubit.filteredRequestedPropertiesList?.isEmpty ?? true) {
              return UIComponent.getSkeletonProperty();
            }

            if (index == cubit.filteredRequestedPropertiesList!.length) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.colorPrimary,
              ));
            }

            VisitRequestData requestedPropertiesData = cubit.filteredRequestedPropertiesList?[index] ?? VisitRequestData();

            return BlocListener<RequestedPropertiesCubit, RequestedPropertiesState>(
              listener: (context, state) {},
              child: RequestedPropertiesListItem(
                propertyName: requestedPropertiesData.property?.title ?? '',
                propertyImg: Utils.getLatestPropertyImage(
                        requestedPropertiesData.property?.propertyFiles ?? [], requestedPropertiesData.property?.thumbnail ?? "") ??
                    "",
                propertyImgCount: (Utils.getAllImageFiles(requestedPropertiesData.property?.propertyFiles ?? []).length +
                        ((requestedPropertiesData.property?.thumbnail != null && requestedPropertiesData.property!.thumbnail!.isNotEmpty)
                            ? 1
                            : 0))
                    .toString(),
                propertyPrice: requestedPropertiesData.property?.price?.amount?.toString() ?? '',
                isSoldOut: requestedPropertiesData.property?.isSoldOut ?? false,
                isVisitor: cubit.isVendor == true ? false : true,
                propertyLocation:
                    '${requestedPropertiesData.property?.city?.isNotEmpty == true ? requestedPropertiesData.property?.city : ''}'
                    '${(requestedPropertiesData.property?.city?.isNotEmpty == true && requestedPropertiesData.property?.country?.isNotEmpty == true) ? ', ' : ''}'
                    '${requestedPropertiesData.property?.country?.isNotEmpty == true ? requestedPropertiesData.property?.country : ''}',
                propertyArea: Utils.formatArea(
                    '${requestedPropertiesData.property?.area?.amount ?? ''}', requestedPropertiesData.property?.area?.unit ?? ''),
                propertyRating: requestedPropertiesData.property?.rating ?? '0',
                reqStatus: requestedPropertiesData.reqStatus?.toLowerCase().toString() ?? "",
                reqStatusText: requestedPropertiesData.reqStatus?.toLowerCase().toString() == "approved"
                    ? appStrings(context).btnApproved
                    : requestedPropertiesData.reqStatus?.toLowerCase().toString() == "pending"
                        ? appStrings(context).btnPending
                        : appStrings(context).btnRejected,
                onPropertyTap: () {
                  context.pushNamed(Routes.kPropertyDetailScreen, pathParameters: {
                    RouteArguments.propertyId: requestedPropertiesData.property?.sId ?? "0",
                    RouteArguments.propertyLat: (requestedPropertiesData.property?.propertyLocation?.latitude ?? 0.00).toString(),
                    RouteArguments.propertyLng: (requestedPropertiesData.property?.propertyLocation?.longitude ?? 0.00).toString(),
                  }, queryParameters: {
                    RouteArguments.isFromVisitReq: "true",
                    RouteArguments.rejectReason: Uri.encodeComponent(requestedPropertiesData.reqDenyReasons ?? ""),
                  }).then((value) {
                    if (value != null && value == true) {}
                  });
                },
                requiredFavorite: false,
                propertyPriceCurrency: requestedPropertiesData.property?.price?.currencySymbol ?? '',
                respondedDate: requestedPropertiesData.createdAt ?? "",
              ),
            );
          },
          itemCount: (cubit.filteredRequestedPropertiesList?.length ?? 0) + (cubit.isLoadingMore ? 1 : 0),
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
  Future<void> buildBlocListener(BuildContext context, RequestedPropertiesState state) async {
    if (state is RequestedPropertiesLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is RequestedPropertiesListLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is RequestedPropertiesListSuccess) {
      OverlayLoadingProgress.stop();
      context.read<RequestedPropertiesCubit>().searchText = "";
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
    } else if (state is RequestedPropertiesListError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
      if (state.errorMessage.toLowerCase().contains("expire")) {
        // Reset preferences
        final prefs = GetIt.I<AppPreferences>();
        await prefs.isGuestUser(value: false);
        await prefs.isLoggedIn(value: false);
        await prefs.isProfileCompleted(value: false);
        await prefs.isVerified(value: false);
        await prefs.setUserDetails(VerifyResponseData());
        await prefs.saveUserID(value: "");
        await prefs.setUserRole("");
        await prefs.saveSelectedCountryID(value: "");

        if (!context.mounted) return;
        context.goNamed(Routes.kLoginScreen);
      }
    } else if (state is NoRequestedPropertiesFoundState) {
      OverlayLoadingProgress.stop();
    }
  }

  bool _shouldFetchAll(String? selectedCategoryId) {
    return selectedCategoryId == null || selectedCategoryId.isEmpty;
  }

  Future<VisitRequestData?> showVisitRequestsBottomSheet(BuildContext context, List<VisitRequestData>? visitRequestsList) async {
    return showModalBottomSheet<VisitRequestData>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        final ScrollController scrollController = ScrollController();
        bool isFetchingMore = false;

        RequestedPropertiesCubit cubit = context.read<RequestedPropertiesCubit>();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Visit Request",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!isFetchingMore && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
                      cubit.loadMoreProperties(1, context);
                      return true; // Indicates the notification is handled
                    }
                    return false;
                  },
                  // onNotification: (scrollInfo) {
                  //   if (!isFetchingMore &&
                  //       scrollInfo.metrics.pixels >=
                  //           scrollInfo.metrics.maxScrollExtent - 20) {
                  //     cubit.loadMoreProperties(1, context);
                  //   }
                  //   return false;
                  // },
                  child: ListView.separated(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: (cubit.requestedPropertiesList?.length ?? 0) + (isFetchingMore ? 1 : 0),
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      // Show a loading indicator at the end of the list
                      if (index == (cubit.requestedPropertiesList?.length ?? 0)) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final visitRequest = cubit.requestedPropertiesList![index];
                      return ListTile(
                        title: Text(visitRequest.firstName ?? "Unknown"),
                        subtitle: Text(visitRequest.lastName ?? ""),
                        onTap: () {
                          Navigator.pop(context, visitRequest);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
