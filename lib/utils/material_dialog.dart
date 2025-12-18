import 'package:flutter/material.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../config/resources/app_colors.dart';

class MaterialAlertDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? negativeButtonText;
  final String positiveButtonText;
  final VoidCallback? onPositiveTap;
  final VoidCallback? onNegativeTap;
  final bool dismissible;

  const MaterialAlertDialog({
    Key? key,
    required this.title,
    required this.positiveButtonText,
    this.subtitle,
    this.dismissible = true,
    this.negativeButtonText,
    this.onPositiveTap,
    this.onNegativeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => dismissible,
      child: AlertDialog(
        backgroundColor: AppColors.white.adaptiveColor(context,
            lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
        title: Text(title),
        content: subtitle != null ? Text(subtitle!) : null,
        actions: [
          if (negativeButtonText != null)
            TextButton(
              onPressed: onNegativeTap ?? () => Navigator.of(context).pop(),
              child: Text(
                negativeButtonText!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.colorPrimary.adaptiveColor(context,
                        lightModeColor: AppColors.colorPrimary,
                        darkModeColor: AppColors.white)),
              ),
            ),
          TextButton(
            onPressed: onPositiveTap ?? () => Navigator.of(context).pop(),
            child: Text(positiveButtonText,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.colorPrimary.adaptiveColor(context,
                      lightModeColor: AppColors.colorPrimary,
                      darkModeColor: AppColors.white)),),
          ),
        ],
      ),
    );
  }
}
