import 'package:flutter/material.dart';
import 'package:mashrou3/app/ui/custom_widget/common_button.dart';

import '../../../config/utils.dart';

class ButtonRow extends StatelessWidget {
  final String leftButtonText;
  final String rightButtonText;
  final double spaceBetween;
  final VoidCallback onLeftButtonTap;
  final VoidCallback onRightButtonTap;
  final Color leftButtonBgColor;
  final Color? rightButtonBgColor;
  final Color leftButtonBorderColor;
  final Color? rightButtonBorderColor;
  final Color leftButtonTextColor;
  final Color? rightButtonTextColor;
  final Gradient? rightButtonGradientColor;
  final bool isLeftButtonGradient;
  final bool? isRightButtonGradient;
  final bool isLeftButtonBorderRequired;
  final bool? isRightButtonBorderRequired;
  final EdgeInsetsGeometry? padding;

  const ButtonRow({
    super.key,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftButtonTap,
    required this.onRightButtonTap,
    this.spaceBetween = 18,
    this.leftButtonBgColor = Colors.white,
    this.leftButtonBorderColor = Colors.black,
    this.leftButtonTextColor = Colors.black,
    this.isLeftButtonGradient = false,
    this.isLeftButtonBorderRequired = false,
    this.padding,
    this.rightButtonBgColor,
    this.rightButtonBorderColor,
    this.rightButtonTextColor,
    this.rightButtonGradientColor,
    this.isRightButtonGradient = true,
    this.isRightButtonBorderRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 22),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CommonButton(
              onTap: onLeftButtonTap,
              height: 48,
              isGradientColor: isLeftButtonGradient,
              isBorderRequired: isLeftButtonBorderRequired,
              buttonBgColor: leftButtonBgColor,
              borderColor: leftButtonBorderColor,
              buttonTextColor: leftButtonTextColor,
              title: leftButtonText,
            ),
          ),
           SizedBox(width: spaceBetween ),
          Expanded(
            child: CommonButton(
              gradientColor: rightButtonGradientColor,
              onTap: onRightButtonTap,
              height: 48,
              title: rightButtonText,
              buttonTextColor: rightButtonTextColor,
              borderColor: rightButtonBorderColor,
              buttonBgColor: rightButtonBgColor,
              isBorderRequired: isRightButtonBorderRequired ?? false,
              isGradientColor: isRightButtonGradient ?? false,
            ),
          ),
        ],
      ),
    );
  }
}
