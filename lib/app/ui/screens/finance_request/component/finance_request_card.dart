import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/ui/custom_widget/common_button.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/cubit/app_preferences_cubit.dart';
import 'package:mashrou3/app/ui/screens/finance_request/model/finance_request_list_response.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

class FinanceRequestCard extends StatelessWidget {
  final FinanceRequest data;
  final VoidCallback? onDetailTap;

  const FinanceRequestCard({super.key, required this.data, this.onDetailTap});

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
                  // crossAxisAlignment: CrossAxisAlignment.start,
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
                    Flexible(
                      child: Text(
                        data.propertyId?.title ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Theme.of(context).highlightColor,
                                fontWeight: FontWeight.w700),
                      ),
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
                                    color:
                                        AppColors.black3D.forLightMode(context),
                                    fontWeight: FontWeight.w400),
                          ),
                        ),
                        6.horizontalSpace,
                        Text(
                          (data.financeType == "vendor"
                              ? appStrings(context).vendorFinance
                              : appStrings(context).propertyFinance),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color:
                                      AppColors.black14.forLightMode(context),
                                  fontWeight: FontWeight.w400),
                        ),
                        // 8.horizontalSpace,
                      ],
                    ),
                    10.verticalSpace,
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
                                    UIComponent.formatDate(data.createdAt ?? "",
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
                                  BlocConsumer<AppPreferencesCubit,
                                      AppPreferencesState>(
                                    listener: (context, state) {},
                                    builder: (context, state) {
                                      final cubit =
                                          context.watch<AppPreferencesCubit>();
                                      final isArabic = cubit.isArabicSelected;
                                      return Text(
                                        UIComponent.formatDateTimeStr(
                                            data.createdAt ?? "",
                                            AppConstants.timeFormatHhMmA,),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                color: AppColors.black14
                                                    .forLightMode(context),
                                                fontWeight: FontWeight.w400),
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
                20.verticalSpace,
                CommonButton(
                  onTap: onDetailTap ?? () {},
                  horizontalPadding: 12,
                  isDynamicWidth: true,
                  isGradientColor: true,
                  cornerValue: 12,
                  suffixIcon: SVGAssets.arrowRightWhiteIcon,
                  title: appStrings(context).viewDetails,
                  isSuffixArrowNeeded: true,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
