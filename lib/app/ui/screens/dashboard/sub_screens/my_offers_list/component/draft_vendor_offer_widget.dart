import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/my_offers_list/component/vendor_my_offer_card.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../config/resources/app_assets.dart';
import '../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../config/resources/app_values.dart';
import '../../../../../../../utils/ui_components.dart';
import '../../../../../../model/offers/my_offers_list_response_model.dart';
import '../../../../../../navigation/route_arguments.dart';
import '../../../../../../navigation/routes.dart';
import '../../../../../custom_widget/common_row_bottons.dart';
import '../cubit/my_offers_list_cubit.dart';

class DraftVendorOfferWidget extends StatelessWidget {
  const DraftVendorOfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyOffersListCubit, MyOffersListState>(
      builder: (context, state) {
        MyOffersListCubit cubit = context.read<MyOffersListCubit>();

        return Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16, top: 16.0),
                child: _buildOffersListContent(context, cubit, state),
              ),
            ),
          ],
        );
      },
      listener: (BuildContext context, MyOffersListState state) {},
    );
  }

  Widget _buildOffersListContent(
      BuildContext context, MyOffersListCubit cubit, MyOffersListState state) {
    if (state is MyOffersListInitial) {
      return Container();
    }
    if (state is NoAddMyOffersFoundState) {
      return SizedBox(
        height: AppValues.screenHeight * 0.8,
        child: Center(
          child: UIComponent.noDataWidgetWithInfo(
            title: appStrings(context).lblNoOfferTitle,
            info: appStrings(context).lblNoOfferContent,
            context: context,
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!cubit.isLoadingMore &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 20) {
          cubit.loadMoreMyOffers(1, context);
        }
        return false;
      },
      child: Skeletonizer(
        enabled: !cubit.hasShownSkeleton &&
            (state is AddMyOffersLoading || cubit.isLoadingMore),
        child: cubit.filteredVendorOffers != null &&
                cubit.filteredVendorOffers!.isEmpty
            ? Center(
                child: UIComponent.noDataWidgetWithInfo(
                  title: appStrings(context).lblNoOfferTitle,
                  info: appStrings(context).lblNoOfferContent,
                  context: context,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (cubit.filteredVendorOffers?.isEmpty ?? true) {
                    return UIComponent.getSkeletonProperty();
                  }

                  if (index == cubit.filteredVendorOffers!.length) {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.colorPrimary,
                    ));
                  }

                  // Render each approved offer item
                  OfferData myOffersListData =
                      cubit.filteredVendorOffers?[index] ?? OfferData();
                  myOffersListData.companyLogo =
                      cubit.userSavedData?.users?.companyLogo ?? "";
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          index == (cubit.filteredVendorOffers?.length ?? 0) - 1
                              ? 78
                              : 0,
                    ),
                    child: VendorMyOfferCard(
                      offerData: myOffersListData,
                      onTap: () {
                        // context.pushNamed(Routes.kOfferDetailScreen,
                        //     pathParameters: {
                        //       RouteArguments.isDraftOffer: "true",
                        //     },
                        //     extra: myOffersListData.sId?.trim());
                        final id = myOffersListData.sId?.trim();
                        if (id != null && id.isNotEmpty) {
                          context.pushNamed(
                            Routes.kOfferDetailScreen,
                            pathParameters: {
                              'offerId': id,
                              'isDraftOffer': 'true',
                            },
                            extra: id,
                            /*pathParameters: {
                              RouteArguments.offerId: offerId,
                              RouteArguments.isDraftOffer: "false",
                            },*/
                            queryParameters: {
                              // RouteArguments.vendorId: myOffersListData.vendorId,
                              // RouteArguments.isForVendor: "true",
                              RouteArguments.isFromVendor: "true",
                            },
                          );
                        } else {
                          // Handle missing id (skip navigation, show message, or log)
                        }
                      },
                      onDeleteTap: (index1, offerId) {
                        _showDeleteOfferConfirmationDialog(context, () {
                          cubit.deleteOffer(offerId, index);
                        });
                      },
                      reqStatus: myOffersListData.reqStatus
                              ?.toLowerCase()
                              .toString() ??
                          "",
                      reqStatusText: myOffersListData.reqStatus
                                  ?.toLowerCase()
                                  .toString() ==
                              "approved"
                          ? appStrings(context).btnApproved
                          :myOffersListData.reqStatus
                                          ?.toLowerCase()
                                          .toString() ==
                                      "rejected"
                                  ? appStrings(context).btnRejected
                                  : "",
                      index: index,
                      onEditTap: (id) {
                        context
                            .pushNamed(Routes.kAddVendorOffersScreen,
                                extra: myOffersListData)
                            .then((value) async {
                          await cubit.refreshData(context);
                        });
                      },
                      companyLogo: myOffersListData.companyLogo ?? "",
                    ),
                  );
                },
                itemCount: (cubit.filteredVendorOffers?.length ?? 0) +
                    (cubit.isLoadingMore ? 1 : 0),
                separatorBuilder: (context, index) => 12.verticalSpace,
              ),
      ),
    );
  }

  void _showDeleteOfferConfirmationDialog(
      BuildContext context, Function() onApprove) {
    UIComponent.showCustomBottomSheet(
        context: context,
        builder: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SVGAssets.deleteVector
                .toSvg(height: 50, width: 50, context: context),
            12.verticalSpace,
            Text(
              appStrings(context).lblDeleteOfferMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.verticalSpace,
            Text(
              appStrings(context).lblDeleteOfferDescMessage,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            14.verticalSpace,
            ButtonRow(
              leftButtonText: appStrings(context).cancel,
              rightButtonText: appStrings(context).yes,
              onLeftButtonTap: () {
                context.pop();
              },
              onRightButtonTap: () {
                context.pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onApprove();
                });
              },
              rightButtonBorderColor: AppColors.colorPrimary,
              rightButtonBgColor: Theme.of(context).canvasColor,
              leftButtonBgColor: Theme.of(context).cardColor,
              leftButtonBorderColor: Theme.of(context).primaryColor,
              leftButtonTextColor: Theme.of(context).primaryColor,
              rightButtonTextColor: AppColors.colorPrimary,
              isLeftButtonGradient: false,
              isRightButtonGradient: false,
              isLeftButtonBorderRequired: true,
              isRightButtonBorderRequired: true,
            ),
          ],
        ));
  }
}
