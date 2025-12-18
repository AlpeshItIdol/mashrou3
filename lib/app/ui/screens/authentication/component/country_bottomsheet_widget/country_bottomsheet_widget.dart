import 'package:flutter/material.dart';
import 'package:mashrou3/app/model/country_list_model.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_colors.dart';

class CountryListItemWidget extends StatelessWidget {
  final CountryListData country;
  final bool isOnlyTitle;

  const CountryListItemWidget(
      {super.key, required this.country, this.isOnlyTitle = false});

  @override
  Widget build(BuildContext context) {
    return isOnlyTitle
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  country.name ?? "",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.black14.forLightMode(
                            context),
                      ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      country.emoji ?? "",
                      style: const TextStyle(fontSize: 24), // Flag emoji
                    ),
                    12.horizontalSpace,
                    Text(
                      country.name ?? "",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.black14.forLightMode(
                                context), // Applied specific color based on theme mode
                          ),
                    ),
                  ],
                ),
                Text(
                  country.phoneCode ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
  }
}
