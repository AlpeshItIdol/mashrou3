import 'package:flutter/material.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

class CustomRatingBar extends StatelessWidget {
  final int totalStars;
  final Function(int) onRatingUpdated;
  final int value;

  const CustomRatingBar(
      {super.key,
      required this.totalStars,
      required this.onRatingUpdated,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        final rating = index + 1;

        if (rating <= value) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: UIComponent.customInkWellWidget(
              onTap: () {
                onRatingUpdated(rating); // Call the callback function
              },
              child: SVGAssets.starFilledIcon.toSvg(context: context),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: UIComponent.customInkWellWidget(
              onTap: () {
                onRatingUpdated(rating); // Call the callback function
              },
              child: SVGAssets.starOutlinedIcon.toSvg(context: context),
            ),
          );
        }
      }),
    );
  }
}
