import 'package:flutter/material.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../../../../../config/resources/app_assets.dart';
import '../../../../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../../../../utils/ui_components.dart';

class MyOffersListCard extends StatelessWidget {
  final String? name;
  final String? description;
  final String? country;
  final String? city;
  final String? imageUrl;
  final VoidCallback? onTap;
  const MyOffersListCard({
    super.key,
    this.name,
    this.description,
    this.country,
    this.city,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return UIComponent.customInkWellWidget(
      onTap: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.greyE9.adaptiveColor(
              context,
              lightModeColor: AppColors.greyE9,
              darkModeColor: AppColors.black2E,
            ),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.greyE9.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.greyE9,
                                        darkModeColor: AppColors.black2E,
                                      ),
                                      width: 1,
                                    ), // Round
                                    // color: AppColors.colorPrimary
                                    //     .withOpacity(0.10),
                                    // borderRadius: BorderRadius.circular(
                                    //     4), // Rounded container
                                  ),
                                  child: UIComponent.cachedNetworkImageWidget(
                                      imageUrl: imageUrl),
                                ),
                              ],
                            ),
                            // 5.verticalSpace,
                          ],
                        ),
                      ),
                      8.horizontalSpace,
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor),
                            ),
                            8.verticalSpace,
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Text(
                                description ?? "",
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black3D.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.black3D,
                                    darkModeColor: AppColors.greyB0,
                                  ),),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    UIComponent.iconRowAndText(
                                      context: context,
                                      svgPath: SVGAssets.locationIcon,
                                      text:
                                          '${city?.isNotEmpty == true ? city : ''}'
                                          '${(city?.isNotEmpty == true && country?.isNotEmpty == true) ? ', ' : ''}'
                                          '${country?.isNotEmpty == true ? country : ''}',
                                      backgroundColor: AppColors.colorBgPrimary
                                          .adaptiveColor(context,
                                              lightModeColor:
                                                  AppColors.colorBgPrimary,
                                              darkModeColor: AppColors.black2E),
                                      textColor: AppColors.colorPrimary
                                          .adaptiveColor(context,
                                              lightModeColor:
                                                  AppColors.colorPrimary,
                                              darkModeColor: AppColors.white),
                                    ),
                                  ],
                                ),
                                SVGAssets.circleArrowRightRoundIcon.toSvg(
                                  context: context,
                                  color: AppColors.colorPrimary,
                                  height: 22,
                                  width: 22,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
