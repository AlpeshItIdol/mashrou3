import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/subscreen/offer_list/cubit/offer_listing_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/subscreen/offer_list/offer_list_item.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../../../../../../config/network/network_constants.dart';
import '../../../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../../../config/resources/app_constants.dart';
import '../../../../../../../../../config/services/analytics_service.dart';
import '../../../../../../../../model/base/base_model.dart';
import '../../../../../../../../model/offers/my_offers_list_response_model.dart';
import '../../../../../../../../model/vendor_list_response.model.dart';
import '../../../../../../../../navigation/route_arguments.dart';
import '../../../../../../../../repository/offers_management_repository.dart';
import '../../../model/property_vendor_finance_data.dart';
import '../../../vendor_categories/cubit/vendor_categories_cubit.dart';

class OfferListingScreen extends StatefulWidget {
  final List<OfferData> offersList;

  const OfferListingScreen({super.key, required this.offersList});

  @override
  State<OfferListingScreen> createState() => _OfferListingScreenState();
}

class _OfferListingScreenState extends State<OfferListingScreen> with AppBarMixin {
  @override
  void initState() {
    super.initState();
    printf("Offer List Length => ${widget.offersList.length}");
    context.read<OfferListingCubit>().getData(context);
  }

  @override
  Widget build(BuildContext context) {
    OfferListingCubit cubit = context.read<OfferListingCubit>();
    return BlocConsumer<OfferListingCubit, OfferListingState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            appBar: buildAppBar(
              context: context,
              requireLeading: true,
              title: appStrings(context).offerListing,
            ),
            body: widget.offersList.isEmpty
                ? Center(
                    child: UIComponent.noDataWidgetWithInfo(
                      title: appStrings(context).emptyOffersList,
                      info: appStrings(context).emptyOffersListInfo,
                      context: context,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (widget.offersList.isEmpty) {
                        return UIComponent.getSkeletonProperty();
                      }

                      OfferData myOffersListData = widget.offersList[index];

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == (widget.offersList.length) - 1 ? 24 : 0,
                        ),
                        child: OfferListItem(
                          offerData: myOffersListData,
                          companyLogo: cubit.companyLogo,
                          onTap: () {
                            //Log the offer view event
                            AnalyticsService.logEvent(
                              eventName: "offer_view",
                              parameters: {
                                AppConstants.analyticsIdOfUserKey: cubit.selectedUserId,
                                AppConstants.analyticsOfferIdKey: widget.offersList[index].sId,
                                AppConstants.analyticsUserTypeKey: cubit.selectedRole
                              },
                            );
                            context.pushNamed(Routes.kOfferDetailScreen,
                                pathParameters: {
                                  RouteArguments.isDraftOffer: "false",
                                },
                                extra: myOffersListData.sId?.trim());
                          },
                        ),
                      );
                    },
                    itemCount: widget.offersList.length,
                    separatorBuilder: (context, index) => 12.verticalSpace,
                  ),
                 bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: AppColors.grey8A,
                  child: InkWell(
                    onTap: () async {
                      // Vendor

                    },
                    child: Center(
                      child: Text(
                        "View Vendor Categories Details",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),),
          ),
          );
        });
  }

  Future<void> buildBlocListener(BuildContext context, OfferListingState state) async {}

  //
  // Future<void> onItemTap(String vendorCategoryId, VendorCategoriesCubit cubit) async {
  //   // Persist selection so downstream screens/services know the chosen category
  //   context.read<VendorCategoriesCubit>().setPropertyData(
  //     PropertyVendorFinanceData(vendorCategoryId: vendorCategoryId),
  //   );
  //
  //   final propertyId = cubit.service.getPropertyId() ?? widget.propertyId;
  //
  //   // Directly fetch vendors for this category + property
  //   final repo = GetIt.I<OffersManagementRepository>();
  //   final response = await repo.getVendorList(
  //     queryParameters: {
  //       NetworkParams.kVendorCategory: vendorCategoryId,
  //       NetworkParams.kPropertyId: propertyId,
  //       NetworkParams.kPage: "1",
  //       NetworkParams.kItemPerPage: "10",
  //       NetworkParams.kSortOrder: "desc",
  //       NetworkParams.kSortField: "createdAt",
  //     },
  //     searchText: cubit.searchCtl.text.trim(),
  //   );
  //
  //   if (response is SuccessResponse && response.data is VendorListResponseModel) {
  //     final model = response.data as VendorListResponseModel;
  //     // final users = model.data.user ?? [];
  //     // if (users.isNotEmpty) {
  //     //   final firstVendorId = users.first.sId ?? "";
  //     //   if (firstVendorId.isNotEmpty) {
  //     //     // Persist for downstream flows (e.g., finance request CTA)
  //     //     cubit.service.setVendorId(firstVendorId);
  //     //     // Open vendor details directly
  //     //     if (mounted) {
  //     //       context.pushNamed(
  //     //         Routes.kVendorDetailScreen,
  //     //         extra: firstVendorId,
  //     //         queryParameters: {RouteArguments.isFromFinanceReq: "false"},
  //     //       );
  //     //       return;
  //     //     }
  //     if (mounted) {
  //       context.pushNamed(
  //         Routes.kVendorDetailScreen,
  //         extra: widget.vendorId,
  //         queryParameters: {RouteArguments.isFromFinanceReq: "false"},
  //       );
  //
  //
  //         return;
  //       }
  //     }
  //   }
}
