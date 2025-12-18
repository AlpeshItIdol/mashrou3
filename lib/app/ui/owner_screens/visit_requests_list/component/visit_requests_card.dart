import 'package:flutter/material.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../../../../../config/resources/app_assets.dart';
import '../../../../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../../../../utils/ui_components.dart';
import '../../../../../config/resources/app_constants.dart';
import '../../../custom_widget/common_button.dart';
import '../../../custom_widget/common_row_bottons.dart';

class VisitRequestsCard extends StatelessWidget {
  final String? name;
  final String? propertyName;
  final String? date;
  final String? time;
  final String? note;
  final String? reqDenyReason;
  final String? btnText;
  final bool isResponded;
  final VoidCallback? onTapReject;
  final VoidCallback? onTapApprove;

  const VisitRequestsCard({
    super.key,
    this.name,
    this.propertyName,
    this.date,
    this.time,
    this.note,
    this.reqDenyReason,
    this.btnText,
    this.isResponded = false,
    this.onTapReject,
    this.onTapApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyF8.adaptiveColor(context,
            lightModeColor: AppColors.greyF8, darkModeColor: AppColors.black2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimary.withOpacity(0.10),
                        borderRadius:
                            BorderRadius.circular(4), // Rounded container
                      ),
                      child: SVGAssets.realEstateIcon.toSvg(
                        context: context,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                    12.horizontalSpace,
                    Text(
                      propertyName ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).highlightColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(vertical: 16.0),
                  child: Divider(
                    height: 1,
                    color: AppColors.greyE8.adaptiveColor(context,
                        lightModeColor: AppColors.greyE8,
                        darkModeColor: AppColors.grey50),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              SVGAssets.personNotFilledIcon.toSvg(
                                  context: context,
                                  color: AppColors.black14.adaptiveColor(
                                      context,
                                      lightModeColor: AppColors.black14,
                                      darkModeColor: AppColors.white)),
                              6.horizontalSpace,
                              Flexible(
                                child: Text(
                                  "${appStrings(context).lblVisitorName} :",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          color: AppColors.black3D
                                              .forLightMode(context),
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                              6.horizontalSpace,
                              Text(
                                name ?? "-",
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
                  ],
                ),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                UIComponent.formatDate(date ?? "",
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
                                UIComponent.formatTimeStr(time ?? "",
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
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${appStrings(context).lblNote} :",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.black3D.forLightMode(context),
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: Text(
                        note ?? "-",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.black14.forLightMode(context),
                              fontWeight: FontWeight.w400,
                            ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ).hideIf(note == null || note == ""),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${appStrings(context).rejectedReason} :",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.red00,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      6.horizontalSpace,
                      Expanded(
                        child: Text(
                          reqDenyReason ?? "-",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.black14.forLightMode(context),
                                fontWeight: FontWeight.w400,
                              ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  )
                      ,
                ).hideIf(reqDenyReason == null || reqDenyReason == "")
                    .showIf(btnText?.toLowerCase().toString() != "approved"),
                8.verticalSpace,
              ],
            ),
          ),
          ButtonRow(
            leftButtonText: appStrings(context).btnReject,
            rightButtonText: appStrings(context).btnApprove,
            onLeftButtonTap: onTapReject ?? () {},
            onRightButtonTap: onTapApprove ?? () {},
            leftButtonBgColor: Theme.of(context).cardColor,
            leftButtonBorderColor: Theme.of(context).primaryColor,
            leftButtonTextColor: Theme.of(context).primaryColor,
            isLeftButtonGradient: false,
            isLeftButtonBorderRequired: true,
            spaceBetween: 10,
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
          ).showIf(!isResponded),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 12.0, end: 12.0, bottom: 12.0),
            child: CommonButton(
              onTap: () {},
              buttonBgColor: btnText?.toLowerCase().toString() == "approved"
                  ? AppColors.grey8A
                  : AppColors.red33,
              isGradientColor: false,
              title: btnText?.toLowerCase().toString() == "approved"
                  ? appStrings(context).btnApproved
                  : appStrings(context).btnRejected,
            ).showIf(isResponded),
          ),
        ],
      ),
    )
        /*  ,
    )*/
        ;
  }
}
