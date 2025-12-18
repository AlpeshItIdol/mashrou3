import 'package:flutter/material.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../utils/app_localization.dart';
import '../../../../../../../utils/ui_components.dart';
import '../../../../../../model/offers/my_offers_list_response_model.dart';

class VendorMyOfferCard extends StatelessWidget {
  final OfferData offerData;
  final String companyLogo;
  final int index;
  final String? reqStatusText;
  final String? reqStatus;
  Function() onTap;
  Function(String offerId) onEditTap;
  Function(int index, String offerId) onDeleteTap;

  VendorMyOfferCard(
      {required this.offerData,
      required this.onEditTap,
      required this.onDeleteTap,
      required this.onTap,
      required this.index,
      this.reqStatusText,
      this.reqStatus,
      super.key,
      required this.companyLogo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: AppColors.white.adaptiveColor(context,
          lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
      child: UIComponent.customInkWellWidget(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton.leaf(
              child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 200,
                    child: UIComponent.cachedNetworkImageWidget(
                        imageUrl: (offerData.documents ?? []).isNotEmpty
                            ? Utils.getLatestPropertyImage(offerData.documents ?? [],"")
                            : companyLogo),
                  )),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                12.0,
                0.0,
                0.0,
                12.0,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(top: 12.0),
                            child: Text(
                              offerData.title ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.colorSecondary),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => showVendorListOptions(context: context),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              12.0,
                              12.0,
                              12.0,
                              0.0,
                            ),
                            child: SVGAssets.moreOptionIcon.toSvg(
                                context: context,
                                color: AppColors.black14.adaptiveColor(context,
                                    lightModeColor: AppColors.black14,
                                    darkModeColor: AppColors.white)),
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    Text(
                      offerData.description ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey8A,
                          ),
                    ),
                  ]),
            ),
            Divider(
                height: 1,
                color: AppColors.greyE9.adaptiveColor(context,
                    lightModeColor: AppColors.greyE9,
                    darkModeColor: AppColors.black2E)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${offerData.price?.currencySymbol} ${offerData.price?.amount ?? "-"}",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.colorSecondary),
                  ),
                  const SizedBox(
                    width: 1,
                    height: 1,
                  ).showIf(reqStatus?.isNotEmpty == false),
                  Visibility(
                    visible: reqStatus?.isNotEmpty == true &&
                        reqStatus == "rejected",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeleton.unite(
                            child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            UIComponent.iconRowAndText(
                              context: context,
                              svgPath: reqStatus?.toLowerCase().toString() ==
                                      "approved"
                                  ? SVGAssets.checkmarkCircleIcon
                                  : reqStatus?.toLowerCase().toString() ==
                                          "pending"
                                      ? SVGAssets.clock4Icon
                                      : reqStatus?.toLowerCase().toString() ==
                                              "rejected"
                                          ? SVGAssets.cancelCircleIcon
                                          : SVGAssets.placeholder,
                              text: reqStatusText ?? "",
                              backgroundColor: reqStatus
                                          ?.toLowerCase()
                                          .toString() ==
                                      "approved"
                                  ? AppColors.colorPrimary
                                  : reqStatus?.toLowerCase().toString() ==
                                          "rejected"
                                      ? AppColors.red33
                                      : reqStatus?.toLowerCase().toString() ==
                                              "pending"
                                          ? AppColors.goldA1
                                          : AppColors.colorBgPrimary
                                              .adaptiveColor(
                                                  context,
                                                  lightModeColor:
                                                      AppColors.colorBgPrimary,
                                                  darkModeColor:
                                                      AppColors.black14),
                              textColor: reqStatus?.toLowerCase().toString() ==
                                      "approved"
                                  ? AppColors.white
                                  : reqStatus?.toLowerCase().toString() ==
                                          "pending"
                                      ? AppColors.white
                                      : reqStatus?.toLowerCase().toString() ==
                                              "rejected"
                                          ? AppColors.white
                                          : AppColors.colorPrimary
                                              .adaptiveColor(context,
                                                  lightModeColor:
                                                      AppColors.colorPrimary,
                                                  darkModeColor:
                                                      AppColors.white),
                              iconColor: reqStatus?.toLowerCase().toString() ==
                                      "approved"
                                  ? AppColors.white
                                  : reqStatus?.toLowerCase().toString() ==
                                          "pending"
                                      ? AppColors.white
                                      : reqStatus?.toLowerCase().toString() ==
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showVendorListOptions({required BuildContext context}) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        TextDirection.rtl == Directionality.of(context)
            ? 30
            : MediaQuery.of(context).size.width - offset.dx - 20,
        offset.dy + 250,
        TextDirection.rtl == Directionality.of(context)
            ? MediaQuery.of(context).size.width - offset.dx - 20
            : 30,
        0,
      ),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      menuPadding: const EdgeInsets.symmetric(vertical: 0.0),
      items: [
        // First Menu Item
        PopupMenuItem<String>(
            value: 'editVendor',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SVGAssets.editIcon.toSvg(
                                context: context,
                                color: AppColors.colorPrimary.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.colorPrimary,
                                    darkModeColor: AppColors.white)),
                            6.horizontalSpace,
                            Text(
                              appStrings(context).lblEdit,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.colorPrimary
                                          .adaptiveColor(context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white)),
                            ),
                            30.horizontalSpace
                          ],
                        ),
                        TextDirection.rtl == Directionality.of(context)
                            ? SVGAssets.arrowLeftIcon.toSvg(
                                context: context,
                                color: AppColors.colorPrimary.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.colorPrimary,
                                    darkModeColor: AppColors.white))
                            : SVGAssets.arrowRightIcon.toSvg(
                                context: context,
                                color: AppColors.colorPrimary.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.colorPrimary,
                                    darkModeColor: AppColors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        // Divider
        PopupMenuItem<String>(
          enabled: false, // Disable interactions for the divider
          padding: EdgeInsets.zero,
          height: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            // Adjust the padding value as required
            child: Divider(
              color: AppColors.greyE8.adaptiveColor(context,
                  lightModeColor: AppColors.greyE8,
                  darkModeColor: AppColors.black2E),
              // Customize the divider color
              thickness: 1.0, // Adjust thickness if required
            ),
          ),
        ),

        // Second Menu Item
        PopupMenuItem<String>(
            value: 'deleteVendor',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SVGAssets.deleteIcon.toSvg(
                                context: context,
                                color: AppColors.colorPrimary.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.colorPrimary,
                                    darkModeColor: AppColors.white)),
                            6.horizontalSpace,
                            Text(
                              appStrings(context).lblDelete,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.colorPrimary
                                          .adaptiveColor(context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white)),
                            ),
                            30.horizontalSpace
                          ],
                        ),
                        TextDirection.rtl == Directionality.of(context)
                            ? SVGAssets.arrowLeftIcon.toSvg(
                                context: context,
                                color: AppColors.colorPrimary.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.colorPrimary,
                                    darkModeColor: AppColors.white))
                            : SVGAssets.arrowRightIcon.toSvg(
                                context: context,
                                color: AppColors.colorPrimary.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.colorPrimary,
                                    darkModeColor: AppColors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'editVendor') {
        onEditTap(offerData.sId ?? "");
      } else if (value == 'deleteVendor') {
        onDeleteTap(index, offerData.sId ?? "");
      }
    });
  }
}
