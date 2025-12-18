import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/resources/text_styles.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../cubit/home_cubit.dart';

class PropertyListItem extends StatefulWidget {
  final String propertyName;
  final String propertyImg;
  final String propertyImgCount;
  final String? propertyPrice;
  final String propertyPriceCurrency;
  final String propertyLocation;
  final String propertyArea;
  final dynamic propertyRating;
  final bool isFavorite;
  final bool isSelected;
  final bool isBankProperty;
  final bool isVendor;
  final bool isVisitor;
  final bool isSoldOut;
  final bool requiredFavorite;
  final bool requiredCheckBox;
  final bool requiredDelete;
  final String? createdAt;
  final String? reqStatus;
  final String? reqStatusText;
  final VoidCallback onPropertyTap;
  final VoidCallback? onDeleteTap;
  final Future<void> Function(bool isAdd)? onFavouriteToggle;
  final Future<void> Function(bool isAdd)? onCheckBoxToggle;

  const PropertyListItem({
    super.key,
    required this.propertyName,
    required this.propertyImg,
    required this.propertyImgCount,
    required this.propertyPrice,
    required this.propertyPriceCurrency,
    required this.propertyLocation,
    required this.propertyArea,
    required this.propertyRating,
    required this.isVisitor,
    required this.isSoldOut,
    this.createdAt,
    this.reqStatus,
    this.reqStatusText,
    this.isFavorite = false,
    this.isSelected = false,
    this.isBankProperty = false,
    this.requiredDelete = false,
    this.requiredCheckBox = false,
    this.isVendor = false,
    this.requiredFavorite = true,
    required this.onPropertyTap,
    this.onDeleteTap,
    this.onFavouriteToggle,
    this.onCheckBoxToggle,
  });

  @override
  State<PropertyListItem> createState() => _PropertyListItemState();
}

class _PropertyListItemState extends State<PropertyListItem> {
  bool _isFavourite = false;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    printf("requiredcheckbox-----${widget.requiredCheckBox}");
    _isFavourite = widget.isFavorite;
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(PropertyListItem oldWidget) {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to update favorite status. Please try again.'),
          ),
        );
      }
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
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                UIComponent.cachedNetworkImageWidget(
                                    imageUrl: widget.propertyImg,
                                    isForProperty: true,
                                    onTap: widget.onPropertyTap),
                                PositionedDirectional(
                                    top: 12,
                                    end: 12,
                                    child: Skeleton.unite(
                                      child: UIComponent.customInkWellWidget(
                                        onTap: _toggleFavourite,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            border: Border.all(
                                              color: AppColors.greyE9
                                                  .adaptiveColor(
                                                context,
                                                lightModeColor:
                                                    AppColors.greyE9,
                                                darkModeColor:
                                                    AppColors.black3D,
                                              ),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: UIComponent.svgIconContainer(
                                              context: context,
                                              clipPath: _isFavourite
                                                  ? SVGAssets
                                                      .favouriteSelectedIcon
                                                  : SVGAssets.favouriteIcon,
                                              padding: 12,
                                              applyColorFilter: true,
                                              backgroundColor:
                                                  Theme.of(context).cardColor,
                                              size: const Size(21, 21)),
                                        ),
                                      ),
                                    )).showIf(widget.requiredFavorite == true),
                              ],
                            ),
                            if (_isSelected) // Show overlay if selected
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                          ],
                        ),
                      )),
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return PositionedDirectional(
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
                                    ? SVGAssets.checkboxWhiteWithRightIcon
                                    : SVGAssets.checkboxWhiteWithoutRightIcon,
                                padding: 12,
                                backgroundColor: AppColors.colorPrimary,
                                radius: 80,
                                size: const Size(21, 21)),
                          ),
                        ),
                      ),
                    ).showIf(
                        context.read<HomeCubit>().isBtnSelectPropertiesTapped ==
                            true && widget.isVendor);
                  },
                ),
                PositionedDirectional(
                  bottom: 12,
                  start: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  ),
                ),
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
                  Visibility(
                      visible: widget.propertyLocation.isNotEmpty == true ||
                          widget.propertyArea.isNotEmpty == true ||
                          widget.propertyRating != '0',
                      child: 12.verticalSpace),
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
                  Visibility(
                    visible: widget.reqStatus?.isNotEmpty == true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.verticalSpace,
                        Skeleton.unite(
                            child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            UIComponent.iconRowAndText(
                              context: context,
                              svgPath: widget.reqStatus
                                          ?.toLowerCase()
                                          .toString() ==
                                      "approved"
                                  ? SVGAssets.checkmarkCircleIcon
                                  : widget.reqStatus
                                              ?.toLowerCase()
                                              .toString() ==
                                          "pending"
                                      ? SVGAssets.clock4Icon
                                      : widget.reqStatus
                                                  ?.toLowerCase()
                                                  .toString() ==
                                              "rejected"
                                          ? SVGAssets.cancelCircleIcon
                                          : SVGAssets.placeholder,
                              text: widget.reqStatusText ?? "",
                              backgroundColor: widget.reqStatus
                                          ?.toLowerCase()
                                          .toString() ==
                                      "approved"
                                  ? AppColors.colorPrimary
                                  : widget.reqStatus
                                              ?.toLowerCase()
                                              .toString() ==
                                          "rejected"
                                      ? AppColors.red33
                                      : widget.reqStatus
                                                  ?.toLowerCase()
                                                  .toString() ==
                                              "pending"
                                          ? AppColors.goldA1
                                          : AppColors.colorBgPrimary
                                              .adaptiveColor(context,
                                                  lightModeColor:
                                                      AppColors.colorBgPrimary,
                                                  darkModeColor:
                                                      AppColors.black14),
                              textColor: widget.reqStatus
                                          ?.toLowerCase()
                                          .toString() ==
                                      "approved"
                                  ? AppColors.white
                                  : widget.reqStatus
                                              ?.toLowerCase()
                                              .toString() ==
                                          "pending"
                                      ? AppColors.white
                                      : widget.reqStatus
                                                  ?.toLowerCase()
                                                  .toString() ==
                                              "rejected"
                                          ? AppColors.white
                                          : AppColors.colorPrimary
                                              .adaptiveColor(context,
                                                  lightModeColor:
                                                      AppColors.colorPrimary,
                                                  darkModeColor:
                                                      AppColors.white),
                              iconColor: widget.reqStatus
                                          ?.toLowerCase()
                                          .toString() ==
                                      "approved"
                                  ? AppColors.white
                                  : widget.reqStatus
                                              ?.toLowerCase()
                                              .toString() ==
                                          "pending"
                                      ? AppColors.white
                                      : widget.reqStatus
                                                  ?.toLowerCase()
                                                  .toString() ==
                                              "rejected"
                                          ? AppColors.white
                                          : AppColors.colorPrimary
                                              .adaptiveColor(context,
                                                  lightModeColor:
                                                      AppColors.colorPrimary,
                                                  darkModeColor:
                                                      AppColors.white),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      12.verticalSpace,
                      Divider(
                        height: 1,
                        color: AppColors.greyE8.adaptiveColor(context,
                            lightModeColor: AppColors.greyE8,
                            darkModeColor: AppColors.grey50),
                      ),
                      12.verticalSpace,
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
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            "${appStrings(context).addedOn} ${UIComponent.formatDate(widget.createdAt ?? DateTime.now().toString(), AppConstants.dateFormatDdMMYyyyDash)}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color:
                                        AppColors.black14.forLightMode(context),
                                    fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ).hideIf(widget.createdAt == null)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
