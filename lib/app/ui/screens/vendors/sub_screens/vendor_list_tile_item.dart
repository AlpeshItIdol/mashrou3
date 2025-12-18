
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../config/resources/app_assets.dart';
import '../../../../../config/resources/app_colors.dart';
import '../../../../../config/utils.dart';
import '../../../../../utils/ui_components.dart';
import '../../property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import '../model/vendors_sequence_response.dart';

class VendorListTileItem extends StatefulWidget {
  final VendorCategoryData data;
  final bool isForCategory;
  final VoidCallback onItemTap;
  final VendorSequenceUser? userData;

  const VendorListTileItem(
      {super.key,
        required this.data,
        this.userData,
        this.isForCategory = true,
        required this.onItemTap});

  @override
  State<VendorListTileItem> createState() => _VendorListTileItemState();
}

class _VendorListTileItemState extends State<VendorListTileItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.isForCategory);
    final portfolioFiles =
    Utils.getAllImageFiles(widget.userData?.portfolio ?? []);
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isForCategory
                                ? widget.data.description ?? ""
                                : widget.userData?.companyDescription ?? "",
                            softWrap: true,
                            maxLines: null,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.black3D.adaptiveColor(context,
                                    lightModeColor: AppColors.black3D,
                                    darkModeColor: AppColors.greyB0)),
                          ).hideIf(widget.data.description == null ||
                              widget.data.description == ""),

                          if (widget.userData?.contactNumber?.isNotEmpty == true) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18.0, top: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Contact Number: ',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final phone = "+${widget.userData?.phoneCode.toString()}${widget.userData?.contactNumber.toString()}";

                                            if (phone.isNotEmpty) {
                                              Utils.makePhoneCall(
                                                context: context,
                                                phoneNumber: phone.toString(),
                                              );
                                            }
                                          },
                                          child: Text(
                                            "+${widget.userData?.phoneCode.toString()}${widget.userData?.contactNumber.toString()}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black, // clickable look
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
String _formatPhoneNumber(String number) {
  if (number.isEmpty) return '';
  if (number.startsWith('00962')) return number;        // already full format
  if (number.startsWith('962')) return '009$number';    // missing leading 00
  if (number.startsWith('0')) return '00962${number.substring(1)}'; // local style
  return '00962$number'; // fallback
}