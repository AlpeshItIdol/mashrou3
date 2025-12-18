import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_values.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../model/offers/my_offers_list_response_model.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import 'component/add_my_offers_card.dart';
import 'cubit/add_my_offers_cubit.dart';

class AddMyOffersScreen extends StatefulWidget {
  final List<String> propertyId;
  final List<OfferData> offersList;
  final String isMultiple;
  final String isFromDelete;

  const AddMyOffersScreen(
      {super.key, required this.propertyId, required this.offersList, required this.isMultiple, required this.isFromDelete});

  @override
  State<AddMyOffersScreen> createState() => _AddMyOffersScreenState();
}

class _AddMyOffersScreenState extends State<AddMyOffersScreen> with AppBarMixin {
  @override
  void initState() {
    printf("propertyIdListData--------${widget.propertyId.length}");
    printf("offersListData--------${widget.offersList.length}");
    context.read<AddMyOffersCubit>().getData(context, widget.offersList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AddMyOffersCubit cubit = context.read<AddMyOffersCubit>();
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<AddMyOffersCubit, AddMyOffersState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            appBar: buildAppBar(
              context: context,
              requireLeading: true,
              title: appStrings(context).lblMyOffers,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // (MediaQuery.of(context).padding.top + 8).verticalSpace,
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16.0, top: 16.0, end: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddMyOffersContent(context, cubit, state),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BlocConsumer<AddMyOffersCubit, AddMyOffersState>(
              listener: buildBlocListener,
              builder: (context, state) {
                AddMyOffersCubit cubit = context.read<AddMyOffersCubit>();
                return UIComponent.customInkWellWidget(
                  onTap: () async {
                    if (validate(context)) {
                      // Navigate to offer pricing screen instead of directly applying
                      if (widget.isFromDelete == "true") {
                        // For delete, directly apply
                        await cubit.applyMyOffers(
                          propertyId: widget.propertyId,
                          isMultiple: widget.isMultiple.toLowerCase() == 'true',
                          action: NetworkConstants.kActionOfferRemove,
                        );
                      } else {
                        // For apply, navigate to pricing screen
                        context.pushNamed(
                          Routes.kOfferPricingScreen,
                          extra: {
                            'propertyIds': widget.propertyId,
                            'offersIds': cubit.offersIds,
                            'isMultiple': widget.isMultiple.toLowerCase() == 'true',
                          },
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: isDark ? null : AppColors.white,
                      gradient: isDark
                          ? cubit.isSelectedAnyOffer
                              ? AppColors.primaryGradient
                              : AppColors.greyGradient
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.colorPrimary.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 18,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isDark
                                  ? null // No gradient for dark theme
                                  : cubit.isSelectedAnyOffer
                                      ? AppColors.primaryGradient
                                      : AppColors.greyGradient,
                              color: isDark
                                  ? AppColors.white // Replace with your dark theme background color
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SVGAssets.myOfferIcon.toSvg(
                                        context: context,
                                        color: isDark
                                            ? cubit.isSelectedAnyOffer
                                                ? AppColors.colorPrimary
                                                : AppColors.grey88
                                            : AppColors.white),
                                    6.horizontalSpace,
                                    Text(
                                      widget.isFromDelete == "true" ? appStrings(context).removeOffer :appStrings(context).applyOffer,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: isDark
                                              ? cubit.isSelectedAnyOffer
                                                  ? AppColors.colorPrimary
                                                  : AppColors.grey88
                                              : AppColors.white),
                                    ),
                                  ],
                                ),
                                UIComponent.customRTLIcon(
                                  context: context,
                                  child: SVGAssets.arrowRightIcon.toSvg(
                                      context: context,
                                      color: isDark
                                          ? cubit.isSelectedAnyOffer
                                              ? AppColors.colorPrimary
                                              : AppColors.grey88
                                          : AppColors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  Widget _buildAddMyOffersContent(BuildContext context, AddMyOffersCubit cubit, AddMyOffersState state) {
    if (state is AddMyOffersInitial) {
      return Container();
    }
    if (state is NoAddMyOffersFoundState) {
      return SizedBox(
        height: AppValues.screenHeight * 0.8,
        child: Center(
          child: UIComponent.noDataWidgetWithInfo(
            title: appStrings(context).emptyOffersList,
            info: appStrings(context).emptyOffersListInfo,
            context: context,
          ),
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!cubit.isLoadingMore && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 20) {
          cubit.loadMoreMyOffers(1, context);
        }
        return false;
      },
      child: Skeletonizer(
        enabled: !cubit.hasShownSkeleton && (state is AddMyOffersLoading || cubit.isLoadingMore),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            if (cubit.filteredAddMyOffers?.isEmpty ?? true) {
              return UIComponent.getBankListSkeleton();
            }

            if (index == cubit.filteredAddMyOffers!.length) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.colorPrimary,
              ));
            }

            OfferData myOffersListData = cubit.filteredAddMyOffers?[index] ?? OfferData();

            return AddMyOffersCard(
              myOffersListData: cubit.filteredAddMyOffers?[index] ?? OfferData(),
              name: myOffersListData.title ?? "",
              price: myOffersListData.price != null
                  ? num.parse(myOffersListData.price!.amount.toString()).formatCurrency(
                      showSymbol: true,
                      // currencySymbol:
                      //     myOffersListData.price!.currencySymbol ?? "",
                    )
                  : "-",
              description: myOffersListData.description ?? "",
              imageUrl: myOffersListData.documents != null && myOffersListData.documents!.isNotEmpty
                  ? myOffersListData.documents?.first ?? cubit.companyLogo
                  : cubit.companyLogo,
            );
          },
          itemCount: (cubit.filteredAddMyOffers?.length ?? 0) + (cubit.isLoadingMore ? 1 : 0),
          separatorBuilder: (context, index) => 12.verticalSpace,
        ),
      ),
    );
  }

  Future<void> buildBlocListener(BuildContext context, AddMyOffersState state) async {
    if (state is AddMyOffersLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is MyOffersListSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is ApplyMyOffersSuccess) {
      OverlayLoadingProgress.stop();
      context.pop(true);
      Utils.snackBar(context: context, message: state.model.message ?? "");
    } else if (state is OffersListSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is NoAddMyOffersFoundState) {
      OverlayLoadingProgress.stop();
    } else if (state is AddMyOffersError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(context: context, message: state.errorMessage);
    }
  }

  /// Method validation
  ///
  bool validate(BuildContext context) {
    AddMyOffersCubit cubit = context.read<AddMyOffersCubit>();

    if (cubit.offersIds.isEmpty) {
      Utils.showErrorMessage(context: context, message: appStrings(context).offerSelectionErrorMsg);
      return false;
    }
    return true;
  }
}
