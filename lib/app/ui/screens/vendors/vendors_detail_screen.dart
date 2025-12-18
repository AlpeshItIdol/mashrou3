import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../../config/utils.dart';
import '../../../../utils/app_localization.dart';
import '../../../../utils/ui_components.dart';
import '../../../navigation/route_arguments.dart';
import '../../../navigation/routes.dart';
import '../../custom_widget/common_button_with_icon.dart';
import '../../custom_widget/map_card_widget.dart';
import 'model/vendors_sequence_response.dart';

class VendorsDetailScreen extends StatefulWidget {
  VendorSequenceUser items;
  VendorsDetailScreen({super.key,required this.items});

  @override
  State<VendorsDetailScreen> createState() => _VendorsDetailScreenState();
}

class _VendorsDetailScreenState extends State<VendorsDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding:
              const EdgeInsetsDirectional.only(end: 12.0),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.greyE8.adaptiveColor(
                      context,
                      lightModeColor: AppColors.greyE8,
                      darkModeColor: AppColors.black2E,
                    ),
                    width: 1,
                  ),
                ),
                child: UIComponent.customInkWellWidget(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      TextDirection.rtl == Directionality.of(context)
                          ? SVGAssets.arrowRightIcon
                          : SVGAssets.arrowLeftIcon,
                      height: 26,
                      width: 26,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).focusColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Text('Vendor Detail'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    12.verticalSpace,
                    Row(
                      children: [
                        const Spacer(),
                        /// 3d button
                        CommonButtonWithIcon(
                          onTap: () {
                            // Utils.launchURL(url: widget.items.socialMediaLinks!.virtualTour ?? "");
                            // AnalyticsService.logEvent(
                            //   eventName: "property_virtual_tour_icon_click",
                            //   parameters: {
                            //     AppConstants.analyticsIdOfUserKey: cubit.selectedUserId,
                            //     AppConstants.analyticsUserTypeKey: cubit.selectedUserRole,
                            //     AppConstants.analyticsPropertyIdKey: widget.sId
                            //   },
                            // );
                            (widget.items.socialMediaLinks!.virtualTour?? "") == ""
                                ? () {}
                                : context.pushNamed(Routes.kWebViewScreen,
                                extra: widget.items.socialMediaLinks!.virtualTour ?? "",
                                pathParameters: {
                                  RouteArguments.title: appStrings(context).virtualTour,
                                });
                          },
                          title: appStrings(context).virtualTour,
                          isDisabled:  (widget.items.socialMediaLinks!.virtualTour ?? "") == "" ? true : false,
                          icon: SVGAssets.virtual3dViewIcon.toSvg(
                              context: context,
                              color:
                              // AppColors.white
                            ( widget.items.socialMediaLinks!.virtualTour ??  "") == ""
                              ? AppColors.grey77.adaptiveColor(context,
                              lightModeColor: AppColors.grey77, darkModeColor: AppColors.greyE9)
                              : AppColors.white
                          ),
                          isGradientColor: true,
                          gradientColor: AppColors.primaryGradient,
                        ),
                        const SizedBox(width: 10,),
                        /// share icon
                        UIComponent.customInkWellWidget(
                          onTap:() {
                                Utils.shareVendor(context,
                                    vendorSequenceUser: widget.items);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppColors.greyE9.adaptiveColor(context,
                                          lightModeColor: AppColors.greyE9,
                                          darkModeColor: AppColors.black3D),
                                      width: 1)),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(10.0),
                                child: UIComponent.customRTLIcon(
                                    child: SvgPicture.asset(
                                      SVGAssets.shareIcon,
                                      height: 26,
                                      width: 26,
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context).focusColor, BlendMode.srcIn),
                                    ),
                                    context: context),
                              )),
                        ),
                      ],
                    ),
                    // 12.verticalSpace,
                    if(widget.items.companyDescription != null)...[
                      12.verticalSpace,
                      _buildDescription(context),
                    ],
                    _buildPrimaryContacts(context),
                    if(widget.items.alternativeContactNumbers != null && widget.items.alternativeContactNumbers!.contactNumber != null && widget.items.alternativeContactNumbers!.contactNumber != "" )...[
                      16.verticalSpace,
                      _buildAltContacts(context),
                    ],

                    if(widget.items.location != null && widget.items.location!.length > 0)...[
                      16.verticalSpace,
                      _buildLocationSection(context),
                    ],

                    16.verticalSpace,
                    _buildContactUs(context),
                    if(widget.items.portfolio != null && widget.items.portfolio!.length > 0)...[
                      16.verticalSpace,
                      _buildPortfolioDocuments(context,widget.items.portfolio!),
                    ],
                    // if(widget.items.identityVerificationDoc != null && widget.items.identityVerificationDoc!.length > 0)...[
                    //   16.verticalSpace,
                    //   _buildVerificationDocuments(context,widget.items.identityVerificationDoc!),
                    // ],
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.colorSecondary,
            shape: BoxShape.circle,
          ),
          child: SVGAssets.userLightIcon.toSvg(context: context, color: Theme.of(context).canvasColor),
        ),
        12.horizontalSpace,
        Expanded(
          child: Text(
            widget.items.companyName!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
        ),
        6.verticalSpace,
        Text(
          widget.items.companyDescription ?? "",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.black3D.adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0),
              ),
        ),
      ],
    );
  }

  Widget _buildPrimaryContacts(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if(widget.items.location != null && widget.items.location!.length > 0)...[
          UIComponent.iconRowAndText(
            svgPath: SVGAssets.locationIcon,
            text: widget.items.location![0].address ?? "",
            backgroundColor: AppColors.colorBgPrimary.adaptiveColor(context, lightModeColor: AppColors.colorBgPrimary, darkModeColor: AppColors.black2E),
            context: context,
            textColor: AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
          ),
        ],
        InkWell(
          onTap: (){
            final phone = "+${widget.items.phoneCode} ${widget.items.contactNumber}";

            if (phone.isNotEmpty) {
              Utils.makePhoneCall(
                context: context,
                phoneNumber: phone.toString(),
              );
            }
          },
          child: UIComponent.iconRowAndText(
            svgPath: SVGAssets.callIcon,
            text: "+${widget.items.phoneCode} ${widget.items.contactNumber}" ?? "",
            backgroundColor: AppColors.colorBgPrimary.adaptiveColor(context, lightModeColor: AppColors.colorBgPrimary, darkModeColor: AppColors.black2E),
            context: context,
            textColor: AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
          ),
        ),

        UIComponent.iconRowAndText(
          svgPath: SVGAssets.linkIcon,
          text: widget.items.email ?? "",
          backgroundColor: AppColors.colorBgPrimary.adaptiveColor(context, lightModeColor: AppColors.colorBgPrimary, darkModeColor: AppColors.black2E),
          context: context,
          textColor: AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildAltContacts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alternative Contact Numbers',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
        ),
        8.verticalSpace,
        InkWell(
          onTap: (){
            final phone = "+${widget.items.alternativeContactNumbers!.phoneCode}${widget.items.alternativeContactNumbers!.contactNumber!}";

            if (phone.isNotEmpty) {
              Utils.makePhoneCall(
                context: context,
                phoneNumber: phone.toString(),
              );
            }
          },
          child:  UIComponent.iconRowAndText(
            svgPath: SVGAssets.callIcon,
            text: widget.items.alternativeContactNumbers != null && widget.items.alternativeContactNumbers!.contactNumber != null ? "+${widget.items.alternativeContactNumbers!.phoneCode} ${widget.items.alternativeContactNumbers!.contactNumber!}" : "",// != null ? widget.items.alternativeContactNumbers!.contactNumber : "",
            // text: widget.items.alternativeContactNumbers != null ? widget.items.alternativeContactNumbers!.contactNumber : "",
            backgroundColor: AppColors.colorBgPrimary.adaptiveColor(context, lightModeColor: AppColors.colorBgPrimary, darkModeColor: AppColors.black2E),
            context: context,
            textColor: AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
          ),
        ),

      ],
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
        ),
        8.verticalSpace,
        // GoogleMapCardWidget(
        //   locationLatLng:  LatLng(widget.items.location![0].latitude ?? 0.0, widget.items.location![0].longitude ?? 0.0),
        //   buttonText: 'View on Map',
        //   onButtonPressed: () {},
        // ),
        _buildMapContainer(
            latitude: widget.items.location![0].latitude == 0
                ? widget.items.location![0].latitude ?? 0
                : widget.items.location![0].latitude!,
            longitude: widget.items.location![0].longitude == 0
                ? widget.items.location![0].longitude ??
                0
                : widget.items.location![0].longitude!),
      ],
    );
  }
  Widget _buildMapContainer(
      {required double latitude, required double longitude}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: GoogleMapCardWidget(
        onButtonPressed: () {
          Utils.openMapWithMarker(latitude: latitude, longitude: longitude);
        },
        locationLatLng: LatLng(latitude, longitude),
        buttonText: appStrings(context).viewInMap,
      ),
    ).hideIf(latitude == 0.0 || longitude == 0.0);
  }

  Widget _buildContactUs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
        ),
        10.verticalSpace,
        Row(
          children: [
            _buildSocialLink(
              onTap: () {
                urlLaunch(widget.items.socialMediaLinks!.facebook!);
                },
                customUI: SVGAssets.facebookVector.toSvg(context: context, height: 32, width: 32)
            ),
            12.horizontalSpace,
            _buildSocialLink(
                onTap: () {
                  urlLaunch(widget.items.socialMediaLinks!.instagram!);
                },
                customUI: SVGAssets.instagramVector.toSvg(context: context, height: 32, width: 32),
            ),
            12.horizontalSpace,
            _buildSocialLink(
              onTap: () {
                urlLaunch(widget.items.socialMediaLinks!.twitter!);
              },
              customUI:SVGAssets.twitterVector.toSvg(context: context, height: 32, width: 32),
            ),
            12.horizontalSpace,
            _buildSocialLink(
              onTap: () {
                urlLaunch(widget.items.socialMediaLinks!.linkedIn);
              },
              customUI: SVGAssets.linkedinIcon.toSvg(context: context, height: 32, width: 32),
            ),
            // 12.horizontalSpace,
            // _buildSocialLink(
            //   onTap: () {
            //     urlLaunch(widget.items.socialMediaLinks!.catalog!);
            //   },
            //   // customUI: Icon(Icons.document_scanner_rounded)
            //   customUI: SVGAssets.catlogIcon.toSvg(context: context, height: 32, width: 32),
            // ),
            12.horizontalSpace,
            _buildSocialLink(
              onTap: () {
                urlLaunch(widget.items.socialMediaLinks!.website!);
              },
              customUI: SVGAssets.websiteVector.toSvg(context: context, height: 32, width: 32),
            ),

          ],
        ),
      ],
    );
  }
  Widget _buildSocialLink({Function()? onTap,dynamic? customUI }){
    return InkWell(
        onTap: onTap,
        child: customUI,//SVGAssets.facebookVector.toSvg(context: context, height: 32, width: 32)
    );
  }
  urlLaunch(String url) async {
    try{
      await Utils.launchURL(url:url);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _buildPortfolioDocuments(BuildContext context,List<String> images) {
    // final images = [
    //   'https://picsum.photos/seed/vendors1/1000/800',
    //   'https://picsum.photos/seed/vendors2/1000/800',
    //   'https://picsum.photos/seed/vendors3/1000/800',
    // ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Portfolio',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
        12.verticalSpace,
        Text(
          'Images',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
        12.verticalSpace,
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: UIComponent.cachedNetworkImageWidget(
                  imageUrl: images[index],
                  width: 260,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationDocuments(BuildContext context,List<String> images) {
    // final images = [
    //   'https://picsum.photos/seed/vendors1/1000/800',
    //   'https://picsum.photos/seed/vendors2/1000/800',
    //   'https://picsum.photos/seed/vendors3/1000/800',
    // ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Documents',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
        ),
        12.verticalSpace,
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: UIComponent.cachedNetworkImageWidget(
                  imageUrl: images[index],
                  width: 260,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
