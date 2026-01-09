import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/banks_list/model/banks_list_response_model.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../../../../../config/resources/app_assets.dart';
import '../../../../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../../../../utils/ui_components.dart';

class BanksListCard extends StatelessWidget {
  final String? name;
  final String? description;
  final String? country;
  final String? city;
  final String? imageUrl;
  final VoidCallback? onTap;
  final String? phNo;
  final BankUser? data;
  const BanksListCard({
    super.key,
    this.name,
    this.description,
    this.country,
    this.city,
    this.imageUrl,
    this.onTap,
    this.phNo, this.data,
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
                                    height: 56,
                                    width: 56,
                                    padding: const EdgeInsets.all(1),
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
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child:
                                          UIComponent.cachedNetworkImageWidget(
                                              imageUrl: imageUrl,
                                              fit: BoxFit.contain),
                                    )),
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor),
                            ),
                            8.verticalSpace,
                            // Email display
                            if (data?.email?.isNotEmpty == true) ...[
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    SVGAssets.emailContactIcon,
                                    height: 16,
                                    width: 16,
                                    colorFilter: ColorFilter.mode(
                                      const Color.fromRGBO(62, 113, 119, 1.0),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  6.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      data!.email!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.black3D.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.black3D,
                                              darkModeColor: AppColors.greyB0,
                                            ),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              6.verticalSpace,
                            ],
                            // Phone numbers display
                            if (data?.banksAlternativeContact?.isNotEmpty == true) ...[
                              ...data!.banksAlternativeContact!.map((contact) {
                                final phoneNumber = contact.phoneCode != null && contact.contactNumber != null
                                    ? '+${contact.phoneCode} ${contact.contactNumber}'
                                    : contact.contactNumber ?? '';
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        SVGAssets.callContactIcon,
                                        height: 16,
                                        width: 16,
                                        colorFilter: ColorFilter.mode(
                                          const Color.fromRGBO(62, 113, 119, 1.0),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      6.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          phoneNumber,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.black3D.adaptiveColor(
                                                  context,
                                                  lightModeColor: AppColors.black3D,
                                                  darkModeColor: AppColors.greyB0,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                            8.verticalSpace,
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Text(
                                description ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black3D.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.black3D,
                                        darkModeColor: AppColors.greyB0,
                                      ),
                                    ),
                              ),
                            ),

                            if (phNo?.isNotEmpty == true) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: Text(
                                  phNo!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black3D.adaptiveColor(
                                      context,
                                      lightModeColor: AppColors.black3D,
                                      darkModeColor: AppColors.greyB0,
                                    ),
                                  ),
                                ),
                              ),
                            ],


                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: city?.isNotEmpty == true ||
                                      country?.isNotEmpty == true,
                                  child: UIComponent.iconRowAndText(
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
                                ),
                                // UIComponent.customRTLIcon(
                                //     child: SVGAssets.circleArrowRightRoundIcon
                                //         .toSvg(
                                //       context: context,
                                //       color: AppColors.colorPrimary,
                                //       height: 22,
                                //       width: 22,
                                //     ),
                                //     context: context)
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
