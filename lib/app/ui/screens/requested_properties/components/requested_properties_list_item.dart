import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/text_styles.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../config/resources/app_constants.dart';

class RequestedPropertiesListItem extends StatefulWidget {
  final String propertyName;
  final String propertyImg;
  final String propertyImgCount;
  final String propertyPrice;
  final String propertyPriceCurrency;
  final String propertyLocation;
  final String propertyArea;
  final dynamic propertyRating;
  final String reqStatus;
  final String reqStatusText;
  final String respondedDate;
  final bool isFavorite;
  final bool isSoldOut;
  final bool isVisitor;
  final bool requiredFavorite;
  final bool requiredDelete;
  final VoidCallback onPropertyTap;
  final VoidCallback? onDeleteTap;
  final Future<void> Function(bool isAdd)? onFavouriteToggle;

  const RequestedPropertiesListItem({
    super.key,
    required this.propertyName,
    required this.propertyImg,
    required this.propertyImgCount,
    required this.propertyPrice,
    required this.propertyPriceCurrency,
    required this.propertyLocation,
    required this.propertyArea,
    required this.propertyRating,
    required this.reqStatus,
    required this.reqStatusText,
    required this.isSoldOut,
    required this.respondedDate,
    required this.isVisitor,
    this.isFavorite = false,
    this.requiredDelete = false,
    this.requiredFavorite = true,
    required this.onPropertyTap,
    this.onDeleteTap,
    this.onFavouriteToggle,
  });

  @override
  State<RequestedPropertiesListItem> createState() =>
      _RequestedPropertiesListItemState();
}

