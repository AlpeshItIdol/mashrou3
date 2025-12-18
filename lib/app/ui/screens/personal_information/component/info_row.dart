import 'package:flutter/material.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../config/resources/app_colors.dart';
import '../../../../../config/utils.dart';
import '../../../../../utils/ui_components.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black5E.forLightMode(context),
                  fontWeight: FontWeight.w500,
                ),
          ),
          6.horizontalSpace,
          Expanded(
            child: (value.isNotEmpty &&
                    (value.contains('www') || value.contains('http')))
                ? UIComponent.customInkWellWidget(
                    onTap: () async {
                      await Utils.launchURL(url: value);
                    },
                    child: Text(
                      value.isNotEmpty ? value : "-",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  )
                : Text(
                    value.isNotEmpty ? value : "-",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.black14.forLightMode(context),
                          fontWeight: FontWeight.w400,
                        ),
                  ),
          ),
        ],
      ),
    );
  }
}
