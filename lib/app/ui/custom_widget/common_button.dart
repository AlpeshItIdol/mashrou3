import 'package:flutter/material.dart';

import 'package:mashrou3/utils/extensions.dart';

import '../../../config/resources/app_colors.dart';
import '../../../config/resources/text_styles.dart';
import '../../../utils/ui_components.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool? isSuffixArrowNeeded;
  final String? prefixIcon;
  final String? suffixIcon;
  final double width;
  final double? height;
  final double verticalPadding;
  final double horizontalPadding;
  final Color? buttonBgColor;
  final Color? buttonTextColor;
  final Color? borderColor;
  final Gradient? gradientColor;
  final bool? isGradientColor;
  final bool isBorderRequired;
  final bool enabled;
  final bool isDynamicWidth;
  final double cornerValue;

  const CommonButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.prefixIcon,
      this.isSuffixArrowNeeded,
      this.verticalPadding = 8.0,
      this.horizontalPadding = 0.0,
      this.width = double.infinity,
      this.height,
      this.suffixIcon,
      this.enabled = true,
      this.isBorderRequired = false,
      this.buttonBgColor,
      this.borderColor,
      this.buttonTextColor,
      this.gradientColor,
      this.isDynamicWidth = false,
      this.isGradientColor = true,
      this.cornerValue = 16,
      });

  @override
  Widget build(BuildContext context) {
    return UIComponent.customInkWellWidget(
      onTap: enabled ? onTap : null,
      child: isDynamicWidth
          ? IntrinsicWidth(
              child: Container(
                padding: const EdgeInsetsDirectional.all(4),
                width: width /*AppValues.screenHeight * 0.2*/,
                height: height,
                decoration: BoxDecoration(
                    border: isBorderRequired
                        ? Border.all(
                            color: borderColor ?? AppColors.black14, width: 1)
                        : null,
                    color: !enabled ? AppColors.grey77 : buttonBgColor,
                    gradient: isGradientColor!
                        ? (enabled ? AppColors.primaryGradient : null)
                        : null,
                    borderRadius: BorderRadius.circular(cornerValue)),
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                      vertical: verticalPadding, horizontal: horizontalPadding),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 10),
                          child: prefixIcon.toSvg(context: context),
                        ).showIf(prefixIcon != null),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: h16().copyWith(
                              fontWeight: FontWeight.w600,
                              color: buttonTextColor ?? AppColors.white),
                        ),
                        10.horizontalSpace.showIf(isSuffixArrowNeeded ?? false),
                        UIComponent.customRTLIcon(
                          child: suffixIcon
                              .toSvg(context: context)
                              .showIf(isSuffixArrowNeeded ?? false), context: context,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsetsDirectional.all(4),
              width: width /*AppValues.screenHeight * 0.2*/,
              height: height,
              decoration: BoxDecoration(
                  border: isBorderRequired
                      ? Border.all(
                          color: borderColor ?? AppColors.black14, width: 1)
                      : null,
                  color: !enabled ? AppColors.grey77 : buttonBgColor,
                  gradient: isGradientColor!
                      ? (enabled ? AppColors.primaryGradient : null)
                      : null,
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding:
                    EdgeInsetsDirectional.symmetric(vertical: verticalPadding),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10),
                        child: prefixIcon.toSvg(context: context),
                      ).showIf(prefixIcon != null),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: h16().copyWith(
                            fontWeight: FontWeight.w600,
                            color: buttonTextColor ?? AppColors.white),
                      ),
                      10.horizontalSpace.showIf(isSuffixArrowNeeded ?? false),
                      suffixIcon
                          .toSvg(context: context)
                          .showIf(isSuffixArrowNeeded ?? false)
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