class _RequestedPropertiesListItemState
    extends State<RequestedPropertiesListItem> {
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _isFavourite = widget.isFavorite;
  }

  Future<void> _toggleFavourite() async {
    setState(() {
      _isFavourite = !_isFavourite;
    });

    try {
      if (widget.onFavouriteToggle != null) {
        await widget.onFavouriteToggle!(_isFavourite);
      }
    } catch (e) {
      setState(() {
        _isFavourite = !_isFavourite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Failed to update favorite status. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: AppColors.white.adaptiveColor(context,
          lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
      child: UIComponent.customInkWellWidget(
        onTap: widget.onPropertyTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Skeleton.leaf(
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: SizedBox(
                        height: 250,
                        child: UIComponent.cachedNetworkImageWidget(
                            imageUrl: widget.propertyImg, isForProperty: true),
                      )),
                ),
                PositionedDirectional(
                    top: 12,
                    end: 12,
                    child: Skeleton.unite(
                      child: UIComponent.customInkWellWidget(
                        onTap: _toggleFavourite,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: UIComponent.svgIconContainer(
                              context: context,
                              clipPath: _isFavourite
                                  ? SVGAssets.favouriteSelectedIcon
                                  : SVGAssets.favouriteIcon,
                              padding: 12,
                              backgroundColor: AppColors.white,
                              size: const Size(21, 21)),
                        ),
                      ),
                    )).showIf(widget.requiredFavorite == true),
                PositionedDirectional(
                    top: 12,
                    end: 12,
                    child: Skeleton.unite(
                      child: UIComponent.customInkWellWidget(
                        onTap: widget.onDeleteTap ?? () {},
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: UIComponent.svgIconContainer(
                              clipPath: SVGAssets.deleteIcon,
                              padding: 12,
                              context: context,
                              backgroundColor: AppColors.white,
                              size: const Size(21, 21)),
                        ),
                      ),
                    )).showIf(widget.requiredDelete == true),
                PositionedDirectional(
                        bottom: 12,
                        start: 12,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.red00,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                vertical: 12.0, horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appStrings(context).soldOut,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .showIf(
                        widget.isSoldOut == true && widget.isVisitor == true),
                PositionedDirectional(
                  bottom: 12,
                  end: 12,
                  child: Skeleton.unite(
                    child: Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            SVGAssets.galleryIcon,
                            width: 16,
                            height: 16,
                          ),
                          6.horizontalSpace,
                          Text(
                            widget.propertyImgCount,
                            style: h12().copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ).hideIf(widget.propertyImgCount == '0'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.propertyName,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor),
                  ),
                  8.verticalSpace,
                  Text(
                    (widget.propertyPrice != "null" &&
                            widget.propertyPrice!.isNotEmpty
                        ? num.tryParse(widget.propertyPrice!)?.formatCurrency(
                                showSymbol: true,
                                currencySymbol: widget.propertyPriceCurrency) ??
                            ""
                        : ""),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.colorPrimary.adaptiveColor(
                            context,
                            lightModeColor: AppColors.colorPrimary,
                            darkModeColor: AppColors.goldA1,
                          ),
                        ),
                  ).showIf(widget.propertyPrice != "null" &&
                      widget.propertyPrice.isNotEmpty),
                  12.verticalSpace,
                  Skeleton.unite(
                      child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      Visibility(
                          visible: widget.propertyLocation.isNotEmpty == true,
                          child: UIComponent.iconRowAndText(
                            context: context,
                            svgPath: SVGAssets.locationIcon,
                            text: widget.propertyLocation,
                            backgroundColor: AppColors.colorBgPrimary
                                .adaptiveColor(context,
                                    lightModeColor: AppColors.colorBgPrimary,
                                    darkModeColor: AppColors.black14),
                            textColor: AppColors.colorPrimary.adaptiveColor(
                                context,
                                lightModeColor: AppColors.colorPrimary,
                                darkModeColor: AppColors.white),
                          )),
                      Visibility(
                          visible: widget.propertyArea.isNotEmpty == true,
                          child: UIComponent.iconRowAndText(
                            context: context,
                            svgPath: SVGAssets.aspectRatioIcon,
                            text: widget.propertyArea,
                            backgroundColor: AppColors.colorBgPrimary
                                .adaptiveColor(context,
                                    lightModeColor: AppColors.colorBgPrimary,
                                    darkModeColor: AppColors.black14),
                            textColor: AppColors.colorSecondary.adaptiveColor(
                                context,
                                lightModeColor: AppColors.colorPrimary,
                                darkModeColor: AppColors.white),
                          )),
                      Visibility(
                          visible: widget.propertyRating.toString() != '0',
                          child: UIComponent.iconRowAndText(
                            svgPath: SVGAssets.starIcon,
                            context: context,
                            text: widget.propertyRating.toString(),
                            backgroundColor: AppColors.colorBgPrimary
                                .adaptiveColor(context,
                                    lightModeColor: AppColors.colorBgPrimary,
                                    darkModeColor: AppColors.black14),
                            textColor: AppColors.colorSecondary.adaptiveColor(
                                context,
                                lightModeColor: AppColors.colorPrimary,
                                darkModeColor: AppColors.white),
                          )),
                    ],
                  )),
                  12.verticalSpace,
                  Skeleton.unite(
                      child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      UIComponent.iconRowAndText(
                        context: context,
                        svgPath: widget.reqStatus.toLowerCase().toString() ==
                                "approved"
                            ? SVGAssets.checkmarkCircleIcon
                            : widget.reqStatus.toLowerCase().toString() ==
                                    "pending"
                                ? SVGAssets.clock4Icon
                                : widget.reqStatus.toLowerCase().toString() ==
                                        "rejected"
                                    ? SVGAssets.cancelCircleIcon
                                    : SVGAssets.locationIcon,
                        text: widget.reqStatusText,
                        backgroundColor: widget.reqStatus
                                    .toLowerCase()
                                    .toString() ==
                                "approved"
                            ? AppColors.colorPrimary
                            : widget.reqStatus.toLowerCase().toString() ==
                                    "rejected"
                                ? AppColors.red33
                                : widget.reqStatus.toLowerCase().toString() ==
                                        "pending"
                                    ? AppColors.goldA1
                                    : AppColors.colorBgPrimary.adaptiveColor(
                                        context,
                                        lightModeColor:
                                            AppColors.colorBgPrimary,
                                        darkModeColor: AppColors.black14),
                        textColor: widget.reqStatus.toLowerCase().toString() ==
                                "approved"
                            ? AppColors.white
                            : widget.reqStatus.toLowerCase().toString() ==
                                    "pending"
                                ? AppColors.white
                                : widget.reqStatus.toLowerCase().toString() ==
                                        "rejected"
                                    ? AppColors.white
                                    : AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white),
                        iconColor: widget.reqStatus.toLowerCase().toString() ==
                                "approved"
                            ? AppColors.white
                            : widget.reqStatus.toLowerCase().toString() ==
                                    "pending"
                                ? AppColors.white
                                : widget.reqStatus.toLowerCase().toString() ==
                                        "rejected"
                                    ? AppColors.white
                                    : AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.white),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                12.verticalSpace,
                Divider(
                  height: 1,
                  color: AppColors.greyE8.adaptiveColor(context,
                      lightModeColor: AppColors.greyE8,
                      darkModeColor: AppColors.grey50),
                ),
                2.verticalSpace,
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.transparent),
                    color: AppColors.greyFA.adaptiveColor(context,
                        lightModeColor: AppColors.greyFA,
                        darkModeColor: AppColors.black14),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SVGAssets.calender1Icon.toSvg(
                                      context: context,
                                      color: AppColors.black14.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.black14,
                                          darkModeColor: AppColors.white)),
                                  6.horizontalSpace,
                                  Text(
                                    UIComponent.formatDate(widget.respondedDate,
                                        AppConstants.dateFormatDdMMYyyyDash),
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
                              // 5.verticalSpace,
                            ],
                          ),
                        ),
                        20.horizontalSpace,
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SVGAssets.clockRoundIcon.toSvg(
                                      context: context,
                                      color: AppColors.black14.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.black14,
                                          darkModeColor: AppColors.white)),
                                  6.horizontalSpace,
                                  Text(
                                    UIComponent.formatDate(widget.respondedDate,
                                            AppConstants.timeFormatHhMmA) ??
                                        "-",
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
