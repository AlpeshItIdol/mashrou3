import 'package:flutter/material.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../config/resources/app_colors.dart';
import '../../../config/resources/text_styles.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      required this.onNegativePressed,
      required this.onPositivePressed,
      required this.titleMsg,
      required this.onNegativeButtonText,
      required this.onPositiveButtonText,
      this.positiveButtonTextStyle});

  final Function onNegativePressed;
  final Function onPositivePressed;
  final String titleMsg;
  final String onNegativeButtonText;
  final String onPositiveButtonText;
  final TextStyle? positiveButtonTextStyle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 20.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              18.verticalSpace,
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    titleMsg,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => onNegativePressed(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        backgroundColor: AppColors.colorPrimary.forLightMode(
                            context), // Replace with your cancel button color from image (e.g., Color(0xFF...)),
                      ),
                      child: Text(
                        onNegativeButtonText,
                        style: h14().copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  20.horizontalSpace,
                  Expanded(
                    child: TextButton(
                      onPressed: () => onPositivePressed(),
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          backgroundColor: AppColors.colorLightPrimary
                              .forLightMode(context)),
                      child: Text(
                        onPositiveButtonText,
                        style: positiveButtonTextStyle ??
                            h14().copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
