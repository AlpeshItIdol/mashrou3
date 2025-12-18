import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/my_gif_widget.dart';
import 'package:mashrou3/app/ui/screens/finance_request/cubit/finance_request_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/cubit/property_details_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/cubit/vendor_detail_cubit.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/string_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../config/resources/app_assets.dart';
import '../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../../config/resources/app_strings.dart';
import '../../../../../../../utils/read_more_text.dart';
import '../../../../../../../utils/ui_components.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../../app_prefereces/cubit/app_preferences_cubit.dart';

class FinanceRequestDetailsScreen extends StatefulWidget {
  const FinanceRequestDetailsScreen({
    super.key,
    required this.sId,
  });

  final String sId;

  @override
  State<FinanceRequestDetailsScreen> createState() =>
      _FinanceRequestDetailsScreenState();
}

class _FinanceRequestDetailsScreenState
    extends State<FinanceRequestDetailsScreen> with AppBarMixin {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  late String rejectReason;

  @override
  void initState() {
    super.initState();
    printf("sID ==========${widget.sId}");
    context
        .read<FinanceRequestCubit>()
        .getFinanceRequestDetails(context, widget.sId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinanceRequestCubit, FinanceRequestState>(
      listener: buildBlocListener,
      builder: (context, state) {
        final cubit = context.read<FinanceRequestCubit>();
        return Scaffold(
            body: _buildBlocConsumer,
            bottomNavigationBar: UIComponent.customInkWellWidget(
              onTap: () {
                context
                    .pushNamed(Routes.kPropertyDetailScreen, pathParameters: {
                  RouteArguments.propertyId:
                      cubit.financeRequestDetailsData.property?.id ?? "0",
                  RouteArguments.propertyLat: (0.00).toString(),
                  RouteArguments.propertyLng: (0.00).toString(),
                }).then((value) {
                  if (value != null && value == true) {}
                });
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
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              appStrings(context).lblViewProperty,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.colorPrimary),
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
            ).showIf(cubit.financeRequestDetailsData.property?.id != null &&
                cubit.financeRequestDetailsData.property?.id != ""));
      },
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<FinanceRequestCubit, FinanceRequestState>(
      listener: (context, state) {},
      builder: (context, state) {
        FinanceRequestCubit cubit = context.read<FinanceRequestCubit>();

        return Skeletonizer(
            enabled: (cubit.financeRequestDetailsData.id.toString() == "" ||
                state is FinanceRequestListLoading ||
                state is FinanceRequestInitial),
            child: cubit.financeRequestDetailsData.id.toString() == "null" ||
                    cubit.financeRequestDetailsData.id.toString() == "" ||
                    state is PropertyDetailsLoading
                ? Skeletonizer(
                    enabled: true,
                    child: UIComponent.getSkeletonPropertyDetail())
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
                        child: Column(children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 16.0, end: 16.0, top: 16),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cubit.financeRequestDetailsData.property
                                          ?.title ??
                                      "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                                8.verticalSpace,
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0),
                                  child: ReadMoreText(
                                    cubit.financeRequestDetailsData.property
                                            ?.description ??
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
                                ).hideIf((cubit.financeRequestDetailsData
                                            .property?.description ??
                                        "") ==
                                    ""),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CustomDivider.colored(context),
                                ),
                                8.verticalSpace,
                                Text(appStrings(context).lblRequester,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.black3D
                                                .adaptiveColor(context,
                                                    lightModeColor:
                                                        AppColors.black3D,
                                                    darkModeColor:
                                                        AppColors.greyB0))),
                                8.verticalSpace,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            (cubit
                                                            .financeRequestDetailsData
                                                            .visitorData
                                                            ?.profileImage !=
                                                        null &&
                                                    cubit
                                                        .financeRequestDetailsData
                                                        .visitorData!
                                                        .profileImage!
                                                        .startsWith('http'))
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: CachedNetworkImage(
                                                      imageUrl: cubit
                                                              .financeRequestDetailsData
                                                              .visitorData
                                                              ?.profileImage ??
                                                          "",
                                                      width: 36,
                                                      height: 36,
                                                      fit: BoxFit.contain,
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColors
                                                              .colorPrimary,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                        Icons.error,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: AppColors
                                                          .colorSecondary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SVGAssets
                                                        .userLightIcon
                                                        .toSvg(
                                                      context: context,
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                    ),
                                                  ),
                                            8.horizontalSpace,
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.financeRequestDetailsData.visitorData?.firstName} ${cubit.financeRequestDetailsData.visitorData?.lastName}",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                  ),
                                                  3.verticalSpace,
                                                  Text(
                                                    cubit
                                                            .financeRequestDetailsData
                                                            .visitorData
                                                            ?.contactNumber ??
                                                        "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .grey8A
                                                                .forLightMode(
                                                                    context)),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Utils.makePhoneCall(
                                            context: context,
                                            phoneNumber: cubit
                                                    .financeRequestDetailsData
                                                    .visitorData
                                                    ?.contactNumber ??
                                                "0",
                                          );

                                          debugPrint(
                                              'Item 0 (Direct Call) selected');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.greyF8
                                                .adaptiveColor(context,
                                                    lightModeColor:
                                                        AppColors.greyF8,
                                                    darkModeColor:
                                                        AppColors.black14),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppColors.greyE9
                                                  .adaptiveColor(
                                                context,
                                                lightModeColor:
                                                    AppColors.greyE9,
                                                darkModeColor:
                                                    AppColors.black2E,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: SVGAssets.callIcon.toSvg(
                                            context: context,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CustomDivider.colored(context),
                                ),
                                8.verticalSpace,
                                Text(appStrings(context).lblSelectedOffer,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.black3D
                                                .adaptiveColor(context,
                                                    lightModeColor:
                                                        AppColors.black3D,
                                                    darkModeColor:
                                                        AppColors.greyB0))),
                                16.verticalSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.greyF8.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.greyF8,
                                        darkModeColor: AppColors.black2E),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.all(
                                                12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      cubit.financeRequestDetailsData
                                                              .offerId?.title ??
                                                          "",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${cubit.financeRequestDetailsData.offerId?.price?.currencySymbol} ${cubit.financeRequestDetailsData.offerId?.price?.amount}",
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                          color: AppColors
                                                              .black14
                                                              .forLightMode(
                                                                  context),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            8.verticalSpace,
                                            Text(
                                              cubit.financeRequestDetailsData
                                                      .offerId?.description ??
                                                  "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: AppColors.black3D
                                                          .forLightMode(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CustomDivider.colored(context),
                                ),
                                8.verticalSpace,
                                Text(appStrings(context).lblOtherDetails,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.black3D
                                                .adaptiveColor(context,
                                                    lightModeColor:
                                                        AppColors.black3D,
                                                    darkModeColor:
                                                        AppColors.greyB0))),
                                8.verticalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "${appStrings(context).financeType} :",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                    color: AppColors.black3D
                                                        .forLightMode(context),
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                        ),
                                        6.horizontalSpace,
                                        Text(
                                          (cubit.financeRequestDetailsData
                                                      .financeType ==
                                                  "vendor"
                                              ? appStrings(context)
                                                  .vendorFinance
                                              : appStrings(context)
                                                  .propertyFinance),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: AppColors.black14
                                                      .forLightMode(context),
                                                  fontWeight: FontWeight.w400),
                                        ),
                                        // 8.horizontalSpace,
                                      ],
                                    ),
                                    10.verticalSpace,
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "${appStrings(context).txtPaymentMethod} :",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: AppColors.black3D
                                                          .forLightMode(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                          ),
                                          6.horizontalSpace,
                                          Text(
                                            (StringUtils.capitalizeFirstLetter(cubit.financeRequestDetailsData
                                                    .paymentMethod ??
                                                '')),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                    color: AppColors.black14
                                                        .forLightMode(context),
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                          // 8.horizontalSpace,
                                        ],
                                      ),
                                    ).showIf(cubit.financeRequestDetailsData
                                                .paymentMethod !=
                                            null &&
                                        cubit.financeRequestDetailsData
                                            .paymentMethod
                                            .toString()
                                            .isNotEmpty),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SVGAssets.calender1Icon.toSvg(
                                                      context: context,
                                                      color: AppColors.black14
                                                          .adaptiveColor(
                                                              context,
                                                              lightModeColor:
                                                                  AppColors
                                                                      .black14,
                                                              darkModeColor:
                                                                  AppColors
                                                                      .white)),
                                                  6.horizontalSpace,
                                                  Text(
                                                    UIComponent.formatDate(
                                                        cubit.financeRequestDetailsData
                                                                .createdAt ??
                                                            "",
                                                        AppConstants
                                                            .dateFormatDdMMYyyyDash),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .black14
                                                                .forLightMode(
                                                                    context),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                  // 8.horizontalSpace,
                                                ],
                                              ),
                                              // 5.verticalSpace,
                                            ],
                                          ),
                                        ),
                                        20.horizontalSpace,
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SVGAssets.clockRoundIcon.toSvg(
                                                      context: context,
                                                      color: AppColors.black14
                                                          .adaptiveColor(
                                                              context,
                                                              lightModeColor:
                                                                  AppColors
                                                                      .black14,
                                                              darkModeColor:
                                                                  AppColors
                                                                      .white)),
                                                  6.horizontalSpace,
                                                  BlocConsumer<
                                                      AppPreferencesCubit,
                                                      AppPreferencesState>(
                                                    listener:
                                                        (context, state) {},
                                                    builder: (context, state) {
                                                      final cubit = context.watch<
                                                          AppPreferencesCubit>();
                                                      final isArabic = cubit
                                                          .isArabicSelected;
                                                      return Text(
                                                        UIComponent
                                                            .formatDateTimeStr(
                                                          context
                                                                  .read<
                                                                      FinanceRequestCubit>()
                                                                  .financeRequestDetailsData
                                                                  .createdAt ??
                                                              "",
                                                          AppConstants
                                                              .timeFormatHhMmA,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .black14
                                                                    .forLightMode(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ]))));
      },
    );
  }

  Widget _buildImageSlider(FinanceRequestCubit cubit) {
    final thumbnailImg =
        cubit.financeRequestDetailsData.property?.thumbnail ?? "";
    var propertyFiles = <String>[];
    if (thumbnailImg.isNotEmpty) {
      propertyFiles.insert(0, thumbnailImg);
    }
    propertyFiles.addAll(Utils.getAllImageFiles(
        cubit.financeRequestDetailsData.property?.propertyFiles ?? []));

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
          child: buildAppBar(
              context: context,
              requireLeading: true,
              requireShareFavIcon: false,
              isFavourite: false,
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
              notRequireFavIcon: true,
              onFavouriteToggle: (isFavourite) {},
              onShareTap: () {
                // Utils.shareProperty(context, propertyDetails: cubit.myPropertyDetails);
              }),
        ),
      ],
    );
  }

  /// Build bloc listener widget.
  ///
  Future<void> buildBlocListener(
      BuildContext context, FinanceRequestState state) async {
    if (state is FinanceRequestListLoading) {
      // OverlayLoadingProgress.start(context);
    } else if (state is FinanceRequestSuccess) {
      // OverlayLoadingProgress.stop();
    } else if (state is FinanceRequestDetailsError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
