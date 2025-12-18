import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../config/resources/app_colors.dart';
import '../model/vendor_list_response_model.dart';

class VendorListItem extends StatefulWidget {
  final VendorCategoryData data;
  final bool isForCategory;
  final VoidCallback onItemTap;
  final VendorUserData? userData;

  const VendorListItem(
      {super.key,
      required this.data,
      this.userData,
      this.isForCategory = true,
      required this.onItemTap});

  @override
  State<VendorListItem> createState() => _VendorListItemState();
}

class _VendorListItemState extends State<VendorListItem> {
  @override
  Widget build(BuildContext context) {
    final portfolioFiles =
        Utils.getAllImageFiles(widget.userData?.portfolios ?? []);
    var portfolioFilesData = portfolioFiles.isNotEmpty ? portfolioFiles[0] : "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          color: AppColors.white.adaptiveColor(context,
              lightModeColor: AppColors.white,
              darkModeColor: AppColors.black2E),
          child: UIComponent.customInkWellWidget(
            onTap: widget.onItemTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton.leaf(
                  enabled: false,
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: SizedBox(
                        height: 180,
                        child: UIComponent.cachedNetworkImageWidget(
                            fit: BoxFit.cover,
                            imageUrl: widget.isForCategory
                                ? widget.data.vendorLogo
                                : portfolioFilesData),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (!widget.isForCategory)
                            widget.userData?.companyLogo != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.userData?.companyLogo ?? "",
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.colorPrimary,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: AppColors.colorSecondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SVGAssets.userLightIcon.toSvg(
                                      context: context,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                          !widget.isForCategory
                              ? 16.horizontalSpace
                              : const SizedBox.shrink(),
                          Flexible(
                            child: Text(
                              widget.isForCategory
                                  ? widget.data.title ?? ""
                                  : widget.userData?.companyName ?? "",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Text(
                        widget.isForCategory
                            ? widget.data.description ?? ""
                            : widget.userData?.companyDesc ?? "",
                        softWrap: true,
                        maxLines: null,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.black3D.adaptiveColor(context,
                                lightModeColor: AppColors.black3D,
                                darkModeColor: AppColors.greyB0)),
                      ).hideIf(widget.data.description == null ||
                          widget.data.description == ""),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
