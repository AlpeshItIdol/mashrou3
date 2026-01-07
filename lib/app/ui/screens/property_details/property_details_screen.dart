import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/model/offers/my_offers_list_response_model.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/common_row_bottons.dart';
import 'package:mashrou3/app/ui/custom_widget/map_card_widget.dart';
import 'package:mashrou3/app/ui/custom_widget/my_gif_widget.dart';
import 'package:mashrou3/app/ui/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/home/cubit/home_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/cubit/property_details_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/bank_details/cubit/bank_details_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/banks_list/cubit/banks_list_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/banks_list/model/banks_list_response_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/property_vendor_finance_data.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_categories/cubit/vendor_categories_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/cubit/vendor_detail_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/visit_request/cubit/visit_request_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/add_rating_cubit.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/read_more_text.dart';
import 'package:mashrou3/utils/string_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../config/network/network_constants.dart';
import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../../config/resources/app_strings.dart';
import '../../../../config/services/analytics_service.dart';
import '../../../../utils/ui_components.dart';
import '../../../db/app_preferences.dart';
import '../../../model/base/base_model.dart';
import '../../../model/verify_response.model.dart';
import '../../../repository/offers_management_repository.dart';
import '../../custom_widget/common_button.dart';
import '../../custom_widget/common_button_with_icon.dart';
import '../../custom_widget/loader/overlay_loading_progress.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../banks_offer/cubit/banks_offer_list_cubit.dart';
import '../dashboard/sub_screens/add_offer/model/add_vendor_response_model.dart' as detailModel;

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({
    super.key,
    required this.sId,
    required this.vendorId,
    required this.propertyLatLng,
    required this.rejectReason,
    required this.isFromVisitReq,
    required this.isFromVendor,
  });

  final String sId;
  final String vendorId;
  final LatLng propertyLatLng;
  final String rejectReason;
  final String isFromVisitReq;
  final String isFromVendor;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> with AppBarMixin, WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  late String rejectReason;
  DateTime? _startTime;
  String? _userId;
  String? _userType;
  final PagingController<int, BankUser> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now();
    context.read<PropertyDetailsCubit>().sid = widget.sId;
    context.read<PropertyDetailsCubit>().getData(context, widget.sId);
    _userId = context.read<PropertyDetailsCubit>().selectedUserId;
    _userType = context.read<PropertyDetailsCubit>().selectedUserRole;

    context
        .read<VendorCategoriesCubit>()
        .getData(context, propertyId: widget.sId);
    // context.read<VendorCategoriesCubit>().setPropertyData(
    //     PropertyVendorFinanceData(propertyId: widget.propertyId));
    super.initState();
    context.read<VendorDetailCubit>().getData(widget.vendorId, context);
    context.read<BanksOfferListCubit>().refresh();
    final cubit = context.read<BanksOfferListCubit>();
    cubit.getBankOffersList(hasMoreData: true);
    // Log the property click event
    AnalyticsService.logEvent(
      eventName: "property_click",
      parameters: {
        AppConstants.analyticsIdOfUserKey: _userId,
        AppConstants.analyticsUserTypeKey: _userType,
        AppConstants.analyticsPropertyIdKey: widget.sId
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _logTimeSpent();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTime = DateTime.now(); // user came back to screen
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      _logTimeSpent(); // user backgrounded or leaving screen
    }
  }

  void _logTimeSpent() {
    if (_startTime == null) return;

    final endTime = DateTime.now();
    final timeSpent = endTime.difference(_startTime!).inSeconds;
    if (timeSpent <= 0) return; // prevent zero/negative

    // Log the property spent time event
    AnalyticsService.logEvent(
      eventName: "property_spent_time",
      parameters: {
        AppConstants.analyticsIdOfUserKey: _userId,
        AppConstants.analyticsUserTypeKey: _userType,
        AppConstants.analyticsPropertyIdKey: widget.sId,
        AppConstants.analyticsTimeKey: timeSpent,
      },
    );

    _startTime = null; // reset so it doesn't double-log
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyDetailsCubit, PropertyDetailsState>(
      listener: buildBlocListener,
      builder: (context, state) {
        return Scaffold(
          body: _buildBlocConsumer,
          bottomNavigationBar: BlocListener<AddRatingCubit, AddRatingState>(
            listener: (context, state) {
              if (state is AddRatingReviewSuccess) {
                context.read<PropertyDetailsCubit>().getPropertyDetails(context: context, propertyId: widget.sId);
              }
            },
            child: BlocConsumer<PropertyDetailsCubit, PropertyDetailsState>(
              listener: (context, state) {},
              builder: (context, state) {
                PropertyDetailsCubit cubit = context.read<PropertyDetailsCubit>();
                return cubit.isVendor
                    ? (cubit.myPropertyDetails.isSoldOut.toString() == "true")
                    ? const SizedBox()
                    : UIComponent.customInkWellWidget(
                  onTap: () async {
                    await context.pushNamed(
                      Routes.kAddMyOffersListScreen,
                      extra: [widget.sId],
                      pathParameters: {
                        RouteArguments.offersList:
                        cubit.myPropertyDetails.offers != null && cubit.myPropertyDetails.offers!.isNotEmpty
                            ? jsonEncode(cubit.myPropertyDetails.offers!.map((e) => e.toJson()).toList())
                            : jsonEncode([]),
                        RouteArguments.isMultiple: "false",
                        RouteArguments.isFromDelete: "false",
                      },
                    );
                  },
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SVGAssets.myOfferIcon.toSvg(context: context, color: AppColors.colorPrimary),
                                    6.horizontalSpace,
                                    Text(
                                      appStrings(context).applyOffer,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w400, color: AppColors.colorPrimary),
                                    ),
                                  ],
                                ),
                                UIComponent.customRTLIcon(
                                    child: SVGAssets.arrowRightIcon.toSvg(
                                      context: context,
                                      color: AppColors.colorPrimary,
                                    ),
                                    context: context)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).showIf(cubit.myPropertyDetails.sId != null && cubit.myPropertyDetails.sId != "")
                    : Container(
                  height: 90,
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price Text - Wrap into 2 lines safely
                      Expanded(
                        flex: 2,
                        child: Text(
                          (() {
                            final amountString = cubit.myPropertyDetails.price?.amount?.toString();
                            if (amountString == null || amountString.isEmpty) return "";
                            try {
                              final amount = num.parse(amountString);
                              return amount.formatCurrency(
                                showSymbol: true,
                                currencySymbol: cubit.myPropertyDetails.price?.currencySymbol ?? "",
                              );
                            } catch (e) {
                              return "Invalid Price";
                            }
                          })(),
                          textAlign: TextAlign.left,
                          maxLines: 3, // Wrap to 2 lines
                          overflow: TextOverflow.ellipsis, // prevent overflow
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ).hideIf(
                          cubit.myPropertyDetails.price == null ||
                              cubit.myPropertyDetails.price?.amount == null ||
                              cubit.myPropertyDetails.price?.amount == "",
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Buttons section (Vendor + Bank)
                      Expanded(
                        flex: 3,
                        child: Skeleton.leaf(
                          enabled: (state is PropertyDetailsLoading),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildButton(
                                context: context,
                                label: appStrings(context).lblBank,
                                onTap: () async {
                                  AnalyticsService.logEvent(
                                    eventName: "property_property_finance_click",
                                    parameters: {
                                      AppConstants.analyticsIdOfUserKey: cubit.selectedUserId,
                                      AppConstants.analyticsUserTypeKey: cubit.selectedUserRole,
                                      AppConstants.analyticsPropertyIdKey: widget.sId
                                    },
                                  );
                                  try {
                                    OverlayLoadingProgress.start(context);
                                    await _navigateToBankOffer(context, cubit);
                                  } finally {
                                    OverlayLoadingProgress.stop();
                                  }
                                },
                              ),
                              const SizedBox(width: 10),
                              _buildButton(
                                context: context,
                                label: "Vendors",
                                onTap: () async {
                                  AnalyticsService.logEvent(
                                    eventName: "property_vendor_finance_click",
                                    parameters: {
                                      AppConstants.analyticsIdOfUserKey: cubit.selectedUserId,
                                      AppConstants.analyticsUserTypeKey: cubit.selectedUserRole,
                                      AppConstants.analyticsPropertyIdKey: widget.sId
                                    },
                                  );
                                  await context.pushNamed(
                                    Routes.kVendorCategoriesScreen,
                                    extra: cubit.myPropertyDetails.sId,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ).hideIf(cubit.myPropertyDetails.isSoldOut ?? false),
                    ],
                  ),
                ).showIf(cubit.myPropertyDetails.price != null);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: AppColors.white,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<PropertyDetailsCubit, PropertyDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        PropertyDetailsCubit cubit = context.read<PropertyDetailsCubit>();

        final propertyDocFiles = Utils.getAllDocFiles(cubit.myPropertyDetails.propertyFiles ?? []);

        return Skeletonizer(
          enabled: (cubit.myPropertyDetails.sId.toString() == "" || state is PropertyDetailsLoading || state is PropertyDetailsInitial),
          child: cubit.myPropertyDetails.sId.toString() == "null" ||
              cubit.myPropertyDetails.sId.toString() == "" ||
              state is PropertyDetailsLoading
              ? Skeletonizer(enabled: true, child: UIComponent.getSkeletonPropertyDetail())
              : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 320.0,
                pinned: false,
                flexibleSpace: _buildImageSlider(cubit),
              ),
            ],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0, top: 16),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  color: AppColors.greyF8
                                      .adaptiveColor(context, lightModeColor: AppColors.greyF8, darkModeColor: AppColors.black2E),
                                ),
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 14.0,
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      appStrings(context).lblVisitRequestRejectionReason,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontWeight: FontWeight.w700, color: AppColors.red33),
                                    ),
                                    8.verticalSpace,
                                    ReadMoreText(
                                      widget.rejectReason,
                                      trimMode: TrimMode.Line,
                                      trimLines: 3,
                                      locale: Locale(cubit.selectedLanguage),
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black3D.adaptiveColor(context,
                                              lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
                                      trimCollapsedText: appStrings(context).readMore,
                                      trimExpandedText: appStrings(context).readLess,
                                      lessStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.black3D.adaptiveColor(context,
                                              lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
                                      moreStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.black3D.adaptiveColor(context,
                                              lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
                                    ),
                                  ],
                                ),
                              ),
                              18.verticalSpace,
                            ],
                          ).showIf(widget.rejectReason != "" && widget.isFromVisitReq == "true"),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              cubit.myPropertyDetails.subCategoryData?.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.colorSecondary.adaptiveColor(context,
                                    lightModeColor: AppColors.colorSecondary, darkModeColor: AppColors.goldA1),
                              ),
                            ),
                          ).showIf(cubit.myPropertyDetails.subCategoryData != null),
                          Text(
                            cubit.myPropertyDetails.title ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
                          ),
                          8.verticalSpace,
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: ReadMoreText(
                              cubit.myPropertyDetails.description ?? "",
                              trimMode: TrimMode.Line,
                              trimLines: 3,
                              locale: Locale(cubit.selectedLanguage),
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black3D
                                      .adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
                              trimCollapsedText: appStrings(context).readMore,
                              trimExpandedText: appStrings(context).readLess,
                              lessStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black3D
                                      .adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
                              moreStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black3D
                                      .adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
                            ),
                          ).hideIf((cubit.myPropertyDetails.description ?? "") == ""),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: CommonButton(
                              isDynamicWidth: true,
                              horizontalPadding: 8,
                              onTap: () {},
                              title: (() {
                                // Get the price amount as a string
                                final amountString = cubit.myPropertyDetails.price?.amount?.toString();

                                // Check if the amount is valid
                                if (amountString == null || amountString.isEmpty) {
                                  return ""; // Return an empty string if null or empty
                                }

                                try {
                                  // Parse the amount and format it as currency
                                  final amount = num.parse(amountString);
                                  return amount.formatCurrency(
                                    showSymbol: true,
                                    currencySymbol: cubit.myPropertyDetails.price?.currencySymbol ?? "",
                                  );
                                } catch (e) {
                                  // Handle invalid number format
                                  return "Invalid Price"; // Return a fallback value
                                }
                              })(),
                              isBorderRequired: false,
                              isGradientColor: true,
                            ).hideIf(cubit.myPropertyDetails.price == null ||
                                cubit.myPropertyDetails.price?.amount == null ||
                                cubit.myPropertyDetails.price?.amount == ""),
                          )
                              .hideIf(cubit.myPropertyDetails.price == null ||
                              cubit.myPropertyDetails.price?.amount == null ||
                              cubit.myPropertyDetails.price?.amount == "")
                              .showIf(cubit.isVendor),
                          Skeleton.unite(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 4,
                                runSpacing: 10,
                                children: [
                                  Visibility(
                                      visible: cubit.myPropertyDetails.country != null && cubit.myPropertyDetails.country!.isNotEmpty,
                                      child: UIComponent.iconRowAndText(
                                        context: context,
                                        svgPath: SVGAssets.locationIcon,
                                        text: '${cubit.myPropertyDetails.city?.isNotEmpty == true ? cubit.myPropertyDetails.city : ''}'
                                            '${(cubit.myPropertyDetails.city?.isNotEmpty == true && cubit.myPropertyDetails.country?.isNotEmpty == true) ? ', ' : ''}'
                                            '${cubit.myPropertyDetails.country?.isNotEmpty == true ? cubit.myPropertyDetails.country : ''}',
                                        backgroundColor: AppColors.colorBgPrimary.adaptiveColor(context,
                                            lightModeColor: AppColors.colorBgPrimary, darkModeColor: AppColors.black2E),
                                        textColor: AppColors.colorPrimary.adaptiveColor(context,
                                            lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                                      )),
                                  Visibility(
                                      visible: cubit.myPropertyDetails.area != null && cubit.myPropertyDetails.area!.amount.isNotEmpty,
                                      child: UIComponent.iconRowAndText(
                                        context: context,
                                        svgPath: SVGAssets.aspectRatioIcon,
                                        text: Utils.formatArea(
                                            '${cubit.myPropertyDetails.area?.amount ?? ''}', cubit.myPropertyDetails.area?.unit ?? ''),
                                        backgroundColor: AppColors.colorBgPrimary.adaptiveColor(context,
                                            lightModeColor: AppColors.colorBgPrimary, darkModeColor: AppColors.black2E),
                                        textColor: AppColors.colorSecondary.adaptiveColor(context,
                                            lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                                      )),
                                  Visibility(
                                      visible: cubit.myPropertyDetails.rating.toString() != '0',
                                      child: UIComponent.iconRowAndText(
                                        svgPath: SVGAssets.starIcon,
                                        context: context,
                                        iconColor: AppColors.goldA1,
                                        text: cubit.myPropertyDetails.rating.toString(),
                                        backgroundColor: AppColors.colorBgPrimary.adaptiveColor(context,
                                            lightModeColor: AppColors.colorBgPrimary, darkModeColor: AppColors.black2E),
                                        textColor: AppColors.colorSecondary.adaptiveColor(context,
                                            lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                                      )),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      2.horizontalSpace,
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: AppColors.greyE8
                                              .adaptiveColor(context, lightModeColor: AppColors.greyE8, darkModeColor: AppColors.black2E),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      4.horizontalSpace,
                                      UIComponent.customInkWellWidget(
                                        onTap: () async {
                                          context.read<DashboardCubit>().isGuest
                                              ? _showGuestUserBottomSheet(context)
                                              : {
                                            context.pushNamed(Routes.kViewReviewScreen,
                                                extra: cubit.myPropertyDetails.sId,
                                                pathParameters: {
                                                  RouteArguments.isReviewVisible: "true",
                                                  RouteArguments.userAddedRating: cubit.myPropertyDetails.isReviewed.toString(),
                                                }),
                                          };
                                        },
                                        child: Text(
                                          "${cubit.myPropertyDetails.totalRatings?.toString() ?? "0"} ${appStrings(context).textReviews}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.colorPrimary.adaptiveColor(context,
                                                lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.goldA1),
                                            decoration: TextDecoration.underline,
                                            decorationColor: AppColors.colorPrimary.adaptiveColor(context,
                                                lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.goldA1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          18.verticalSpace,
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CommonButtonWithIcon(
                                    onTap: () {
                                      //Log the event for video icon click
                                      AnalyticsService.logEvent(
                                        eventName: "property_video_icon_click",
                                        parameters: {
                                          AppConstants.analyticsIdOfUserKey: cubit.selectedUserId,
                                          AppConstants.analyticsUserTypeKey: cubit.selectedUserRole,
                                          AppConstants.analyticsPropertyIdKey: widget.sId
                                        },
                                      );
                                      UIComponent.showCustomBottomSheet(
                                          horizontalPadding: 0,
                                          context: context,
                                          builder: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 83,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: AppColors.black14,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              24.verticalSpace,
                                              Text(
                                                appStrings(context).videoLink,
                                                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                                              ),
                                              24.verticalSpace,
                                              if (cubit.myPropertyDetails.videoLink != null ||
                                                  cubit.myPropertyDetails.videoLink!.isNotEmpty ||
                                                  cubit.myPropertyDetails.videoLink![0].isNotEmpty)
                                                ListView.separated(
                                                  shrinkWrap: true,
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: cubit.myPropertyDetails.videoLink?.length ?? 0,
                                                  itemBuilder: (context, index) {
                                                    final option = cubit.myPropertyDetails.videoLink?[index] ?? "";

                                                    return option.isNotEmpty
                                                        ? Container(
                                                      margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        color: AppColors.greyF5.adaptiveColor(context,
                                                            lightModeColor: AppColors.greyF5, darkModeColor: AppColors.black14),
                                                      ),
                                                      child: UIComponent.dataListTile(
                                                          title: cubit.myPropertyDetails.videoLink!.length < 2
                                                              ? appStrings(context).link
                                                              : "${appStrings(context).link} ${index + 1}",
                                                          icon: SVGAssets.linkIcon,
                                                          onTap: () async {
                                                            Navigator.pop(context);
                                                            context.pushNamed(Routes.kWebViewScreen,
                                                                extra: option,
                                                                pathParameters: {
                                                                  RouteArguments.title: appStrings(context).videoLink,
                                                                });
                                                          },
                                                          context: context),
                                                    )
                                                        : const SizedBox.shrink();
                                                  },
                                                  separatorBuilder: (BuildContext context, int index) {
                                                    return 12.verticalSpace;
                                                  },
                                                ),
                                            ],
                                          ));
                                    },
                                    isDisabled: ((cubit.myPropertyDetails.videoLink?.every((item) => item.isEmpty)) ?? true),
                                    title: appStrings(context).video,
                                    icon: SVGAssets.playSquareIcon.toSvg(
                                        context: context,
                                        color: ((cubit.myPropertyDetails.videoLink?.every((item) => item.isEmpty)) ?? true)
                                            ? AppColors.grey77.adaptiveColor(context,
                                            lightModeColor: AppColors.grey77, darkModeColor: AppColors.white)
                                            : AppColors.colorPrimary.adaptiveColor(context,
                                            lightModeColor:
                                            ((cubit.myPropertyDetails.videoLink?.every((item) => item.isEmpty)) ?? true)
                                                ? AppColors.grey77.adaptiveColor(context,
                                                lightModeColor: AppColors.grey77, darkModeColor: AppColors.white)
                                                : AppColors.colorPrimary,
                                            darkModeColor: AppColors.white)),
                                    borderColor: AppColors.colorPrimary.adaptiveColor(context,
                                        lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                                    isGradientColor: false,
                                    buttonTextColor: AppColors.colorPrimary.adaptiveColor(context,
                                        lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: CommonButtonWithIcon(
                                    onTap: () {
                                      /*Utils.launchURL(
                                                url: cubit.myPropertyDetails
                                                        .virtualTour ??
                                                    "");*/
                                      //Log the event for virtual tour icon click
                                      AnalyticsService.logEvent(
                                        eventName: "property_virtual_tour_icon_click",
                                        parameters: {
                                          AppConstants.analyticsIdOfUserKey: cubit.selectedUserId,
                                          AppConstants.analyticsUserTypeKey: cubit.selectedUserRole,
                                          AppConstants.analyticsPropertyIdKey: widget.sId
                                        },
                                      );
                                      (cubit.myPropertyDetails.virtualTour ?? "") == ""
                                          ? () {}
                                          : context.pushNamed(Routes.kWebViewScreen,
                                          extra: cubit.myPropertyDetails.virtualTour ?? "",
                                          pathParameters: {
                                            RouteArguments.title: appStrings(context).virtualTour,
                                          });
                                    },
                                    title: appStrings(context).virtualTour,
                                    isDisabled: (cubit.myPropertyDetails.virtualTour ?? "") == "" ? true : false,
                                    icon: SVGAssets.virtual3dViewIcon.toSvg(
                                        context: context,
                                        color: (cubit.myPropertyDetails.virtualTour ?? "") == ""
                                            ? AppColors.grey77.adaptiveColor(context,
                                            lightModeColor: AppColors.grey77, darkModeColor: AppColors.greyE9)
                                            : AppColors.white),
                                    isGradientColor: true,
                                    gradientColor: AppColors.primaryGradient,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
                            child: CustomDivider.colored(context),
                          ),
                          //Navigate to profile-detail
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: UIComponent.customInkWellWidget(
                                    onTap: () {
                                      context.read<DashboardCubit>().isGuest
                                          ? _showGuestUserBottomSheet(context)
                                          : context.pushNamed(Routes.kProfileDetailScreen, extra: cubit.myPropertyDetails.createdBy);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        (cubit.myPropertyDetails.createdByData?.companyLogo != null &&
                                            cubit.myPropertyDetails.createdByData!.companyLogo!.startsWith('http'))
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(60),
                                          child: CachedNetworkImage(
                                            imageUrl: cubit.myPropertyDetails.createdByData?.companyLogo ?? "",
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.colorPrimary,
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => const Icon(
                                              Icons.error,
                                            ),
                                          ),
                                        )
                                            : Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: AppColors.colorSecondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SVGAssets.userLightIcon.toSvg(
                                            context: context,
                                            color: Theme.of(context).canvasColor,
                                          ),
                                        ),
                                        8.horizontalSpace,
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                cubit.myPropertyDetails.createdByData?.companyName ?? "",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
                                              ),
                                              3.verticalSpace,
                                              Text(
                                                "${appStrings(context).textJoinedOn} ${UIComponent.formatDate(cubit.myPropertyDetails.createdByData?.createdAt ?? DateTime.now().toString() ?? "20/10/2024", "dd/MM/yyyy")}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.w400, color: AppColors.grey8A.forLightMode(context)),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    UIComponent.customInkWellWidget(
                                      onTap: () {
                                        context.read<DashboardCubit>().isGuest
                                            ? _showGuestUserBottomSheet(context)
                                            : ((cubit.myPropertyDetails.createdByBank ?? false) &&
                                            cubit.myPropertyDetails.createdByData?.bankContactNumbers != null &&
                                            cubit.myPropertyDetails.createdByData?.banksAlternativeContact != null &&
                                            cubit.myPropertyDetails.createdByData?.banksAlternativeContact != [])
                                            ? UIComponent.showCustomBottomSheet(
                                          horizontalPadding: 0,
                                          verticalPadding: 8,
                                          context: context,
                                          builder: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 83,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: AppColors.black14,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              24.verticalSpace,
                                              Text(
                                                appStrings(context).lblContactDetails,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(fontWeight: FontWeight.w700),
                                              ),
                                              24.verticalSpace,
                                              Builder(builder: (context) {
                                                // List of contact numbers
                                                final contacts = [
                                                  // +$phoneCode$contactNumber

                                                  "+${cubit.myPropertyDetails.createdByData?.bankContactNumbers?.phoneCode.toString()} ${cubit.myPropertyDetails.createdByData?.bankContactNumbers?.contactNumber.toString()}",

                                                  // Alternate contact numbers (if available)
                                                  if (cubit.myPropertyDetails.createdByData?.banksAlternativeContact !=
                                                      null &&
                                                      cubit.myPropertyDetails.createdByData?.banksAlternativeContact != [])
                                                    ...?cubit.myPropertyDetails.createdByData?.banksAlternativeContact!.map(
                                                          (contact) =>
                                                      "+${contact.phoneCode ?? ''} ${contact.contactNumber ?? ''}",
                                                    )
                                                ];
                                                return ListView.separated(
                                                  shrinkWrap: true,
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: contacts.length,
                                                  // Number of contact numbers
                                                  itemBuilder: (context, index) {
                                                    // Get the contact for the current index
                                                    final contact = contacts[index];

                                                    return Container(
                                                      margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        color: AppColors.greyF5.adaptiveColor(context,
                                                            lightModeColor: AppColors.greyF5,
                                                            darkModeColor: AppColors.black14),
                                                      ),
                                                      child: UIComponent.dataListTile(
                                                          title: contact,
                                                          icon: SVGAssets.callIcon,
                                                          context: context,
                                                          onTap: () {
                                                            // Handle onTap for the contact item
                                                            debugPrint('Contact selected: $contact');
                                                            Navigator.pop(context); // Close the bottom sheet
                                                            UIComponent.showCustomBottomSheet(
                                                                horizontalPadding: 0,
                                                                context: context,
                                                                builder: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      appStrings(context).lblContactNow,
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .labelLarge
                                                                          ?.copyWith(fontWeight: FontWeight.w700),
                                                                    ),
                                                                    24.verticalSpace,
                                                                    ListView.separated(
                                                                      shrinkWrap: true,
                                                                      physics: const ClampingScrollPhysics(),
                                                                      itemCount: cubit.contactNowOptions.length,
                                                                      itemBuilder: (context, index) {
                                                                        final option = cubit.contactNowOptions[index];
                                                                        final isWhatsApp =
                                                                            option.title.toLowerCase() == "whatsapp";

                                                                        return Container(
                                                                          margin: const EdgeInsetsDirectional.symmetric(
                                                                              horizontal: 16),
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(16),
                                                                            gradient: isWhatsApp
                                                                                ? AppColors.primaryGradient
                                                                                : null,
                                                                            color: !isWhatsApp
                                                                                ? AppColors.greyF5.adaptiveColor(context,
                                                                                lightModeColor: AppColors.greyF5,
                                                                                darkModeColor: AppColors.black14)
                                                                                : null,
                                                                          ),
                                                                          child: ListTile(
                                                                              leading: Container(
                                                                                padding: const EdgeInsets.all(8),
                                                                                decoration: BoxDecoration(
                                                                                  color: isWhatsApp
                                                                                      ? AppColors.white
                                                                                      : AppColors.colorPrimary
                                                                                      .withOpacity(0.10)
                                                                                      .adaptiveColor(context,
                                                                                      lightModeColor: AppColors
                                                                                          .colorPrimary
                                                                                          .withOpacity(0.10),
                                                                                      darkModeColor:
                                                                                      AppColors.colorPrimary),
                                                                                  borderRadius: BorderRadius.circular(
                                                                                      8), // Rounded container
                                                                                ),
                                                                                child: option.icon.toSvg(
                                                                                  context: context,
                                                                                  color: AppColors.colorPrimary
                                                                                      .adaptiveColor(context,
                                                                                      lightModeColor:
                                                                                      AppColors.colorPrimary,
                                                                                      darkModeColor: isWhatsApp
                                                                                          ? AppColors.colorPrimary
                                                                                          : AppColors.white),
                                                                                ),
                                                                              ),
                                                                              title: Text(
                                                                                option.title,
                                                                                style: Theme.of(context)
                                                                                    .textTheme
                                                                                    .titleSmall
                                                                                    ?.copyWith(
                                                                                  color: isWhatsApp
                                                                                      ? AppColors.white
                                                                                      : Theme.of(context).primaryColor,
                                                                                ),
                                                                              ),
                                                                              trailing: SVGAssets.arrowRightIcon.toSvg(
                                                                                context: context,
                                                                                color: isWhatsApp
                                                                                    ? AppColors.white
                                                                                    : AppColors.colorPrimary.adaptiveColor(
                                                                                    context,
                                                                                    lightModeColor:
                                                                                    AppColors.colorPrimary,
                                                                                    darkModeColor: AppColors.white),
                                                                              ),
                                                                              onTap: () async {
                                                                                switch (index) {
                                                                                  case 0:
                                                                                  // Make the phone call
                                                                                    Utils.makePhoneCall(
                                                                                      context: context,
                                                                                      phoneNumber: contact.toString(),
                                                                                    );

                                                                                    // Log the event for direct call
                                                                                    AnalyticsService.logEvent(
                                                                                      eventName:
                                                                                      "property_direct_call_click",
                                                                                      parameters: {
                                                                                        AppConstants.analyticsIdOfUserKey:
                                                                                        cubit.selectedUserId,
                                                                                        AppConstants.analyticsPropertyIdKey:
                                                                                        widget.sId,
                                                                                        AppConstants
                                                                                            .analyticsContactNumberKey:
                                                                                        contact.toString(),
                                                                                        AppConstants.analyticsUserTypeKey:
                                                                                        cubit.selectedUserRole,
                                                                                      },
                                                                                    );

                                                                                    debugPrint(
                                                                                        'Item 0 (Direct Call) selected');
                                                                                    break;

                                                                                  case 1:
                                                                                  // Make WhatsApp call
                                                                                    Utils.makeWhatsAppCall(
                                                                                      context: context,
                                                                                      phoneNumber: contact.toString(),
                                                                                    );

                                                                                    // Log the event for WhatsApp call
                                                                                    AnalyticsService.logEvent(
                                                                                      eventName: "property_whatsapp_click",
                                                                                      parameters: {
                                                                                        AppConstants.analyticsIdOfUserKey:
                                                                                        cubit.selectedUserId,
                                                                                        AppConstants.analyticsPropertyIdKey:
                                                                                        widget.sId,
                                                                                        AppConstants
                                                                                            .analyticsContactNumberKey:
                                                                                        contact.toString(),
                                                                                        AppConstants.analyticsUserTypeKey:
                                                                                        cubit.selectedUserRole,
                                                                                      },
                                                                                    );

                                                                                    debugPrint(
                                                                                        'Item 1 (WhatsApp) selected');
                                                                                    break;

                                                                                  case 2:
                                                                                  // Send SMS
                                                                                    Utils.makeSms(
                                                                                      context: context,
                                                                                      phoneNumber: contact.toString(),
                                                                                    );

                                                                                    // Log the event for text message
                                                                                    AnalyticsService.logEvent(
                                                                                      eventName:
                                                                                      "property_text_message_click",
                                                                                      parameters: {
                                                                                        AppConstants.analyticsIdOfUserKey:
                                                                                        cubit.selectedUserId,
                                                                                        AppConstants.analyticsPropertyIdKey:
                                                                                        widget.sId,
                                                                                        AppConstants
                                                                                            .analyticsContactNumberKey:
                                                                                        contact.toString(),
                                                                                        AppConstants.analyticsUserTypeKey:
                                                                                        cubit.selectedUserRole,
                                                                                      },
                                                                                    );

                                                                                    debugPrint('Item 2 (Text) selected');
                                                                                    break;

                                                                                  default:
                                                                                  // Default action for other items
                                                                                    debugPrint(
                                                                                        'Item $index selected: ${option.title}');
                                                                                    break;
                                                                                }

                                                                                // Close the bottom sheet
                                                                                Navigator.pop(context);

                                                                                // Log the selected option title
                                                                                debugPrint('${option.title} selected');
                                                                              }),
                                                                        );
                                                                      },
                                                                      separatorBuilder: (BuildContext context, int index) {
                                                                        return 12.verticalSpace;
                                                                      },
                                                                    ),
                                                                  ],
                                                                ));
                                                          }),
                                                    );
                                                  },
                                                  separatorBuilder: (BuildContext context, int index) {
                                                    return 12.verticalSpace;
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                        )
                                            : cubit.myPropertyDetails.alternateContactNumber != null &&
                                            cubit.myPropertyDetails.alternateContactNumber?.contactNumber != null &&
                                            cubit.myPropertyDetails.alternateContactNumber?.contactNumber != ""
                                            ? UIComponent.showCustomBottomSheet(
                                          horizontalPadding: 0,
                                          verticalPadding: 8,
                                          context: context,
                                          builder: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 83,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: AppColors.black14,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              24.verticalSpace,
                                              Text(
                                                appStrings(context).lblContactDetails,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(fontWeight: FontWeight.w700),
                                              ),
                                              24.verticalSpace,
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics: const ClampingScrollPhysics(),
                                                itemCount: 2,
                                                // Number of contact numbers
                                                itemBuilder: (context, index) {
                                                  // List of contact numbers
                                                  final contacts = [
                                                    // +$phoneCode$contactNumber

                                                    "+${cubit.myPropertyDetails.contactNumber?.phoneCode.toString()} ${cubit.myPropertyDetails.contactNumber?.contactNumber.toString()}",
                                                    "+${cubit.myPropertyDetails.alternateContactNumber?.phoneCode.toString()} ${cubit.myPropertyDetails.alternateContactNumber?.contactNumber.toString()}",
                                                  ];

                                                  // Get the contact for the current index
                                                  final contact = contacts[index];

                                                  return Container(
                                                    margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      color: AppColors.greyF5.adaptiveColor(context,
                                                          lightModeColor: AppColors.greyF5,
                                                          darkModeColor: AppColors.black14),
                                                    ),
                                                    child: UIComponent.dataListTile(
                                                        title: contact,
                                                        icon: SVGAssets.callIcon,
                                                        context: context,
                                                        onTap: () {
                                                          // Handle onTap for the contact item
                                                          debugPrint('Contact selected: $contact');
                                                          Navigator.pop(context); // Close the bottom sheet
                                                          UIComponent.showCustomBottomSheet(
                                                              horizontalPadding: 0,
                                                              context: context,
                                                              builder: Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    appStrings(context).lblContactNow,
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .labelLarge
                                                                        ?.copyWith(fontWeight: FontWeight.w700),
                                                                  ),
                                                                  24.verticalSpace,
                                                                  ListView.separated(
                                                                    shrinkWrap: true,
                                                                    physics: const ClampingScrollPhysics(),
                                                                    itemCount: cubit.contactNowOptions.length,
                                                                    itemBuilder: (context, index) {
                                                                      final option = cubit.contactNowOptions[index];
                                                                      final isWhatsApp =
                                                                          option.title.toLowerCase() == "whatsapp";

                                                                      return Container(
                                                                        margin: const EdgeInsetsDirectional.symmetric(
                                                                            horizontal: 16),
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(16),
                                                                          gradient: isWhatsApp
                                                                              ? AppColors.primaryGradient
                                                                              : null,
                                                                          color: !isWhatsApp
                                                                              ? AppColors.greyF5.adaptiveColor(context,
                                                                              lightModeColor: AppColors.greyF5,
                                                                              darkModeColor: AppColors.black14)
                                                                              : null,
                                                                        ),
                                                                        child: ListTile(
                                                                            leading: Container(
                                                                              padding: const EdgeInsets.all(8),
                                                                              decoration: BoxDecoration(
                                                                                color: isWhatsApp
                                                                                    ? AppColors.white
                                                                                    : AppColors.colorPrimary
                                                                                    .withOpacity(0.10)
                                                                                    .adaptiveColor(context,
                                                                                    lightModeColor: AppColors
                                                                                        .colorPrimary
                                                                                        .withOpacity(0.10),
                                                                                    darkModeColor:
                                                                                    AppColors.colorPrimary),
                                                                                borderRadius: BorderRadius.circular(
                                                                                    8), // Rounded container
                                                                              ),
                                                                              child: option.icon.toSvg(
                                                                                context: context,
                                                                                color: AppColors.colorPrimary
                                                                                    .adaptiveColor(
                                                                                    context,
                                                                                    lightModeColor:
                                                                                    AppColors.colorPrimary,
                                                                                    darkModeColor: isWhatsApp
                                                                                        ? AppColors.colorPrimary
                                                                                        : AppColors.white),
                                                                              ),
                                                                            ),
                                                                            title: Text(
                                                                              option.title,
                                                                              style: Theme.of(context)
                                                                                  .textTheme
                                                                                  .titleSmall
                                                                                  ?.copyWith(
                                                                                color: isWhatsApp
                                                                                    ? AppColors.white
                                                                                    : Theme.of(context)
                                                                                    .primaryColor,
                                                                              ),
                                                                            ),
                                                                            trailing: SVGAssets.arrowRightIcon.toSvg(
                                                                              context: context,
                                                                              color: isWhatsApp
                                                                                  ? AppColors.white
                                                                                  : AppColors.colorPrimary
                                                                                  .adaptiveColor(context,
                                                                                  lightModeColor:
                                                                                  AppColors.colorPrimary,
                                                                                  darkModeColor:
                                                                                  AppColors.white),
                                                                            ),
                                                                            onTap: () async {
                                                                              switch (index) {
                                                                                case 0:
                                                                                // Make the phone call
                                                                                  Utils.makePhoneCall(
                                                                                    context: context,
                                                                                    phoneNumber: contact.toString(),
                                                                                  );

                                                                                  // Log the event for direct call
                                                                                  AnalyticsService.logEvent(
                                                                                    eventName:
                                                                                    "property_direct_call_click",
                                                                                    parameters: {
                                                                                      AppConstants.analyticsIdOfUserKey:
                                                                                      cubit.selectedUserId,
                                                                                      AppConstants
                                                                                          .analyticsPropertyIdKey:
                                                                                      widget.sId,
                                                                                      AppConstants
                                                                                          .analyticsContactNumberKey:
                                                                                      contact.toString(),
                                                                                      AppConstants.analyticsUserTypeKey:
                                                                                      cubit.selectedUserRole,
                                                                                    },
                                                                                  );

                                                                                  debugPrint(
                                                                                      'Item 0 (Direct Call) selected');
                                                                                  break;

                                                                                case 1:
                                                                                // Make WhatsApp call
                                                                                  Utils.makeWhatsAppCall(
                                                                                    context: context,
                                                                                    phoneNumber: contact.toString(),
                                                                                  );

                                                                                  // Log the event for WhatsApp call
                                                                                  AnalyticsService.logEvent(
                                                                                    eventName:
                                                                                    "property_whatsapp_click",
                                                                                    parameters: {
                                                                                      AppConstants.analyticsIdOfUserKey:
                                                                                      cubit.selectedUserId,
                                                                                      AppConstants
                                                                                          .analyticsPropertyIdKey:
                                                                                      widget.sId,
                                                                                      AppConstants
                                                                                          .analyticsContactNumberKey:
                                                                                      contact.toString(),
                                                                                      AppConstants.analyticsUserTypeKey:
                                                                                      cubit.selectedUserRole,
                                                                                    },
                                                                                  );

                                                                                  debugPrint(
                                                                                      'Item 1 (WhatsApp) selected');
                                                                                  break;

                                                                                case 2:
                                                                                // Send SMS
                                                                                  Utils.makeSms(
                                                                                    context: context,
                                                                                    phoneNumber: contact.toString(),
                                                                                  );

                                                                                  // Log the event for text message
                                                                                  AnalyticsService.logEvent(
                                                                                    eventName:
                                                                                    "property_text_message_click",
                                                                                    parameters: {
                                                                                      AppConstants.analyticsIdOfUserKey:
                                                                                      cubit.selectedUserId,
                                                                                      AppConstants
                                                                                          .analyticsPropertyIdKey:
                                                                                      widget.sId,
                                                                                      AppConstants
                                                                                          .analyticsContactNumberKey:
                                                                                      contact.toString(),
                                                                                      AppConstants.analyticsUserTypeKey:
                                                                                      cubit.selectedUserRole,
                                                                                    },
                                                                                  );

                                                                                  debugPrint('Item 2 (Text) selected');
                                                                                  break;

                                                                                default:
                                                                                // Default action for other items
                                                                                  debugPrint(
                                                                                      'Item $index selected: ${option.title}');
                                                                                  break;
                                                                              }

                                                                              // Close the bottom sheet
                                                                              Navigator.pop(context);

                                                                              // Log the selected option title
                                                                              debugPrint('${option.title} selected');
                                                                            }),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext context, int index) {
                                                                      return 12.verticalSpace;
                                                                    },
                                                                  ),
                                                                ],
                                                              ));
                                                        }),
                                                  );
                                                },
                                                separatorBuilder: (BuildContext context, int index) {
                                                  return 12.verticalSpace;
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                            : UIComponent.showCustomBottomSheet(
                                            horizontalPadding: 0,
                                            context: context,
                                            builder: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  appStrings(context).lblContactNow,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(fontWeight: FontWeight.w700),
                                                ),
                                                24.verticalSpace,
                                                ListView.separated(
                                                  shrinkWrap: true,
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: cubit.contactNowOptions.length,
                                                  itemBuilder: (context, index) {
                                                    final option = cubit.contactNowOptions[index];
                                                    final isWhatsApp = option.title.toLowerCase() == "whatsapp";

                                                    return Container(
                                                      margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        gradient: isWhatsApp ? AppColors.primaryGradient : null,
                                                        color: !isWhatsApp
                                                            ? AppColors.greyF5.adaptiveColor(context,
                                                            lightModeColor: AppColors.greyF5,
                                                            darkModeColor: AppColors.black14)
                                                            : null,
                                                      ),
                                                      child: ListTile(
                                                          leading: Container(
                                                            padding: const EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              color: isWhatsApp
                                                                  ? AppColors.white
                                                                  : AppColors.colorPrimary
                                                                  .withOpacity(0.10)
                                                                  .adaptiveColor(context,
                                                                  lightModeColor:
                                                                  AppColors.colorPrimary.withOpacity(0.10),
                                                                  darkModeColor: AppColors.colorPrimary),
                                                              borderRadius: BorderRadius.circular(8), // Rounded container
                                                            ),
                                                            child: option.icon.toSvg(
                                                              context: context,
                                                              color: AppColors.colorPrimary.adaptiveColor(context,
                                                                  lightModeColor: AppColors.colorPrimary,
                                                                  darkModeColor: isWhatsApp
                                                                      ? AppColors.colorPrimary
                                                                      : AppColors.white),
                                                            ),
                                                          ),
                                                          title: Text(
                                                            option.title,
                                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                              color: isWhatsApp
                                                                  ? AppColors.white
                                                                  : Theme.of(context).primaryColor,
                                                            ),
                                                          ),
                                                          trailing: SVGAssets.arrowRightIcon.toSvg(
                                                            context: context,
                                                            color: isWhatsApp
                                                                ? AppColors.white
                                                                : AppColors.colorPrimary.adaptiveColor(context,
                                                                lightModeColor: AppColors.colorPrimary,
                                                                darkModeColor: AppColors.white),
                                                          ),
                                                          onTap: () async {
                                                            switch (index) {
                                                              case 0:
                                                              // Get phone code and contact number
                                                                final phoneCode = cubit.myPropertyDetails.contactNumber
                                                                    ?.phoneCode; // Example: 91
                                                                final contactNumber = cubit.myPropertyDetails
                                                                    .contactNumber?.contactNumber; // Example: 9898563902

                                                                // Format the phone number to include the phoneCode
                                                                final formattedPhoneNumber = '+$phoneCode$contactNumber';

                                                                // Make the phone call
                                                                Utils.makePhoneCall(
                                                                  context: context,
                                                                  phoneNumber: formattedPhoneNumber.toString(),
                                                                );

                                                                // Log the event for direct call
                                                                AnalyticsService.logEvent(
                                                                  eventName: "property_direct_call_click",
                                                                  parameters: {
                                                                    AppConstants.analyticsIdOfUserKey:
                                                                    cubit.selectedUserId,
                                                                    AppConstants.analyticsPropertyIdKey: widget.sId,
                                                                    AppConstants.analyticsContactNumberKey:
                                                                    formattedPhoneNumber.toString(),
                                                                    AppConstants.analyticsUserTypeKey:
                                                                    cubit.selectedUserRole,
                                                                  },
                                                                );

                                                                debugPrint('Item 0 (Direct Call) selected');
                                                                break;

                                                              case 1:
                                                              // Get phone code and contact number
                                                                final phoneCode = cubit.myPropertyDetails.contactNumber
                                                                    ?.phoneCode; // Example: 91
                                                                final contactNumber = cubit.myPropertyDetails
                                                                    .contactNumber?.contactNumber; // Example: 9898563902

                                                                // Format the phone number to include the phoneCode
                                                                final formattedPhoneNumber = '+$phoneCode$contactNumber';

                                                                // Make WhatsApp call
                                                                Utils.makeWhatsAppCall(
                                                                  context: context,
                                                                  phoneNumber: formattedPhoneNumber.toString(),
                                                                );

                                                                // Log the event for WhatsApp call
                                                                AnalyticsService.logEvent(
                                                                  eventName: "property_whatsapp_click",
                                                                  parameters: {
                                                                    AppConstants.analyticsIdOfUserKey:
                                                                    cubit.selectedUserId,
                                                                    AppConstants.analyticsPropertyIdKey: widget.sId,
                                                                    AppConstants.analyticsContactNumberKey:
                                                                    formattedPhoneNumber.toString(),
                                                                    AppConstants.analyticsUserTypeKey:
                                                                    cubit.selectedUserRole,
                                                                  },
                                                                );

                                                                debugPrint('Item 1 (WhatsApp) selected');
                                                                break;

                                                              case 2:
                                                              // Get phone code and contact number
                                                                final phoneCode = cubit.myPropertyDetails.contactNumber
                                                                    ?.phoneCode; // Example: 91
                                                                final contactNumber = cubit.myPropertyDetails
                                                                    .contactNumber?.contactNumber; // Example: 9898563902

                                                                // Format the phone number to include the phoneCode
                                                                final formattedPhoneNumber = '+$phoneCode$contactNumber';

                                                                // Send SMS
                                                                Utils.makeSms(
                                                                  context: context,
                                                                  phoneNumber: formattedPhoneNumber.toString(),
                                                                );

                                                                // Log the event for text message
                                                                AnalyticsService.logEvent(
                                                                  eventName: "property_text_message_click",
                                                                  parameters: {
                                                                    AppConstants.analyticsIdOfUserKey:
                                                                    cubit.selectedUserId,
                                                                    AppConstants.analyticsPropertyIdKey: widget.sId,
                                                                    AppConstants.analyticsContactNumberKey:
                                                                    formattedPhoneNumber.toString(),
                                                                    AppConstants.analyticsUserTypeKey:
                                                                    cubit.selectedUserRole,
                                                                  },
                                                                );

                                                                debugPrint('Item 2 (Text) selected');
                                                                break;

                                                              default:
                                                              // Default action for other items
                                                                debugPrint('Item $index selected: ${option.title}');
                                                                break;
                                                            }

                                                            // Close the bottom sheet
                                                            Navigator.pop(context);

                                                            // Log the selected option title
                                                            debugPrint('${option.title} selected');
                                                          }),
                                                    );
                                                  },
                                                  separatorBuilder: (BuildContext context, int index) {
                                                    return 12.verticalSpace;
                                                  },
                                                ),
                                              ],
                                            ));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.greyF8.adaptiveColor(context,
                                              lightModeColor: AppColors.greyF8, darkModeColor: AppColors.black14),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.greyE9.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.greyE9,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: SVGAssets.callIcon.toSvg(
                                          context: context,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    UIComponent.customInkWellWidget(
                                      onTap: () {
                                        context.read<DashboardCubit>().isGuest
                                            ? _showGuestUserBottomSheet(context)
                                            : ((cubit.myPropertyDetails.isVisitRequest ?? false))
                                            ? null
                                            : context.pushNamed(Routes.kVisitRequest, extra: cubit.myPropertyDetails.sId);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.greyF8.adaptiveColor(context,
                                              lightModeColor: AppColors.greyF8, darkModeColor: AppColors.black14),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.greyE9.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.greyE9,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: SVGAssets.calenderIcon.toSvg(
                                          context: context,
                                          color: ((cubit.myPropertyDetails.isVisitRequest ?? false))
                                              ? AppColors.black14
                                              .adaptiveColor(context,
                                              lightModeColor: AppColors.black14, darkModeColor: AppColors.white)
                                              .withOpacity(0.3)
                                              : Theme.of(context).primaryColor,
                                        ),
                                      ).hideIf((cubit.myPropertyDetails.isSoldOut ?? false) || cubit.isVendor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
                            child: CustomDivider.colored(context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appStrings(context).lblOffers,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
                              ),
                              UIComponent.customInkWellWidget(
                                  onTap: () {
                                    context.pushNamed(Routes.kOfferListScreen, pathParameters: {
                                      RouteArguments.offersList: cubit.offersList.isNotEmpty
                                          ? jsonEncode(cubit.offersList.map((e) => e.toJson()).toList())
                                          : jsonEncode([]),
                                    });
                                  },
                                  child: (TextDirection.rtl == Directionality.of(context)
                                      ? SVGAssets.arrowLeftIcon
                                      : SVGAssets.arrowRightIcon)
                                      .toSvg(
                                      context: context,
                                      color: AppColors.black14.adaptiveColor(context,
                                          lightModeColor: AppColors.black14, darkModeColor: AppColors.white))),
                            ],
                          ).showIf(cubit.isVendor && cubit.offersList.isNotEmpty),
                          8.verticalSpace.showIf(cubit.isVendor && cubit.offersList.isNotEmpty),
                          rowItem().showIf(cubit.isVendor && cubit.offersList.isNotEmpty),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
                            child: CustomDivider.colored(context),
                          ).showIf(cubit.isVendor && cubit.offersList.isNotEmpty),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              appStrings(context).livingSpace,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
                            ),
                          ).showIf(cubit.myPropertyDetails.livingSpaceDataNotEmpty()),
                          Skeleton.unite(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  if (cubit.myPropertyDetails.furnishedData != null &&
                                      cubit.myPropertyDetails.furnishedData?.name?.isNotEmpty == true)
                                    UIComponent.iconRowAndText(
                                      context: context,
                                      svgPath: SVGAssets.cabinetIcon,
                                      text: cubit.myPropertyDetails.furnishedData?.name ?? '',
                                      backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorBgPrimary,
                                        darkModeColor: AppColors.black2E,
                                      ),
                                      textColor: AppColors.colorSecondary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white,
                                      ),
                                    ),
                                  if (cubit.myPropertyDetails.floorsData != null &&
                                      cubit.myPropertyDetails.floorsData?.name?.isNotEmpty == true)
                                    UIComponent.dynamicIconRowAndText(
                                      context: context,
                                      svgPath: SVGAssets.floorIcon,
                                      text: cubit.myPropertyDetails.floorsData?.name ?? '',
                                      backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorBgPrimary,
                                        darkModeColor: AppColors.black2E,
                                      ),
                                      textColor: AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white,
                                      ),
                                    ),
                                  if (cubit.myPropertyDetails.bedroomData != null &&
                                      cubit.myPropertyDetails.bedroomData?.name?.isNotEmpty == true)
                                    UIComponent.dynamicIconRowAndText(
                                      context: context,
                                      svgPath: SVGAssets.bedIcon,
                                      text: cubit.myPropertyDetails.bedroomData?.name ?? '',
                                      backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorBgPrimary,
                                        darkModeColor: AppColors.black2E,
                                      ),
                                      textColor: AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white,
                                      ),
                                    ),
                                  if (cubit.myPropertyDetails.bathroomData != null &&
                                      cubit.myPropertyDetails.bathroomData?.name?.isNotEmpty == true)
                                    UIComponent.dynamicIconRowAndText(
                                      context: context,
                                      svgPath: SVGAssets.bathTubIcon,
                                      text: cubit.myPropertyDetails.bathroomData?.name ?? '',
                                      backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorBgPrimary,
                                        darkModeColor: AppColors.black2E,
                                      ),
                                      textColor: AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white,
                                      ),
                                    ),
                                  if (cubit.myPropertyDetails.buildingAgeData != null &&
                                      cubit.myPropertyDetails.buildingAgeData?.name?.isNotEmpty == true)
                                    UIComponent.dynamicIconRowAndText(
                                      context: context,
                                      svgPath: SVGAssets.constructionStatusIcon,
                                      text: cubit.myPropertyDetails.buildingAgeData?.name ?? '',
                                      backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorBgPrimary,
                                        darkModeColor: AppColors.black2E,
                                      ),
                                      textColor: AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white,
                                      ),
                                    ),
                                  if (cubit.myPropertyDetails.facadeData != null &&
                                      cubit.myPropertyDetails.facadeData?.name?.isNotEmpty == true)
                                    UIComponent.dynamicIconRowAndText(
                                      context: context,
                                      svgPath: SVGAssets.directionIcon,
                                      text: cubit.myPropertyDetails.facadeData?.name ?? '',
                                      backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorBgPrimary,
                                        darkModeColor: AppColors.black2E,
                                      ),
                                      textColor: AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white,
                                      ),
                                    ),
                                  if (cubit.myPropertyDetails.mortgaged != null)
                                    UIComponent.dynamicIconRowAndText(
                                      context: context,
                                      svgPath: SVGAssets.mortgageIcon,
                                      text: (cubit.myPropertyDetails.mortgaged ?? false)
                                          ? appStrings(context).mortgaged
                                          : appStrings(context).debtFree,
                                      backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorBgPrimary,
                                        darkModeColor: AppColors.black2E,
                                      ),
                                      textColor: AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white,
                                      ),
                                    ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
                            child: CustomDivider.colored(context),
                          ).showIf(cubit.myPropertyDetails.livingSpaceDataNotEmpty()),
                          Text(
                            appStrings(context).amenities,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
                          ).showIf(cubit.myPropertyDetails.propertyAmenitiesData != null &&
                              cubit.myPropertyDetails.propertyAmenitiesData!.isNotEmpty),
                          8.verticalSpace.showIf(cubit.myPropertyDetails.propertyAmenitiesData != null &&
                              cubit.myPropertyDetails.propertyAmenitiesData!.isNotEmpty),
                          Skeleton.unite(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: (cubit.myPropertyDetails.propertyAmenitiesData ?? []).map<Widget>((amenities) {
                                  return UIComponent.dynamicIconRowAndText(
                                    context: context,
                                    svgPath: amenities.amenityIcon ?? "",
                                    // Helper method for dynamic SVG path
                                    text: amenities.name ?? "N/A",
                                    // Display the value or fallback text
                                    backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                      context,
                                      lightModeColor: AppColors.colorBgPrimary,
                                      darkModeColor: AppColors.black2E,
                                    ),
                                    textColor: AppColors.colorPrimary.adaptiveColor(
                                      context,
                                      lightModeColor: AppColors.colorPrimary,
                                      darkModeColor: AppColors.white,
                                    ),
                                  );
                                }).toList(),
                              )).showIf(cubit.myPropertyDetails.propertyAmenitiesData != null &&
                              cubit.myPropertyDetails.propertyAmenitiesData!.isNotEmpty),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
                            child: CustomDivider.colored(context),
                          ).showIf(cubit.myPropertyDetails.propertyAmenitiesData != null &&
                              cubit.myPropertyDetails.propertyAmenitiesData!.isNotEmpty),
                          Text(
                            appStrings(context).nearByFacilities,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
                          ).showIf(cubit.myPropertyDetails.neighbourHoodTypeData != null &&
                              cubit.myPropertyDetails.neighbourHoodTypeData!.isNotEmpty),
                          8.verticalSpace.showIf(cubit.myPropertyDetails.neighbourHoodTypeData != null &&
                              cubit.myPropertyDetails.neighbourHoodTypeData!.isNotEmpty),
                          Skeleton.unite(
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: (cubit.myPropertyDetails.neighbourHoodTypeData ?? []).map<Widget>((neighbourHoodTypeData) {
                                  return UIComponent.customInkWellWidget(
                                      onTap: () {
                                        Utils.openMapWithMarker(
                                            latitude: neighbourHoodTypeData.latitude ?? 0.0,
                                            longitude: neighbourHoodTypeData.longitude ?? 0.0);
                                      },
                                      child: UIComponent.dynamicIconRowAndText(
                                        context: context,
                                        svgPath: neighbourHoodTypeData.neighborhoodType?.neighbourHoodIcon ?? "",
                                        // Helper method for dynamic SVG path
                                        text: neighbourHoodTypeData.address ?? "N/A",
                                        // Display the value or fallback text
                                        backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.colorBgPrimary,
                                          darkModeColor: AppColors.black2E,
                                        ),
                                        textColor: AppColors.colorPrimary.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.colorPrimary,
                                          darkModeColor: AppColors.white,
                                        ),
                                      ));
                                }).toList(),
                              )).showIf(cubit.myPropertyDetails.neighbourHoodTypeData != null &&
                              cubit.myPropertyDetails.neighbourHoodTypeData!.isNotEmpty),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 16, horizontal: 0),
                            child: CustomDivider.colored(context),
                          ).showIf(cubit.myPropertyDetails.neighbourHoodTypeData != null &&
                              cubit.myPropertyDetails.neighbourHoodTypeData!.isNotEmpty),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appStrings(context).lblDocuments,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
                              ),
                              UIComponent.customInkWellWidget(
                                onTap: () {
                                  UIComponent.showCustomBottomSheet(
                                      horizontalPadding: 0,
                                      context: context,
                                      builder: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            appStrings(context).lblDocuments,
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                                          ),
                                          24.verticalSpace,
                                          if (propertyDocFiles.isNotEmpty || propertyDocFiles[0].isNotEmpty)
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: const ClampingScrollPhysics(),
                                              itemCount: propertyDocFiles.length,
                                              itemBuilder: (context, index) {
                                                final option = propertyDocFiles[index];

                                                return Container(
                                                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    color: AppColors.greyF5.adaptiveColor(context,
                                                        lightModeColor: AppColors.greyF5, darkModeColor: AppColors.black14),
                                                  ),
                                                  child: UIComponent.dataListTile(
                                                      title: StringUtils.extractFileNameWithExtension(
                                                        option,
                                                      ),
                                                      icon: option.contains("pdf")
                                                          ? SVGAssets.pdfIcon
                                                          : option.contains("text")
                                                          ? SVGAssets.textIcon
                                                          : SVGAssets.docIcon,
                                                      context: context,
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        await Utils.launchURL(url: option);
                                                      }),
                                                );
                                              },
                                              separatorBuilder: (BuildContext context, int index) {
                                                return 12.verticalSpace;
                                              },
                                            ),
                                        ],
                                      ));
                                },
                                child: Text(
                                  appStrings(context).lblViewAll,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor),
                                ).showIf(propertyDocFiles.isNotEmpty && propertyDocFiles.length > 3),
                              ),
                            ],
                          ).showIf(propertyDocFiles.isNotEmpty),
                          8.verticalSpace.showIf(propertyDocFiles.isNotEmpty),
                          Skeleton.unite(
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: (propertyDocFiles).take(3).map<Widget>((docData) {
                                  return UIComponent.customInkWellWidget(
                                      onTap: () async {
                                        await Utils.launchURL(url: docData);
                                      },
                                      child: UIComponent.dynamicIconRowAndText(
                                        context: context,
                                        svgPath: docData.endsWith(".pdf")
                                            ? SVGAssets.pdfIcon
                                            : docData.endsWith(".txt")
                                            ? SVGAssets.textIcon
                                            : SVGAssets.docIcon,
                                        text: StringUtils.extractFileNameWithExtension(docData),
                                        // Display the value or fallback text
                                        backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.colorBgPrimary,
                                          darkModeColor: AppColors.black2E,
                                        ),
                                        textColor: AppColors.colorPrimary.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.colorPrimary,
                                          darkModeColor: AppColors.white,
                                        ),
                                      ));
                                }).toList(),
                              )).showIf(propertyDocFiles.isNotEmpty),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 16, horizontal: 0),
                            child: CustomDivider.colored(context),
                          ).showIf(propertyDocFiles.isNotEmpty),
                        ],
                      ),
                    ),
                  ),
                  _buildMapContainer(
                      latitude: widget.propertyLatLng.latitude == 0
                          ? cubit.myPropertyDetails.propertyLocation?.latitude ?? 0
                          : widget.propertyLatLng.latitude,
                      longitude: widget.propertyLatLng.longitude == 0
                          ? cubit.myPropertyDetails.propertyLocation?.longitude ?? 0
                          : widget.propertyLatLng.longitude),
                  16.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapContainer({required double latitude, required double longitude}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: GoogleMapCardWidget(
        onButtonPressed: () {
          // Log the map view event
          AnalyticsService.logEvent(
            eventName: "property_google_map_click",
            parameters: {
              AppConstants.analyticsIdOfUserKey: context.read<PropertyDetailsCubit>().selectedUserId,
              AppConstants.analyticsUserTypeKey: context.read<PropertyDetailsCubit>().selectedUserRole,
              AppConstants.analyticsPropertyIdKey: widget.sId
            },
          );
          Utils.openMapWithMarker(latitude: latitude, longitude: longitude);
        },
        locationLatLng: LatLng(latitude, longitude),
        buttonText: appStrings(context).viewInMap,
      ),
    ).hideIf(latitude == 0.0 || longitude == 0.0);
  }

  Widget _buildImageSlider(PropertyDetailsCubit cubit) {
    final thumbnailImg = cubit.myPropertyDetails.thumbnail ?? "";
    var propertyFiles = <String>[];
    if (thumbnailImg.isNotEmpty) {
      propertyFiles.insert(0, thumbnailImg);
    }
    propertyFiles.addAll(Utils.getAllImageFiles(cubit.myPropertyDetails.propertyFiles ?? []));

    return Stack(
      children: [
        // Image slider
        propertyFiles.isNotEmpty
            ? PageView.builder(
          controller: _pageController,
          itemCount: propertyFiles.length,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final imageUrl = propertyFiles[index];
            return AspectRatio(
              aspectRatio: 1,
              child: UIComponent.customInkWellWidget(
                onTap: () {
                  context.pushNamed(Routes.kCarouselFullScreen,
                      pathParameters: {
                        RouteArguments.index: index.toString(),
                      },
                      extra: propertyFiles);
                },
                child: (imageUrl.toString().endsWith('.gif'))
                    ? MyGif(
                  gifUrl: imageUrl.toString(),
                  height: 300,
                )
                    : CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    SVGAssets.placeholder,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            );
          },
        )
            : Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SvgPicture.asset(
            SVGAssets.propertyPlaceholder,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        // Image indicator
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              propertyFiles.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPageIndex == index ? 12 : 8,
                height: _currentPageIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPageIndex == index ? AppColors.colorPrimary : Colors.grey,
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
          ),
        ),
        // App Bar indicator
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: buildAppBar(
              context: context,
              requireLeading: true,
              requireShareFavIcon: context.read<DashboardCubit>().isGuest ? false : true,
              isFavourite: cubit.myPropertyDetails.favorite ?? false,
                onBackTap: () async {
                if (context.canPop()) {
                  context.pop();
                } else {
                  var selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
                  if (selectedUserRole == AppStrings.owner) {
                    context.goNamed(Routes.kOwnerDashboard);
                  } else {
                    context.goNamed(Routes.kDashboard);
                  }
                }
              },
              notRequireFavIcon: (cubit.isVendor && cubit.myPropertyDetails.isSoldOut.toString() == "true"),
              onFavouriteToggle: (isFavourite) async {
                await cubit
                    .addRemoveFavorite(context: context, propertyId: cubit.myPropertyDetails.sId ?? "", isFav: isFavourite)
                    .then((value) {
                  Future.delayed(Duration.zero, () async {
                    if (!mounted) return;
                    HomeCubit homeCubit = context.read<HomeCubit>();
                    homeCubit.resetPropertyList();
                    homeCubit.refreshData();
                  });
                });
              },
              onShareTap: () {
                // Log the share event
                AnalyticsService.logEvent(
                  eventName: "property_share_icon_click",
                  parameters: {
                    AppConstants.analyticsIdOfUserKey: cubit.selectedUserId,
                    AppConstants.analyticsUserTypeKey: cubit.selectedUserRole,
                    AppConstants.analyticsPropertyIdKey: widget.sId
                  },
                );
                Utils.shareProperty(context, propertyDetails: cubit.myPropertyDetails);
              }),
        ),
      ],
    );
  }

  Widget rowItem() {
    return BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
      // bloc: PropertyDetailsCubit(),
      builder: (context, selectedIndex) {
        PropertyDetailsCubit cubit = context.read<PropertyDetailsCubit>();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  constraints:
                  BoxConstraints(minHeight: 160, maxHeight: UIComponent.isSystemFontMax(context) ? 210 : 170), // Adaptive height
                  color: AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black14),
                  child: ListView.separated(
                    itemCount: (cubit.offersList.length ?? 0) > 2 ? 2 : cubit.offersList.length ?? 0,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final detailModel.OfferData item = cubit.offersList[index];
                      return UIComponent.customInkWellWidget(
                        onTap: () {
                          context.pushNamed(Routes.kOfferDetailScreen,
                              pathParameters: {
                                RouteArguments.isDraftOffer: "false",
                              },
                              extra: item.sId?.trim());
                        },
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.colorPrimary.withOpacity(0.1),
                                blurRadius: 18,
                                offset: const Offset(2, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.adaptiveColor(context, lightModeColor: Colors.white, darkModeColor: AppColors.black2E),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.colorPrimary
                                        .adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white)),
                              ),
                              10.verticalSpace,
                              Text(
                                item.description ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey8A
                                        .adaptiveColor(context, lightModeColor: AppColors.grey8A, darkModeColor: AppColors.greyB0)),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                                child: CustomDivider.colored(context),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item.price != null
                                        ? num.parse(item.price!.amount.toString()).formatCurrency(
                                      showSymbol: true,
                                      currencySymbol: item.price!.currencySymbol ?? "",
                                    )
                                        : "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.colorPrimary.adaptiveColor(context,
                                            lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.greyB0)),
                                  ),
                                  UIComponent.customRTLIcon(
                                      child: SVGAssets.arrowRightIcon.toSvg(
                                          context: context,
                                          color: AppColors.black14
                                              .adaptiveColor(context, lightModeColor: AppColors.black14, darkModeColor: AppColors.white)),
                                      context: context),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return 24.horizontalSpace;
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

  /// Build bloc listener widget.
  ///
  Future<void> buildBlocListener(BuildContext context, PropertyDetailsState state) async {
    if (state is PropertyDetailsLoading) {
      // OverlayLoadingProgress.start(context);
    } else if (state is PropertyDetailsSuccess) {
      // OverlayLoadingProgress.stop();
    } else if (state is AddedToFavoriteForPropertyDetail) {
      OverlayLoadingProgress.stop();
      Utils.snackBar(context: context, message: state.successMessage);
      context.read<PropertyDetailsCubit>().getData(
        context,
        context.read<PropertyDetailsCubit>().sid,
      );
    } else if (state is PropertyDetailsError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    } else if (state is PropertyDetailsFailure) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    }
  }

  void _showGuestUserBottomSheet(BuildContext context) {
    UIComponent.showCustomBottomSheet(
        context: context,
        builder: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppAssets.loginToContinueImg.toAssetImage(height: 50, width: 50),
            12.verticalSpace,
            Text(
              appStrings(context).lblLogInToContinue,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.verticalSpace,
            Text(
              appStrings(context).textPleaseLogIn,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            ButtonRow(
              leftButtonText: appStrings(context).cancel,
              rightButtonText: appStrings(context).lblLogIn,
              onLeftButtonTap: () {
                context.pop();
              },
              onRightButtonTap: () {
                context.pop();
                context.goNamed(Routes.kLoginScreen);
              },
              rightButtonBorderColor: AppColors.colorPrimary,
              leftButtonBgColor: Theme.of(context).cardColor,
              leftButtonBorderColor: Theme.of(context).primaryColor,
              leftButtonTextColor: Theme.of(context).primaryColor,
              rightButtonGradientColor: AppColors.primaryGradient,
              rightButtonTextColor: AppColors.white.forLightMode(context),
              isLeftButtonGradient: false,
              isRightButtonGradient: true,
              isLeftButtonBorderRequired: true,
              isRightButtonBorderRequired: true,
              padding: const EdgeInsetsDirectional.all(0),
            ),
          ],
        ));
  }

  /// Navigate to bank offer details
  Future<void> _navigateToBankOffer(BuildContext context, PropertyDetailsCubit cubit) async {
    final propertyId = cubit.myPropertyDetails.sId ?? widget.sId;
    final vendorId = widget.vendorId.isEmpty ? "0" : widget.vendorId;
    final isForVendor = false;

    final vendorDetailCubit = context.read<VendorDetailCubit>();
    await vendorDetailCubit.getVendorOffers(
      vendorId: vendorId,
      propertyId: propertyId,
      context: context,
    );
    // Get banks list cubit
    final banksListCubit = context.read<BanksListCubit>();
    banksListCubit.getData(context);

    // Listen to the banks list state BEFORE making the API call
    final completer = Completer<void>();
    StreamSubscription<BanksListState>? subscription;
    bool isCompleted = false;

    subscription = banksListCubit.stream.listen((state) {
      if (isCompleted) return;

      if (state is BanksListSuccess) {
        final banksList = state.banksList;
        if (banksList.isNotEmpty) {
          final firstBank = banksList.first;
          final bankId = firstBank.bankId ?? firstBank.sId ?? "";

          if (bankId.isNotEmpty) {
            isCompleted = true;
            subscription?.cancel();
            if (!completer.isCompleted) {
              completer.complete();
            }
            _fetchBankOfferAndNavigate(
              context,
              bankId,
              propertyId,
              vendorId,
              isForVendor,
            );
            return;
          }
        }
        isCompleted = true;
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (mounted) {
          Utils.showErrorMessage(context: context, message: "No banks available for this property.");
        }
      } else if (state is BanksListError || state is NoBanksListFoundState) {
        isCompleted = true;
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (mounted) {
          Utils.showErrorMessage(context: context, message: "No banks available for this property.");
        }
      }
    });

    // Fetch banks list (this will trigger the stream listener)
    await banksListCubit.getBanksList(
      pageKey: 1,
      propertyId: propertyId,
      vendorId: vendorId,
      isForVendor: isForVendor,
    );

    // Wait for the response or timeout
    await completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        subscription?.cancel();
        if (mounted && !isCompleted) {
          Utils.showErrorMessage(context: context, message: "Failed to load banks. Please try again.");
        }
      },
    );
  }

  /// Fetch bank offer and navigate to offer details screen
  Future<void> _fetchBankOfferAndNavigate(
      BuildContext context,
      String bankId,
      String propertyId,
      String vendorId,
      bool isForVendor,
      ) async {

    // Get bank property offers
    final bankDetailsCubit = context.read<BankDetailsCubit>();
    if (isForVendor) {
      await bankDetailsCubit.getVendorBankPropertyOffers(
        vendorId: vendorId,
        bankId: bankId,
        context: context,
      );
    } else {
      await bankDetailsCubit.getBankPropertyOffers(
        propertyId: propertyId,
        bankId: bankId,
        context: context,
      );
    }

    // Get first offer from bank offers
    final offers = bankDetailsCubit.offers ?? [];
    if (offers.isNotEmpty) {
      final firstOffer = offers.first;
      final offerId = firstOffer.sId;

      if (offerId != null && offerId.isNotEmpty) {
        if (mounted) {
          debugPrint('Navigating to offer detail screen from bank with offerId: $offerId, bankId: $bankId');
          context.pushNamed(
            Routes.kOfferDetailScreen,
            pathParameters: {
              RouteArguments.offerId: offerId,
              RouteArguments.isDraftOffer: "false",
            },
            queryParameters: {
              RouteArguments.bankId: bankId,
              RouteArguments.propertyId: propertyId,
              RouteArguments.vendorId: vendorId,
              RouteArguments.isForVendor: "false",
            },
          );
        }
      } else {
        debugPrint('Error: Offer ID is empty or null from bank offers.');
        if (mounted) {
          Utils.showErrorMessage(context: context, message: "Bank offer details not available.");
        }
      }
    } else {
      debugPrint('Error: No offers found for bank.');
      if (mounted) {
        Utils.showErrorMessage(context: context, message: "No offers available for this bank.");
      }
    }
  }

  void _showBottomSheet(BuildContext context) {
    UIComponent.showCustomBottomSheet(
        context: context,
        builder: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: AppColors.colorPrimaryShade,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsetsDirectional.all(14),
                child: SVGAssets.userIcon.toSvg(context: context, height: 30, width: 30)),
            12.verticalSpace,
            Text(
              appStrings(context).lblCompleteProfileToContinue,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.verticalSpace,
            Text(
              appStrings(context).textPleaseAddDetails,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            ButtonRow(
              leftButtonText: appStrings(context).cancel,
              rightButtonText: appStrings(context).btnContinue,
              onLeftButtonTap: () {
                context.pop();
              },
              onRightButtonTap: () {
                context.pop();
                context.pushNamed(Routes.kPersonalInformationScreen).then((value) async {
                  if (!context.mounted) return;
                  context.read<VisitRequestCubit>().userSavedData =
                      await GetIt.I<AppPreferences>().getUserDetails() ?? VerifyResponseData();
                });
              },
              rightButtonBorderColor: AppColors.colorPrimary,
              leftButtonBgColor: Theme.of(context).cardColor,
              leftButtonBorderColor: Theme.of(context).primaryColor,
              leftButtonTextColor: Theme.of(context).primaryColor,
              rightButtonGradientColor: AppColors.primaryGradient,
              rightButtonTextColor: AppColors.white.forLightMode(context),
              isLeftButtonGradient: false,
              isRightButtonGradient: true,
              isLeftButtonBorderRequired: true,
              isRightButtonBorderRequired: true,
              padding: const EdgeInsetsDirectional.all(0),
            ),
            20.verticalSpace,
          ],
        ));
  }
}
