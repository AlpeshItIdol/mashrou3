import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/text_styles.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:mashrou3/utils/string_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentlyVisitedPropertiesListItem extends StatefulWidget {
  final String propertyName;
  final String propertyImg;
  final String propertyImgCount;
  final String? propertyPrice;
  final String propertyPriceCurrency;
  final String propertyLocation;
  final String propertyArea;
  final dynamic propertyRating;
  final bool isFavorite;
  final bool isSoldOut;
  final bool isVisitor;
  final bool isBankProperty;
  final bool requiredFavorite;
  final bool requiredDelete;
  final bool requiredCheckBox;
  final bool isSelected;
  final bool? isLocked;
  final bool? isLockedByMe;
  final dynamic offerData;
  final VoidCallback onPropertyTap;
  final VoidCallback? onDeleteTap;
  final Future<void> Function(bool isAdd)? onFavouriteToggle;
  final Future<void> Function(bool isAdd)? onCheckBoxToggle;

  const RecentlyVisitedPropertiesListItem({
    super.key,
    required this.propertyName,
    required this.propertyImg,
    required this.propertyImgCount,
    required this.propertyPrice,
    required this.propertyPriceCurrency,
    required this.propertyLocation,
    required this.propertyArea,
    required this.propertyRating,
    required this.isSoldOut,
    required this.isVisitor,
    this.isBankProperty = false,
    this.isFavorite = false,
    this.requiredDelete = false,
    this.requiredFavorite = true,
    this.requiredCheckBox = false,
    this.isSelected = false,
    this.isLocked,
    this.isLockedByMe,
    this.offerData,
    required this.onPropertyTap,
    this.onDeleteTap,
    this.onFavouriteToggle,
    this.onCheckBoxToggle,
  });

  @override
  State<RecentlyVisitedPropertiesListItem> createState() =>
      _RecentlyVisitedPropertiesListItemState();
}

class _RecentlyVisitedPropertiesListItemState
    extends State<RecentlyVisitedPropertiesListItem> {
  bool _isFavourite = false;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isFavourite = widget.isFavorite;
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(RecentlyVisitedPropertiesListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      setState(() {
        _isSelected = widget.isSelected;
      });
    }
    if (oldWidget.isFavorite != widget.isFavorite) {
      setState(() {
        _isFavourite = widget.isFavorite;
      });
    }
  }

  Future<void> _toggleSelection() async {
    setState(() {
      _isSelected = !_isSelected;
    });

    if (widget.onCheckBoxToggle != null) {
      await widget.onCheckBoxToggle!(_isSelected);
    }
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
                            imageUrl: widget.propertyImg),
                      )),
                ),
                // Checkbox for selection (when requiredCheckBox is true)
                PositionedDirectional(
                    top: 12,
                    start: 12,
                    child: Skeleton.unite(
                      child: UIComponent.customInkWellWidget(
                        onTap: _toggleSelection,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: UIComponent.svgIconContainer(
                              context: context,
                              clipPath: _isSelected
                                  ? SVGAssets.checkboxEnableIcon
                                  : SVGAssets.checkboxBlackDisableIcon,
                              padding: 12,
                              backgroundColor: AppColors.white,
                              size: const Size(21, 21)),
                        ),
                      ),
                    )).showIf(widget.requiredCheckBox == true),
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
                  child: Builder(
                    builder: (context) {
                      final lockLabelText = StringUtils.getLockLabelText(widget.isLocked, widget.offerData);
                      final lockTooltipText = StringUtils.getLockTooltipText(widget.isLockedByMe);
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Lock label
                          if (lockLabelText != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Tooltip(
                                message: lockTooltipText,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.colorPrimary.adaptiveColor(
                                      context,
                                      lightModeColor: AppColors.colorPrimary,
                                      darkModeColor: AppColors.goldA1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.symmetric(
                                        vertical: 12.0, horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          lockLabelText,
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
                                ),
                              ),
                            ),
                          // Sold Out label
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
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
                            ),
                          ).showIf(
                              widget.isSoldOut == true && widget.isVisitor == true),
                          // Bank Property label
                          Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: 12.0, horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    appStrings(context).btnBankProperty,
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
                          ).showIf(widget.isBankProperty == true),
                        ],
                      );
                    },
                  ),
                ),
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
                    (widget.propertyPrice != null &&
                            widget.propertyPrice != "null" &&
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
                  ).showIf(widget.propertyPrice != null &&
                      widget.propertyPrice != "null" &&
                      widget.propertyPrice!.isNotEmpty),
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
                            iconColor: AppColors.goldA1,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
