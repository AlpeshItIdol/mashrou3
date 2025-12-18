import 'package:flutter/material.dart';
import 'package:mashrou3/app/model/country_list_model.dart';
import 'package:mashrou3/app/model/property/currency_list_response_model.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../config/resources/app_colors.dart';

class CurrencyListWidget extends StatelessWidget {
  final CurrencyListData currency;

  const CurrencyListWidget(
      {super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      currency.currencyName ?? "",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.black14.forLightMode(
                                context), // Applied specific color based on theme mode
                          ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 18.0),
                  child: Text(
                    currency.currencySymbol ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          );
  }
}
