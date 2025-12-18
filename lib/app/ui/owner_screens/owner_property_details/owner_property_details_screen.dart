import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/bottom_navigation_widget/bottom_navigation_cubit.dart';
import 'package:mashrou3/app/ui/custom_widget/map_card_widget.dart';
import 'package:mashrou3/app/ui/custom_widget/my_gif_widget.dart';
import 'package:mashrou3/config/resources/app_values.dart';
import 'package:mashrou3/config/resources/text_styles.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/read_more_text.dart';
import 'package:mashrou3/utils/string_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../../config/resources/app_strings.dart';
import '../../../../utils/ui_components.dart';
import '../../../db/app_preferences.dart';
import '../../../navigation/routes.dart';
import '../../custom_widget/common_button.dart';
import '../../custom_widget/common_button_with_icon.dart';
import '../../custom_widget/common_row_bottons.dart';
import '../../custom_widget/loader/overlay_loading_progress.dart';
import 'cubit/owner_property_details_cubit.dart';

class OwnerPropertyDetailsScreen extends StatefulWidget {
  const OwnerPropertyDetailsScreen({
    super.key,
    required this.sId,
    required this.propertyLatLng,
    required this.isForInReview,
  });

  final String sId;
  final LatLng propertyLatLng;
  final bool isForInReview;

  @override
  State<OwnerPropertyDetailsScreen> createState() =>
      _OwnerPropertyDetailsScreenState();
}

