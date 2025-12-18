import 'package:flutter/material.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../config/resources/app_assets.dart';
import '../../../config/resources/app_colors.dart';
import '../../../config/resources/text_styles.dart';
import '../../../utils/ui_components.dart';

class CommonButtonWithIcon extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final VoidCallback onTap;
  final bool? isPrefixArrowNeeded;
  final Color? buttonBgColor;
  final Color? buttonTextColor;
  final Color? borderColor;
  final Gradient? gradientColor;
  final bool? isGradientColor;
  final bool isDisabled;

  const CommonButtonWithIcon(
      {super.key,
      this.icon,
      this.title,
      required this.onTap,
      this.isPrefixArrowNeeded,
      this.buttonBgColor,
      this.buttonTextColor,
      this.gradientColor,
      this.borderColor,
      this.isGradientColor = true,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return UIComponent.customInkWellWidget(
      onTap: isDisabled ? null : onTap,
      // Disable onTap when the button is disabled
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            border: isGradientColor!
                ? null
                : Border.all(
                    color: isDisabled
                        ? (buttonBgColor ??
                                AppColors.black14.adaptiveColor(context,
                                    lightModeColor: AppColors.black14,
                                    darkModeColor: AppColors.white))
                            .withOpacity(0.3)
                        : borderColor ??
                            AppColors.black14.adaptiveColor(context,
                                lightModeColor: AppColors.black14,
                                darkModeColor: AppColors.white),
                    width: 1,
                  ),
            color: isDisabled
                ? (buttonBgColor ??
                    AppColors.black14.adaptiveColor(context,
                        lightModeColor: AppColors.black14.withOpacity(0.3),
                        darkModeColor: AppColors.white.withOpacity(0.5))
            )
                : buttonBgColor,
            gradient: isDisabled
                ? null
                : (isGradientColor! ? AppColors.primaryGradient : null),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                vertical: 12.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: isDisabled
                        ? (buttonTextColor ??
                            AppColors.white.adaptiveColor(context,
                                lightModeColor:
                                    AppColors.white.withOpacity(0.3),
                                darkModeColor: AppColors.greyE9)
                    )
                        : buttonTextColor ?? AppColors.white,
                  ),
                  child: icon ??
                      SVGAssets.addIcon.toSvg(
                          context: context,
                          color: isDisabled
                              ? AppColors.grey77.adaptiveColor(context,
                                  lightModeColor: AppColors.grey77,
                                  darkModeColor: AppColors.greyE9)
                              : null),
                ),
                8.horizontalSpace.showIf(title != null && title!.isNotEmpty),
                Flexible(
                  child: Text(
                    title ?? "",
                    textAlign: TextAlign.center,
                    style: h14().copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDisabled
                          ? AppColors.grey77.adaptiveColor(context,
                              lightModeColor: AppColors.grey77,
                              darkModeColor: AppColors.greyE9)
                          : buttonTextColor ?? AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
