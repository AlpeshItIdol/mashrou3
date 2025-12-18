import 'package:flutter/material.dart';
import 'package:mashrou3/app/ui/custom_widget/common_button.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../../../utils/ui_components.dart';
import '../../../../../../../../model/offers/my_offers_list_response_model.dart';

class OfferListItem extends StatelessWidget {
  final OfferData offerData;
  final String companyLogo;

  final Function() onTap;

  const OfferListItem(
      {required this.offerData,
      required this.onTap,
      super.key,
      required this.companyLogo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: AppColors.white.adaptiveColor(context,
          lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
      child: UIComponent.customInkWellWidget(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton.leaf(
              child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 200,
                    child: UIComponent.cachedNetworkImageWidget(
                        imageUrl: (offerData.documents ?? []).isNotEmpty
                            ? offerData.documents?.first ?? ""
                            : companyLogo ?? ""),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offerData.title ?? "",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.colorSecondary),
                    ),
                    8.verticalSpace,
                    Text(
                      offerData.description ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.black3D,
                          ),
                    ),
                  ]),
            ),
            Divider(
                height: 1,
                color: AppColors.greyE9.adaptiveColor(context,
                    lightModeColor: AppColors.greyE9,
                    darkModeColor: AppColors.black2E)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CommonButton(
                horizontalPadding: 12,
                isDynamicWidth: true,
                onTap: () {},
                buttonBgColor: Theme.of(context).primaryColor,
                title: (() {
                  // Get the price amount as a string
                  final amountString = offerData.price?.amount?.toString();

                  if (amountString == null || amountString.isEmpty) {
                    return "";
                  }

                  try {
                    final amount = num.parse(amountString);
                    return amount.formatCurrency(
                      showSymbol: true,
                      currencySymbol: offerData.price?.currencySymbol ?? "",
                    );
                  } catch (e) {
                    return "Invalid Price"; // Return a fallback value
                  }
                })(),
                isBorderRequired: false,
                isGradientColor: false,
              ).hideIf(offerData.price == null ||
                  offerData.price?.amount == null ||
                  offerData.price?.amount == ""),
            ),
          ],
        ),
      ),
    );
  }
}