class _OwnerPropertyDetailsScreenState extends State<OwnerPropertyDetailsScreen>
    with AppBarMixin {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    context
        .read<OwnerPropertyDetailsCubit>()
        .getData(context, widget.sId, widget.isForInReview);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerPropertyDetailsCubit, OwnerPropertyDetailsState>(
      listener: buildBlocListener,
      builder: (context, state) {
        return Scaffold(
          body: _buildBlocConsumer,
          bottomNavigationBar: SafeArea(
            child: BlocConsumer<OwnerPropertyDetailsCubit,
                OwnerPropertyDetailsState>(
              listener: (context, state) {},
              builder: (context, state) {
                OwnerPropertyDetailsCubit cubit =
                    context.read<OwnerPropertyDetailsCubit>();
                final isForInReview = widget.isForInReview;
                final isSoldOut = cubit.myPropertyDetails.isSoldOut ?? false;
                final isApproved = cubit.myPropertyDetails.isApproved ?? false;
                final isOwnerProperty = cubit.isLoginUserOwner;
                final shouldShowEditProperty =
                    isForInReview || (!isSoldOut && isApproved);
            
                if (cubit.myPropertyDetails.isDeleted ?? false) {
                  return const SizedBox.shrink();
                }
                return shouldShowEditProperty && isOwnerProperty
                    ? UIComponent.customInkWellWidget(
                        onTap: () async {
                          await context.pushNamed(Routes.kAddEditPropertyScreen1,
                              extra: widget.isForInReview,
                              pathParameters: {
                                RouteArguments.id: widget.isForInReview
                                    ? cubit.myPropertyDetails.sId ?? "0"
                                    : cubit.myPropertyDetails.sId ?? "0"
                              }).then((value) {});
                        },
                        child: Container(
                          height: 90,
                          decoration:
                              BoxDecoration(gradient: AppColors.primaryGradient),
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 16),
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
                                  padding: const EdgeInsetsDirectional.symmetric(
                                      horizontal: 16, vertical: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          SVGAssets.editIcon.toSvg(
                                              context: context,
                                              color: AppColors.colorPrimary),
                                          6.horizontalSpace,
                                          Text(
                                            appStrings(context).editProperty,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        AppColors.colorPrimary),
                                          ),
                                        ],
                                      ),
                                      SVGAssets.arrowRightIcon.toSvg(
                                          context: context,
                                          color: AppColors.colorPrimary),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : UIComponent.customInkWellWidget(
                        onTap: () async {},
                        child: Container(
                          height: 1,
                        ),
                      );
              },
            ).showIf(context
                        .read<OwnerPropertyDetailsCubit>()
                        .myPropertyDetails
                        .sId !=
                    null &&
                context.read<OwnerPropertyDetailsCubit>().myPropertyDetails.sId !=
                    ""),
          ),
        );
      },
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<OwnerPropertyDetailsCubit, OwnerPropertyDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        OwnerPropertyDetailsCubit cubit =
            context.read<OwnerPropertyDetailsCubit>();

        final propertyDocFiles =
            Utils.getAllDocFiles(cubit.myPropertyDetails.propertyFiles ?? []);

        return Skeletonizer(
          enabled: (cubit.myPropertyDetails.sId.toString() == "" ||
              state is OwnerPropertyDetailsLoading ||
              state is OwnerPropertyDetailsInitial),
          child: cubit.myPropertyDetails.sId.toString() == "null" ||
                  cubit.myPropertyDetails.sId.toString() == "" ||
                  state is OwnerPropertyDetailsLoading ||
                  state is OwnerPropertyDetailsInitial
              ? Skeletonizer(
                  enabled: true, child: UIComponent.getSkeletonPropertyDetail())
              : (cubit.myPropertyDetails.isDeleted ?? false)
                  ? PopScope(
                      canPop: false,
                      onPopInvokedWithResult:
                          (bool didPop, Object? result) async {
                        context.pop();
                        context.pop();
                      },
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: AppValues.screenHeight,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SVGAssets.noPropertyFound
                                    .toSvg(context: context),
                                40.verticalSpace,
                                Text(
                                  appStrings(context).textPropertyNotFound,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                                12.verticalSpace,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    appStrings(context)
                                        .textThePropertyYouAreLookingFor,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black3D
                                              .forLightMode(context),
                                        ),
                                  ),
                                ),
                                24.verticalSpace,
                                UIComponent.customInkWellWidget(
                                  onTap: () async {
                                    context
                                        .read<BottomNavCubit>()
                                        .selectIndex(0);
                                    var selectedUserRole =
                                        await GetIt.I<AppPreferences>()
                                                .getUserRole() ??
                                            "";
                                    if (selectedUserRole == AppStrings.owner) {
                                      context.goNamed(Routes.kOwnerDashboard);
                                    } else {
                                      context.goNamed(Routes.kDashboard);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsetsDirectional.all(4),
                                    width: AppValues.screenWidth / 3.4,
                                    height: 48,
                                    decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            appStrings(context).lblHome,
                                            textAlign: TextAlign.center,
                                            style: h16().copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                20.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          expandedHeight: 320.0,
                          pinned:
                              false, // Keep AppBar pinned for smooth transition
                          flexibleSpace: _buildImageSlider(cubit),
                        ),
                      ],
                      body: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 16.0, end: 16.0, top: 16),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            color: AppColors.greyF8
                                                .adaptiveColor(context,
                                                    lightModeColor:
                                                        AppColors.greyF8,
                                                    darkModeColor:
                                                        AppColors.black2E),
                                          ),
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(
                                            horizontal: 14.0,
                                            vertical: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                appStrings(context)
                                                    .rejectionReason,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors.red33),
                                              ),
                                              8.verticalSpace,
                                              ReadMoreText(
                                                cubit.myPropertyDetails
                                                        .reqDenyReasons ??
                                                    "",
                                                trimMode: TrimMode.Line,
                                                trimLines: 3,
                                                locale: Locale(
                                                    cubit.selectedLanguage),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors.black3D
                                                            .adaptiveColor(
                                                                context,
                                                                lightModeColor:
                                                                    AppColors
                                                                        .black3D,
                                                                darkModeColor:
                                                                    AppColors
                                                                        .greyB0)),
                                                trimCollapsedText:
                                                    appStrings(context)
                                                        .readMore,
                                                trimExpandedText:
                                                    appStrings(context)
                                                        .readLess,
                                                lessStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors.black3D
                                                            .adaptiveColor(
                                                                context,
                                                                lightModeColor:
                                                                    AppColors
                                                                        .black3D,
                                                                darkModeColor:
                                                                    AppColors
                                                                        .greyB0)),
                                                moreStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors.black3D
                                                            .adaptiveColor(
                                                                context,
                                                                lightModeColor:
                                                                    AppColors
                                                                        .black3D,
                                                                darkModeColor:
                                                                    AppColors
                                                                        .greyB0)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        18.verticalSpace,
                                      ],
                                    ).hideIf((cubit.myPropertyDetails
                                                .reqDenyReasons ??
                                            "") ==
                                        ""),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        cubit.myPropertyDetails.subCategoryData
                                                ?.name ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.colorSecondary
                                                  .adaptiveColor(context,
                                                      lightModeColor: AppColors
                                                          .colorSecondary,
                                                      darkModeColor:
                                                          AppColors.goldA1),
                                            ),
                                      ),
                                    ).showIf(cubit.myPropertyDetails
                                            .subCategoryData !=
                                        null),
                                    Text(
                                      cubit.myPropertyDetails.title ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                    8.verticalSpace,
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 18.0),
                                      child: ReadMoreText(
                                        cubit.myPropertyDetails.description ??
                                            "",
                                        trimMode: TrimMode.Line,
                                        trimLines: 3,
                                        locale: Locale(cubit.selectedLanguage),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.black3D
                                                    .adaptiveColor(context,
                                                        lightModeColor:
                                                            AppColors.black3D,
                                                        darkModeColor:
                                                            AppColors.greyB0)),
                                        trimCollapsedText:
                                            appStrings(context).readMore,
                                        trimExpandedText:
                                            appStrings(context).readLess,
                                        lessStyle: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.black3D
                                                    .adaptiveColor(context,
                                                        lightModeColor:
                                                            AppColors.black3D,
                                                        darkModeColor:
                                                            AppColors.greyB0)),
                                        moreStyle: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.black3D
                                                    .adaptiveColor(context,
                                                        lightModeColor:
                                                            AppColors.black3D,
                                                        darkModeColor:
                                                            AppColors.greyB0)),
                                      ),
                                    ).hideIf(
                                        (cubit.myPropertyDetails.description ??
                                                "") ==
                                            ""),
                                    CommonButton(
                                      isDynamicWidth: true,
                                      horizontalPadding: 12,
                                      onTap: () {},

                                      title: (() {
                                        // Get the price amount as a string
                                        final amountString = cubit
                                            .myPropertyDetails.price?.amount
                                            ?.toString();

                                        // Check if the amount is valid
                                        if (amountString == null ||
                                            amountString.isEmpty) {
                                          return ""; // Return an empty string if null or empty
                                        }

                                        try {
                                          // Parse the amount and format it as currency
                                          final amount =
                                              num.parse(amountString);
                                          return amount.formatCurrency(
                                            showSymbol: true,
                                            currencySymbol: cubit
                                                    .myPropertyDetails
                                                    .price
                                                    ?.currencySymbol ??
                                                "",
                                          );
                                        } catch (e) {
                                          // Handle invalid number format
                                          return "Invalid Price"; // Return a fallback value
                                        }
                                      })(),

                                      isBorderRequired: false,
                                      isGradientColor: true,
                                    ).hideIf(cubit.myPropertyDetails.price ==
                                            null ||
                                        cubit.myPropertyDetails.price?.amount ==
                                            null ||
                                        cubit.myPropertyDetails.price?.amount ==
                                            ""),
                                    16.verticalSpace,
                                    Skeleton.unite(
                                        child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: [
                                        Visibility(
                                            visible: cubit.myPropertyDetails
                                                    .country !=
                                                null,
                                            child: UIComponent.iconRowAndText(
                                              context: context,
                                              svgPath: SVGAssets.locationIcon,
                                              text:
                                                  '${cubit.myPropertyDetails.city?.isNotEmpty == true ? cubit.myPropertyDetails.city : ''}'
                                                  '${(cubit.myPropertyDetails.city?.isNotEmpty == true && cubit.myPropertyDetails.country?.isNotEmpty == true) ? ', ' : ''}'
                                                  '${cubit.myPropertyDetails.country?.isNotEmpty == true ? cubit.myPropertyDetails.country : ''}',
                                              backgroundColor: AppColors
                                                  .colorBgPrimary
                                                  .adaptiveColor(context,
                                                      lightModeColor: AppColors
                                                          .colorBgPrimary,
                                                      darkModeColor:
                                                          AppColors.black2E),
                                              textColor: AppColors.colorPrimary
                                                  .adaptiveColor(context,
                                                      lightModeColor: AppColors
                                                          .colorPrimary,
                                                      darkModeColor:
                                                          AppColors.white),
                                            )),
                                        Visibility(
                                            visible:
                                                cubit.myPropertyDetails.area !=
                                                    null,
                                            child: UIComponent.iconRowAndText(
                                              context: context,
                                              svgPath:
                                                  SVGAssets.aspectRatioIcon,
                                              text: Utils.formatArea(
                                                  '${cubit.myPropertyDetails.area?.amount ?? ''}',
                                                  cubit.myPropertyDetails.area
                                                          ?.unit ??
                                                      ''),
                                              backgroundColor: AppColors
                                                  .colorBgPrimary
                                                  .adaptiveColor(context,
                                                      lightModeColor: AppColors
                                                          .colorBgPrimary,
                                                      darkModeColor:
                                                          AppColors.black2E),
                                              textColor: AppColors
                                                  .colorSecondary
                                                  .adaptiveColor(context,
                                                      lightModeColor: AppColors
                                                          .colorPrimary,
                                                      darkModeColor:
                                                          AppColors.white),
                                            )),
                                        Visibility(
                                            visible: cubit.myPropertyDetails
                                                        .rating
                                                        .toString() !=
                                                    '0' &&
                                                !widget.isForInReview,
                                            child: UIComponent.iconRowAndText(
                                              svgPath: SVGAssets.starIcon,
                                              iconColor: AppColors.goldA1,
                                              context: context,
                                              text: cubit
                                                      .myPropertyDetails.rating
                                                      .toString() ??
                                                  "0",
                                              backgroundColor: AppColors
                                                  .colorBgPrimary
                                                  .adaptiveColor(context,
                                                      lightModeColor: AppColors
                                                          .colorBgPrimary,
                                                      darkModeColor:
                                                          AppColors.black2E),
                                              textColor: AppColors
                                                  .colorSecondary
                                                  .adaptiveColor(context,
                                                      lightModeColor: AppColors
                                                          .colorPrimary,
                                                      darkModeColor:
                                                          AppColors.white),
                                            )),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            2.horizontalSpace,
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: AppColors.greyE8
                                                    .adaptiveColor(context,
                                                        lightModeColor:
                                                            AppColors.greyE8,
                                                        darkModeColor:
                                                            AppColors.black2E),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            4.horizontalSpace,
                                            UIComponent.customInkWellWidget(
                                              onTap: () {
                                                context.pushNamed(
                                                    Routes.kViewReviewScreen,
                                                    extra: cubit
                                                        .myPropertyDetails.sId,
                                                    pathParameters: {
                                                      RouteArguments
                                                              .isReviewVisible:
                                                          "false",
                                                      RouteArguments
                                                              .userAddedRating:
                                                          true.toString(),
                                                    });
                                              },
                                              child: Text(
                                                "${cubit.myPropertyDetails.totalRatings?.toString() ?? "0"} ${appStrings(context).textReviews}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .colorPrimary
                                                            .adaptiveColor(
                                                                context,
                                                                lightModeColor:
                                                                    AppColors
                                                                        .colorPrimary,
                                                                darkModeColor:
                                                                    AppColors
                                                                        .goldA1),
                                                    decorationColor: AppColors
                                                        .colorPrimary.adaptiveColor(
                                                        context,
                                                        lightModeColor: AppColors
                                                            .colorPrimary,
                                                        darkModeColor: AppColors
                                                            .goldA1),
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                              ),
                                            ),
                                          ],
                                        ).hideIf(widget.isForInReview),
                                      ],
                                    )),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 16),
                                      child: CustomDivider.colored(context),
                                    ),
                                    Column(
                                      children: [
                                        IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: CommonButtonWithIcon(
                                                  onTap: () {
                                                    UIComponent
                                                        .showCustomBottomSheet(
                                                            horizontalPadding: 0,
                                                            context: context,
                                                            builder: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: 83,
                                                                  height: 5,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .black14,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                8),
                                                                  ),
                                                                ),
                                                                24.verticalSpace,
                                                                Text(
                                                                  appStrings(
                                                                          context)
                                                                      .videoLink,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge
                                                                      ?.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                                24.verticalSpace,
                                                                if (cubit.myPropertyDetails
                                                                            .videoLink !=
                                                                        null ||
                                                                    cubit
                                                                        .myPropertyDetails
                                                                        .videoLink!
                                                                        .isNotEmpty ||
                                                                    cubit
                                                                        .myPropertyDetails
                                                                        .videoLink![
                                                                            0]
                                                                        .isNotEmpty)
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const ClampingScrollPhysics(),
                                                                    itemCount: cubit
                                                                            .myPropertyDetails
                                                                            .videoLink
                                                                            ?.length ??
                                                                        0,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      final option =
                                                                          cubit.myPropertyDetails.videoLink?[index] ??
                                                                              "";

                                                                      return option
                                                                              .isNotEmpty
                                                                          ? Container(
                                                                              margin:
                                                                                  const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(16),
                                                                                color: AppColors.greyF5,
                                                                              ),
                                                                              child: ListTile(
                                                                                  leading: Container(
                                                                                    padding: const EdgeInsets.all(8),
                                                                                    decoration: BoxDecoration(
                                                                                      color: AppColors.colorPrimary.withOpacity(0.10),
                                                                                      borderRadius: BorderRadius.circular(8), // Rounded container
                                                                                    ),
                                                                                    child: SVGAssets.linkIcon.toSvg(
                                                                                      context: context,
                                                                                      color: AppColors.colorPrimary,
                                                                                    ),
                                                                                  ),
                                                                                  title: Text(
                                                                                    cubit.myPropertyDetails.videoLink!.length < 2 ? appStrings(context).link : "${appStrings(context).link} ${index + 1}",
                                                                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                                                          color: AppColors.black,
                                                                                        ),
                                                                                  ),
                                                                                  trailing: SVGAssets.arrowRightIcon.toSvg(
                                                                                    context: context,
                                                                                    color: AppColors.colorPrimary,
                                                                                  ),
                                                                                  onTap: () async {
                                                                                    Navigator.pop(context);
                                                                                    context.pushNamed(Routes.kWebViewScreen, extra: option, pathParameters: {
                                                                                      RouteArguments.title: appStrings(context).videoLink,
                                                                                    });
                                                                                  }),
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink();
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return 12
                                                                          .verticalSpace;
                                                                    },
                                                                  ),
                                                              ],
                                                            ));
                                                  },
                                                  isDisabled: ((cubit
                                                          .myPropertyDetails
                                                          .videoLink
                                                          ?.every((item) =>
                                                              item.isEmpty)) ??
                                                      true),
                                                  title:
                                                      appStrings(context).video,
                                                  icon: SVGAssets.playSquareIcon.toSvg(
                                                      context: context,
                                                      color: AppColors.colorPrimary.adaptiveColor(context,
                                                          lightModeColor: ((cubit.myPropertyDetails.videoLink?.every((item) => item.isEmpty)) ?? true)
                                                              ? AppColors.grey77.adaptiveColor(context,
                                                                  lightModeColor: AppColors
                                                                      .grey77,
                                                                  darkModeColor: AppColors
                                                                      .white)
                                                              : AppColors
                                                                  .colorPrimary,
                                                          darkModeColor: ((cubit.myPropertyDetails.videoLink?.every((item) => item.isEmpty)) ?? true)
                                                              ? AppColors.grey77.adaptiveColor(context,
                                                                  lightModeColor: AppColors.grey77,
                                                                  darkModeColor: AppColors.white)
                                                              : AppColors.white)),
                                                  borderColor: AppColors
                                                      .colorPrimary
                                                      .adaptiveColor(context,
                                                          lightModeColor:
                                                              AppColors
                                                                  .colorPrimary,
                                                          darkModeColor:
                                                              AppColors.white),
                                                  isGradientColor: false,
                                                  buttonTextColor: AppColors
                                                      .colorPrimary
                                                      .adaptiveColor(context,
                                                          lightModeColor:
                                                              AppColors
                                                                  .colorPrimary,
                                                          darkModeColor:
                                                              AppColors.white),
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
                                                    (cubit.myPropertyDetails
                                                                    .virtualTour ??
                                                                "") ==
                                                            ""
                                                        ? () {}
                                                        : context.pushNamed(
                                                            Routes.kWebViewScreen,
                                                            extra: cubit
                                                                    .myPropertyDetails
                                                                    .virtualTour ??
                                                                "",
                                                            pathParameters: {
                                                                RouteArguments
                                                                    .title: appStrings(
                                                                        context)
                                                                    .virtualTour,
                                                              });
                                                  },
                                                  title: appStrings(context)
                                                      .virtualTour,
                                                  isDisabled: (cubit
                                                                  .myPropertyDetails
                                                                  .virtualTour ??
                                                              "") ==
                                                          ""
                                                      ? true
                                                      : false,
                                                  icon: SVGAssets.virtual3dViewIcon.toSvg(
                                                      context: context,
                                                      color: (cubit.myPropertyDetails
                                                                      .virtualTour ??
                                                                  "") ==
                                                              ""
                                                          ? AppColors.grey77
                                                          : AppColors.white),
                                                  isGradientColor: true,
                                                  gradientColor:
                                                      AppColors.primaryGradient,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 16),
                                      child: CustomDivider.colored(context),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        appStrings(context).livingSpace,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                    ).showIf(cubit.myPropertyDetails
                                        .livingSpaceDataNotEmpty()),
                                    Skeleton.unite(
                                        child: Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        if (cubit.myPropertyDetails
                                                    .furnishedData !=
                                                null &&
                                            cubit
                                                    .myPropertyDetails
                                                    .furnishedData
                                                    ?.name
                                                    ?.isNotEmpty ==
                                                true)
                                          UIComponent.iconRowAndText(
                                            context: context,
                                            svgPath: SVGAssets.cabinetIcon,
                                            text: cubit.myPropertyDetails
                                                    .furnishedData?.name ??
                                                '',
                                            backgroundColor: AppColors
                                                .colorBgPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorBgPrimary,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            textColor: AppColors.colorSecondary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white,
                                            ),
                                          ),
                                        if (cubit.myPropertyDetails
                                                    .floorsData !=
                                                null &&
                                            cubit.myPropertyDetails.floorsData
                                                    ?.name?.isNotEmpty ==
                                                true)
                                          UIComponent.dynamicIconRowAndText(
                                            context: context,
                                            svgPath: SVGAssets.floorIcon,
                                            text: cubit.myPropertyDetails
                                                    .floorsData?.name ??
                                                '',
                                            backgroundColor: AppColors
                                                .colorBgPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorBgPrimary,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            textColor: AppColors.colorPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white,
                                            ),
                                          ),
                                        if (cubit.myPropertyDetails
                                                    .bedroomData !=
                                                null &&
                                            cubit.myPropertyDetails.bedroomData
                                                    ?.name?.isNotEmpty ==
                                                true)
                                          UIComponent.dynamicIconRowAndText(
                                            context: context,
                                            svgPath: SVGAssets.bedIcon,
                                            text: cubit.myPropertyDetails
                                                    .bedroomData?.name ??
                                                '',
                                            backgroundColor: AppColors
                                                .colorBgPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorBgPrimary,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            textColor: AppColors.colorPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white,
                                            ),
                                          ),
                                        if (cubit.myPropertyDetails
                                                    .bathroomData !=
                                                null &&
                                            cubit.myPropertyDetails.bathroomData
                                                    ?.name?.isNotEmpty ==
                                                true)
                                          UIComponent.dynamicIconRowAndText(
                                            context: context,
                                            svgPath: SVGAssets.bathTubIcon,
                                            text: cubit.myPropertyDetails
                                                    .bathroomData?.name ??
                                                '',
                                            backgroundColor: AppColors
                                                .colorBgPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorBgPrimary,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            textColor: AppColors.colorPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white,
                                            ),
                                          ),
                                        if (cubit.myPropertyDetails
                                                    .buildingAgeData !=
                                                null &&
                                            cubit
                                                    .myPropertyDetails
                                                    .buildingAgeData
                                                    ?.name
                                                    ?.isNotEmpty ==
                                                true)
                                          UIComponent.dynamicIconRowAndText(
                                            context: context,
                                            svgPath: SVGAssets
                                                .constructionStatusIcon,
                                            text: cubit.myPropertyDetails
                                                    .buildingAgeData?.name ??
                                                '',
                                            backgroundColor: AppColors
                                                .colorBgPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorBgPrimary,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            textColor: AppColors.colorPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white,
                                            ),
                                          ),
                                        if (cubit.myPropertyDetails
                                                    .facadeData !=
                                                null &&
                                            cubit.myPropertyDetails.facadeData
                                                    ?.name?.isNotEmpty ==
                                                true)
                                          UIComponent.dynamicIconRowAndText(
                                            context: context,
                                            svgPath: SVGAssets.directionIcon,
                                            text: cubit.myPropertyDetails
                                                    .facadeData?.name ??
                                                '',
                                            backgroundColor: AppColors
                                                .colorBgPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorBgPrimary,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            textColor: AppColors.colorPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white,
                                            ),
                                          ),
                                        if (cubit.myPropertyDetails.mortgaged !=
                                            null)
                                          UIComponent.dynamicIconRowAndText(
                                            context: context,
                                            svgPath: SVGAssets.mortgageIcon,
                                            text: (cubit.myPropertyDetails
                                                        .mortgaged ??
                                                    false)
                                                ? appStrings(context).mortgaged
                                                : appStrings(context).debtFree,
                                            backgroundColor: AppColors
                                                .colorBgPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorBgPrimary,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            textColor: AppColors.colorPrimary
                                                .adaptiveColor(
                                              context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white,
                                            ),
                                          ),
                                      ],
                                    )),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 16),
                                      child: CustomDivider.colored(context),
                                    ).showIf(cubit.myPropertyDetails
                                        .livingSpaceDataNotEmpty()),
                                    Text(
                                      appStrings(context).amenities,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ).showIf(cubit.myPropertyDetails
                                                .propertyAmenitiesData !=
                                            null &&
                                        cubit.myPropertyDetails
                                            .propertyAmenitiesData!.isNotEmpty),
                                    8.verticalSpace.showIf(cubit
                                                .myPropertyDetails
                                                .propertyAmenitiesData !=
                                            null &&
                                        cubit.myPropertyDetails
                                            .propertyAmenitiesData!.isNotEmpty),
                                    Skeleton.unite(
                                        child: Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: (cubit.myPropertyDetails
                                                  .propertyAmenitiesData ??
                                              [])
                                          .map<Widget>((amenities) {
                                        return UIComponent
                                            .dynamicIconRowAndText(
                                          context: context,
                                          svgPath: amenities.amenityIcon ?? "",
                                          text: amenities.name ?? "N/A",
                                          backgroundColor: AppColors
                                              .colorBgPrimary
                                              .adaptiveColor(
                                            context,
                                            lightModeColor:
                                                AppColors.colorBgPrimary,
                                            darkModeColor: AppColors.black2E,
                                          ),
                                          textColor: AppColors.colorPrimary
                                              .adaptiveColor(
                                            context,
                                            lightModeColor:
                                                AppColors.colorPrimary,
                                            darkModeColor: AppColors.white,
                                          ),
                                        );
                                      }).toList(),
                                    )).showIf(cubit.myPropertyDetails
                                                .propertyAmenitiesData !=
                                            null &&
                                        cubit.myPropertyDetails
                                            .propertyAmenitiesData!.isNotEmpty),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 16),
                                      child: CustomDivider.colored(context),
                                    ).showIf(cubit.myPropertyDetails
                                                .propertyAmenitiesData !=
                                            null &&
                                        cubit.myPropertyDetails
                                            .propertyAmenitiesData!.isNotEmpty),
                                    Text(
                                      appStrings(context).nearByFacilities ??
                                          "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ).showIf(cubit.myPropertyDetails
                                                .neighbourHoodTypeData !=
                                            null &&
                                        cubit.myPropertyDetails
                                            .neighbourHoodTypeData!.isNotEmpty),
                                    8.verticalSpace.showIf(cubit
                                                .myPropertyDetails
                                                .neighbourHoodTypeData !=
                                            null &&
                                        cubit.myPropertyDetails
                                            .neighbourHoodTypeData!.isNotEmpty),
                                    Skeleton.unite(
                                        child: Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: (cubit.myPropertyDetails
                                                  .neighbourHoodTypeData ??
                                              [])
                                          .map<Widget>((neighbourHoodTypeData) {
                                        return UIComponent.customInkWellWidget(
                                            onTap: () {
                                              Utils.openMapWithMarker(
                                                  latitude:
                                                      neighbourHoodTypeData
                                                              .latitude ??
                                                          0.0,
                                                  longitude:
                                                      neighbourHoodTypeData
                                                              .longitude ??
                                                          0.0);
                                            },
                                            child: UIComponent
                                                .dynamicIconRowAndText(
                                              context: context,
                                              svgPath: neighbourHoodTypeData
                                                      .neighborhoodType
                                                      ?.neighbourHoodIcon ??
                                                  "",
                                              text: neighbourHoodTypeData
                                                      .address ??
                                                  "N/A",
                                              backgroundColor: AppColors
                                                  .colorBgPrimary
                                                  .adaptiveColor(
                                                context,
                                                lightModeColor:
                                                    AppColors.colorBgPrimary,
                                                darkModeColor:
                                                    AppColors.black2E,
                                              ),
                                              textColor: AppColors.colorPrimary
                                                  .adaptiveColor(
                                                context,
                                                lightModeColor:
                                                    AppColors.colorPrimary,
                                                darkModeColor: AppColors.white,
                                              ),
                                            ));
                                      }).toList(),
                                    )).showIf(cubit.myPropertyDetails
                                                .neighbourHoodTypeData !=
                                            null &&
                                        cubit.myPropertyDetails
                                            .neighbourHoodTypeData!.isNotEmpty),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 16, horizontal: 0),
                                      child: CustomDivider.colored(context),
                                    ).showIf(cubit.myPropertyDetails
                                                .neighbourHoodTypeData !=
                                            null &&
                                        cubit.myPropertyDetails
                                            .neighbourHoodTypeData!.isNotEmpty),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          appStrings(context).lblDocuments ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        UIComponent.customInkWellWidget(
                                          onTap: () {
                                            UIComponent.showCustomBottomSheet(
                                                horizontalPadding: 0,
                                                context: context,
                                                builder: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      appStrings(context)
                                                          .lblDocuments,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    24.verticalSpace,
                                                    if (propertyDocFiles
                                                            .isNotEmpty ||
                                                        propertyDocFiles[0]
                                                            .isNotEmpty)
                                                      ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount:
                                                            propertyDocFiles
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final option =
                                                              propertyDocFiles[
                                                                  index];

                                                          return Container(
                                                            margin:
                                                                const EdgeInsetsDirectional
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              color: AppColors
                                                                  .greyF5,
                                                            ),
                                                            child: ListTile(
                                                                leading:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .colorPrimary
                                                                        .withOpacity(
                                                                            0.10),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8), // Rounded container
                                                                  ),
                                                                  child: option
                                                                          .contains(
                                                                              "pdf")
                                                                      ? SVGAssets
                                                                          .pdfIcon
                                                                          .toSvg(
                                                                              context:
                                                                                  context)
                                                                      : option.contains(
                                                                              "text")
                                                                          ? SVGAssets.textIcon.toSvg(
                                                                              context:
                                                                                  context)
                                                                          : SVGAssets
                                                                              .docIcon
                                                                              .toSvg(context: context),
                                                                ),
                                                                title: Text(
                                                                  StringUtils
                                                                      .extractFileNameWithExtension(
                                                                          option),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleSmall
                                                                      ?.copyWith(
                                                                        color: AppColors
                                                                            .black,
                                                                      ),
                                                                ),
                                                                trailing: SVGAssets
                                                                    .arrowRightIcon
                                                                    .toSvg(
                                                                  context:
                                                                      context,
                                                                  color: AppColors
                                                                      .colorPrimary,
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  await Utils
                                                                      .launchURL(
                                                                          url:
                                                                              option);
                                                                }),
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return 12
                                                              .verticalSpace;
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
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .highlightColor),
                                          ).showIf(
                                              propertyDocFiles.isNotEmpty &&
                                                  propertyDocFiles.length > 3),
                                        ),
                                      ],
                                    ).showIf(propertyDocFiles.isNotEmpty),
                                    8
                                        .verticalSpace
                                        .showIf(propertyDocFiles.isNotEmpty),
                                    Skeleton.unite(
                                        child: Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: (propertyDocFiles)
                                          .take(3)
                                          .map<Widget>((docData) {
                                        return UIComponent.customInkWellWidget(
                                            onTap: () async {
                                              await Utils.launchURL(
                                                  url: docData);
                                            },
                                            child: UIComponent
                                                .dynamicIconRowAndText(
                                              context: context,
                                              svgPath: docData.endsWith(".pdf")
                                                  ? SVGAssets.pdfIcon
                                                  : docData.endsWith(".txt")
                                                      ? SVGAssets.textIcon
                                                      : SVGAssets.docIcon,
                                              // Helper method for dynamic SVG path
                                              text: StringUtils
                                                  .extractFileNameWithExtension(
                                                      docData),
                                              // Display the value or fallback text
                                              backgroundColor: AppColors
                                                  .colorBgPrimary
                                                  .adaptiveColor(
                                                context,
                                                lightModeColor:
                                                    AppColors.colorBgPrimary,
                                                darkModeColor:
                                                    AppColors.black2E,
                                              ),
                                              textColor: AppColors.colorPrimary
                                                  .adaptiveColor(
                                                context,
                                                lightModeColor:
                                                    AppColors.colorPrimary,
                                                darkModeColor: AppColors.white,
                                              ),
                                            ));
                                      }).toList(),
                                    )).showIf(propertyDocFiles.isNotEmpty),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 16, horizontal: 0),
                                      child: CustomDivider.colored(context),
                                    ).showIf(propertyDocFiles.isNotEmpty),
                                  ],
                                ),
                              ),
                            ),
                            _buildMapContainer(
                                latitude: widget.propertyLatLng.latitude == 0
                                    ? cubit.myPropertyDetails.propertyLocation
                                            ?.latitude ??
                                        0
                                    : widget.propertyLatLng.latitude,
                                longitude: widget.propertyLatLng.longitude == 0
                                    ? cubit.myPropertyDetails.propertyLocation
                                            ?.longitude ??
                                        0
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

  Widget _buildMapContainer(
      {required double latitude, required double longitude}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: GoogleMapCardWidget(
        onButtonPressed: () {
          Utils.openMapWithMarker(latitude: latitude, longitude: longitude);
        },
        locationLatLng: LatLng(latitude, longitude),
        buttonText: appStrings(context).viewInMap,
      ),
    ).hideIf(latitude == 0.0 || longitude == 0.0);
  }

  Widget _buildImageSlider(OwnerPropertyDetailsCubit cubit) {
    final thumbnailImg = cubit.myPropertyDetails.thumbnail ?? "";
    var propertyFiles = <String>[];
    if (thumbnailImg.isNotEmpty) {
      propertyFiles.insert(0, thumbnailImg);
    }
    propertyFiles.addAll(
        Utils.getAllImageFiles(cubit.myPropertyDetails.propertyFiles ?? []));

    return Stack(
      children: [
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
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(
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
                  color: _currentPageIndex == index
                      ? AppColors.colorPrimary
                      : Colors.grey,
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
          child: Container(
            child: buildAppBar(
                context: context,
                requireLeading: true,
                requireShareMoreIcon: true,
                isMoreOnly: widget.isForInReview,
                isForInReview: widget.isForInReview,
                isSoldOut: cubit.myPropertyDetails.isSoldOut ?? false,
                onBackTap: () async {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    var selectedUserRole =
                        await GetIt.I<AppPreferences>().getUserRole() ?? "";
                    if (selectedUserRole == AppStrings.owner) {
                      context.goNamed(Routes.kOwnerDashboard);
                    } else {
                      context.goNamed(Routes.kDashboard);
                    }
                  }
                },
                onDeletePropertyTap: () async {
                  if (cubit.isLoginUserOwner) {
                    UIComponent.showCustomBottomSheet(
                        context: context,
                        builder: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SVGAssets.deleteVector
                                .toSvg(height: 50, width: 50, context: context),
                            14.verticalSpace,
                            Text(
                              appStrings(context).sureYouWantToDelete,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            8.verticalSpace,
                            Text(
                              '${appStrings(context).sureYouWantToDeleteInfo}${cubit.myPropertyDetails.title ?? ''}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            12.verticalSpace,
                            ButtonRow(
                              leftButtonText: appStrings(context).cancel,
                              rightButtonText: appStrings(context).yes,
                              onLeftButtonTap: () {
                                Navigator.pop(context);
                              },
                              onRightButtonTap: () async {
                                widget.isForInReview
                                    ? await cubit
                                        .deletePropertyInReview(
                                        propertyIds:
                                            cubit.myPropertyDetails.sId != null
                                                ? [cubit.myPropertyDetails.sId!]
                                                : [],
                                      )
                                        .then((value) {
                                        Future.delayed(Duration.zero, () {});
                                      })
                                    : await cubit
                                        .deleteProperty(
                                        propertyIds:
                                            cubit.myPropertyDetails.sId != null
                                                ? [cubit.myPropertyDetails.sId!]
                                                : [],
                                      )
                                        .then((value) {
                                        Future.delayed(Duration.zero, () {});
                                      });
                              },
                              rightButtonBorderColor: AppColors.red00,
                              rightButtonBgColor: AppColors.red00,
                              leftButtonBgColor: Theme.of(context).cardColor,
                              leftButtonBorderColor:
                                  Theme.of(context).primaryColor,
                              leftButtonTextColor:
                                  Theme.of(context).primaryColor,
                              rightButtonTextColor: AppColors.white,
                              isLeftButtonGradient: false,
                              isRightButtonGradient: false,
                              isLeftButtonBorderRequired: true,
                              isRightButtonBorderRequired: true,
                            ),
                          ],
                        ));
                  }
                },
                onSoldOutTap: () async {
                  if (cubit.isLoginUserOwner) {
                    await cubit
                        .soldOutProperty(
                      context: context,
                      propertyId: cubit.myPropertyDetails.sId ?? "",
                    )
                        .then((value) {
                      Future.delayed(Duration.zero, () async {
                        context.goNamed(Routes.kOwnerDashboard);
                      });
                    });
                  }
                },
                onShareTap: () {
                  if (cubit.isLoginUserOwner) {
                    Utils.shareProperty(context,
                        propertyDetails: cubit.myPropertyDetails);
                  }
                }),
          ),
        ),
      ],
    );
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(
      BuildContext context, OwnerPropertyDetailsState state) {
    if (state is DeletePropertySuccess) {
      OverlayLoadingProgress.stop();
      context.goNamed(Routes.kOwnerDashboard);
      Utils.snackBar(context: context, message: state.successMessage);
    } else if (state is SoldOutPropertySuccess) {
      OverlayLoadingProgress.stop();
      // context.pop();
      Utils.snackBar(context: context, message: state.successMessage);
    } else if (state is OwnerPropertyDetailsSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is OwnerPropertyDetailsError) {
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    } else if (state is OwnerNotValidForProperty) {
      Utils.showErrorMessage(
          context: context, message: appStrings(context).lblNoOwner);
      Future.delayed(const Duration(seconds: 2), () async {
        if (!mounted) return;
        if (!context.mounted) return;

        if (context.canPop()) {
          context.pop();
        } else {
          var selectedUserRole =
              await GetIt.I<AppPreferences>().getUserRole() ?? "";
          if (selectedUserRole == AppStrings.owner) {
            if (!mounted) return;
            if (!context.mounted) return;
            context.goNamed(Routes.kOwnerDashboard);
          } else {
            if (!mounted) return;
            if (!context.mounted) return;
            context.goNamed(Routes.kDashboard);
          }
        }
      });
    } else if (state is OwnerPropertyDetailsFailure) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    } else if (state is DeletePropertySuccess) {
      OverlayLoadingProgress.stop();
    }
  }
}

class OwnerDetailCategory {
  String name;
  String icon;

  OwnerDetailCategory(this.name, this.icon);
}
