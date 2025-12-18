import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_property_details/cubit/owner_property_details_cubit.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../config/utils.dart';
import '../../../../../../../utils/app_localization.dart';
import '../../../../../../../utils/ui_components.dart';
import '../../../../../../model/property/property_list_response_model.dart';
import '../../../../../../navigation/route_arguments.dart';
import '../../../../../../navigation/routes.dart';
import '../../../../../screens/dashboard/sub_screens/home/components/property_list_item.dart';
import '../cubit/owner_home_cubit.dart';

class SoldOutPropertyListWidget extends StatelessWidget {
  const SoldOutPropertyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OwnerPropertyDetailsCubit, OwnerPropertyDetailsState>(
      listener: (context, state) {
        if (state is DeletePropertySuccess) {
          context.read<OwnerHomeCubit>().resetPropertyList();
          context.read<OwnerHomeCubit>().getPropertyList(isSoldOut: true);
        }
      },
      child: BlocConsumer<OwnerHomeCubit, OwnerHomeState>(
        builder: (context, state) {
          OwnerHomeCubit cubit = context.read<OwnerHomeCubit>();

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 16.0),
                  child: _buildPropertyListContent(context, cubit, state),
                ),
              ),
            ],
          );
        },
        listener: (BuildContext context, OwnerHomeState state) {},
      ),
    );
  }

  Widget _buildPropertyListContent(
      BuildContext context, OwnerHomeCubit cubit, OwnerHomeState state) {
    if (state is OwnerHomeInitial) {
      return Container();
    }

    if (state is NoPropertyFoundState) {
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
        if (!cubit.isLoadingMore &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 20) {
          cubit.loadMoreProperties(context);
        }
        return false;
      },
      child: Skeletonizer(
        enabled: !cubit.hasShownSkeleton &&
            (state is PropertyListLoading || cubit.isLoadingMore) &&
            (state is SoldOutLoadedState || cubit.isSoldOut),
        child: cubit.filteredPropertyList != null &&
                cubit.filteredPropertyList!.isEmpty
            ? Center(
                child: UIComponent.noDataWidgetWithInfo(
                  title: appStrings(context).emptyPropertyList,
                  info: appStrings(context).emptyPropertyListInfo,
                  context: context,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (cubit.filteredPropertyList?.isEmpty ?? true) {
                    return UIComponent.getSkeletonProperty();
                  }

                  if (index == cubit.filteredPropertyList!.length) {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.colorPrimary,
                    ));
                  }

                  // Render each sold-out property item
                  PropertyData propertyData =
                      cubit.filteredPropertyList?[index] ?? PropertyData();

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          index == (cubit.filteredPropertyList?.length ?? 0) - 1
                              ? 78
                              : 0,
                    ),
                    child: PropertyListItem(
                      isVisitor: false,
                      isSoldOut: true,
                      propertyName: propertyData.title ?? '',
                      propertyImg: Utils.getLatestPropertyImage(
                              propertyData.propertyFiles ?? [],
                              propertyData.thumbnail ?? "") ??
                          "",
                      propertyImgCount: (Utils.getAllImageFiles(
                                      propertyData.propertyFiles ?? [])
                                  .length +
                              ((propertyData.thumbnail != null &&
                                      propertyData.thumbnail!.isNotEmpty)
                                  ? 1
                                  : 0))
                          .toString(),
                      propertyPrice: propertyData.price?.amount?.toString(),
                      propertyLocation:
                          '${propertyData.city?.isNotEmpty == true ? propertyData.city : ''}'
                          '${(propertyData.city?.isNotEmpty == true && propertyData.country?.isNotEmpty == true) ? ', ' : ''}'
                          '${propertyData.country?.isNotEmpty == true ? propertyData.country : ''}',
                      propertyArea: Utils.formatArea(
                          '${propertyData.area?.amount ?? ''}',
                          propertyData.area?.unit ?? ''),
                      propertyRating: propertyData.rating.toString() ?? '0',
                      onPropertyTap: () {
                        context.pushNamed(Routes.kOwnerPropertyDetailScreen,
                            extra: false,
                            pathParameters: {
                              RouteArguments.propertyId:
                                  propertyData.sId ?? "0",
                              RouteArguments.propertyLat:
                                  (propertyData.propertyLocation?.latitude ??
                                          0.00)
                                      .toString(),
                              RouteArguments.propertyLng:
                                  (propertyData.propertyLocation?.longitude ??
                                          0.00)
                                      .toString(),
                            }).then((value) {
                          if (value != null && value == true) {
                            // _pagingController.refresh();
                          }
                        });
                      },
                      requiredFavorite: false,
                      isFavorite: propertyData.favorite ?? cubit.isFavorite,
                      propertyPriceCurrency:
                          propertyData.price?.currencySymbol ?? '',
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
}
