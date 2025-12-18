import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/model/offers/my_offers_list_response_model.dart';
import 'package:mashrou3/app/model/verify_response.model.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/common_button_with_icon.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/custom_widget/map_card_widget.dart';
import 'package:mashrou3/app/ui/custom_widget/my_gif_widget.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/home/cubit/home_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/services/analytics_service.dart';
import 'package:mashrou3/config/services/property_vendor_finance_service.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/read_more_text.dart';
import 'package:mashrou3/utils/string_utils.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../../config/resources/app_strings.dart';
import '../../bank_details/cubit/bank_details_cubit.dart';
import 'cubit/vendor_detail_cubit.dart';

class VendorDetailsScreen extends StatefulWidget {
  const VendorDetailsScreen({super.key, required this.vendorUserId, required this.isFromFinanceReq});

  final String vendorUserId;
  final bool isFromFinanceReq;

  @override
  State<VendorDetailsScreen> createState() => _VendorDetailsScreenState();
}

class _VendorDetailsScreenState extends State<VendorDetailsScreen> with AppBarMixin {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<VendorDetailCubit>().getData(widget.vendorUserId, context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        BankDetailsCubit bankDetailsCubit = context.read<BankDetailsCubit>();
        bankDetailsCubit.offerId = "";
      },
      child: Scaffold(
        body: BlocConsumer<VendorDetailCubit, VendorDetailState>(
          listener: buildBlocListener,
          builder: (context, state) {
            VendorDetailCubit cubit = context.read<VendorDetailCubit>();
            final isLoading =
                state is VendorOffersLoading || state is VendorDetailLoading || state is VendorDetailInitial || cubit.detailData.sId == "";

            return Skeletonizer(
              enabled: isLoading,
              child: isLoading
                  ? UIComponent.getSkeletonVendorDetail()
                  : NestedScrollView(
                // physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 290.0,
                    pinned: false,
                    flexibleSpace: _buildImageSlider(cubit),
                  ),
                ],
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildDetailsSection(context, cubit),
                              _buildMapSection(context, cubit),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );

          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildImageSlider(VendorDetailCubit cubit) {
    VendorDetailCubit cubit = context.read<VendorDetailCubit>();
    final portfolioFiles = Utils.getAllImageFiles(cubit.detailData.portfolio ?? []);

    return Stack(
      children: [
        portfolioFiles.isNotEmpty
            ? PageView.builder(
          controller: _pageController,
          itemCount: portfolioFiles.length,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final imageUrl = portfolioFiles[index] ?? "";
            return AspectRatio(
              aspectRatio: 1,
              child: UIComponent.customInkWellWidget(
                onTap: () {
                  context.pushNamed(
                    Routes.kCarouselFullScreen,
                    pathParameters: {
                      RouteArguments.index: index.toString(),
                    },
                    extra: portfolioFiles,
                  );
                },
                child: imageUrl != "null" && imageUrl != "" && imageUrl.endsWith('.gif')
                    ? MyGif(gifUrl: imageUrl, height: 300)
                    : CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: AppColors.colorPrimary),
                  ),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    SVGAssets.placeholder,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            );
          },
        )
            : Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SvgPicture.asset(
            SVGAssets.placeholder,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              portfolioFiles.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPageIndex == index ? 12 : 8,
                height: _currentPageIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPageIndex == index ? AppColors.colorPrimary : Colors.grey,
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: buildAppBar(context: context, requireLeading: true),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context, VendorDetailCubit cubit) {
    var isCatelogAvailable = cubit.detailData.socialMediaLinks != null &&
        cubit.detailData.socialMediaLinks!.catalog != null &&
        cubit.detailData.socialMediaLinks!.catalog!.isNotEmpty;

    var isVirtualTourAvailable = cubit.detailData.socialMediaLinks != null &&
        cubit.detailData.socialMediaLinks!.virtualTour != null &&
        cubit.detailData.socialMediaLinks!.virtualTour!.isNotEmpty;
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              cubit.detailData.companyLogo != null && cubit.detailData.companyLogo!.startsWith('http')
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  imageUrl: cubit.detailData.companyLogo ?? "",
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                  ),
                ),
              )
                  : Container(
                padding: const EdgeInsets.all(8),
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.colorSecondary,
                  shape: BoxShape.circle,
                ),
                child: SVGAssets.userLightIcon.toSvg(
                  context: context,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              16.horizontalSpace,
              Flexible(
                child: Text(
                  cubit.detailData.companyName ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if ((cubit.detailData.companyDescription ?? "").isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: ReadMoreText(
                cubit.detailData.companyDescription ?? "",
                trimMode: TrimMode.Line,
                trimLines: 3,
                locale: Locale(cubit.selectedLanguage),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.black3D.adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0),
                ),
                trimCollapsedText: appStrings(context).readMore,
                trimExpandedText: appStrings(context).readLess,
                lessStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                moreStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonButtonWithIcon(
                    onTap: () {
                      Utils.launchURL(url: cubit.detailData.socialMediaLinks?.catalog ?? "");
                    },
                    isDisabled: !isCatelogAvailable,
                    title: appStrings(context).lblCatalog,
                    icon: SVGAssets.workHistoryIcon.toSvg(
                        context: context,
                        color: !isCatelogAvailable
                            ? AppColors.grey77.adaptiveColor(context, lightModeColor: AppColors.grey77, darkModeColor: AppColors.greyE9)
                            : AppColors.colorPrimary.adaptiveColor(context,
                            lightModeColor: !isCatelogAvailable ? AppColors.grey77 : AppColors.colorPrimary,
                            darkModeColor: AppColors.white)),
                    borderColor: AppColors.colorPrimary
                        .adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                    isGradientColor: false,
                    buttonTextColor: AppColors.colorPrimary
                        .adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: CommonButtonWithIcon(
                    onTap: () {
                      /*Utils.launchURL(
                          url: cubit.detailData.socialMediaLinks?.virtualTour ??
                              "");*/
                      (cubit.detailData.socialMediaLinks?.virtualTour ?? "") == ""
                          ? () {}
                          : context.pushNamed(Routes.kWebViewScreen,
                          extra: cubit.detailData.socialMediaLinks?.virtualTour ?? "",
                          pathParameters: {
                            RouteArguments.title: appStrings(context).virtualTour,
                          });
                    },
                    title: appStrings(context).virtualTour,
                    isDisabled: !isVirtualTourAvailable,
                    icon: SVGAssets.virtual3dViewIcon.toSvg(
                        context: context,
                        color: !isVirtualTourAvailable
                            ? AppColors.grey77.adaptiveColor(context, lightModeColor: AppColors.grey77, darkModeColor: AppColors.greyE9)
                            : AppColors.white),
                    isGradientColor: true,
                    gradientColor: AppColors.primaryGradient,
                  ),
                ),
              ],
            ),
          ),
          12.verticalSpace,
          // _buildOffersSection(context, cubit),
          _buildDocumentSection(context, cubit),
          _buildContactUsSection(context, cubit),
        ],
      ),
    );
  }

  Widget _buildDocumentSection(BuildContext context, VendorDetailCubit cubit) {
    final docFiles = Utils.getAllDocFiles(cubit.detailData.portfolio ?? []);
    if (docFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appStrings(context).lblDocuments,
                style:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
              ),
              UIComponent.customInkWellWidget(
                onTap: () {
                  UIComponent.showCustomBottomSheet(
                      horizontalPadding: 0,
                      context: context,
                      builder: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            appStrings(context).lblDocuments,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          24.verticalSpace,
                          if (docFiles.isNotEmpty || docFiles[0].isNotEmpty)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: docFiles.length,
                              itemBuilder: (context, index) {
                                final option = docFiles[index];

                                return Container(
                                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: AppColors.greyF5
                                        .adaptiveColor(context, lightModeColor: AppColors.greyF5, darkModeColor: AppColors.black14),
                                  ),
                                  child: UIComponent.dataListTile(
                                      title: StringUtils.extractFileNameWithExtension(
                                        option,
                                      ),
                                      icon: option.contains("pdf")
                                          ? SVGAssets.pdfIcon
                                          : option.contains("text")
                                          ? SVGAssets.textIcon
                                          : SVGAssets.docIcon,
                                      context: context,
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await Utils.launchURL(url: option);
                                      }),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return 12.verticalSpace;
                              },
                            ),
                        ],
                      ));
                },
                child: Text(
                  appStrings(context).lblViewAll,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor),
                ).showIf(docFiles.isNotEmpty && docFiles.length > 3),
              ),
            ],
          ),
          8.verticalSpace,
          Skeleton.unite(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: (docFiles).take(3).map<Widget>((docData) {
                  return UIComponent.customInkWellWidget(
                      onTap: () async {
                        await Utils.launchURL(url: docData);
                      },
                      child: UIComponent.dynamicIconRowAndText(
                        context: context,
                        svgPath: docData.endsWith(".pdf")
                            ? SVGAssets.pdfIcon
                            : docData.endsWith(".txt")
                            ? SVGAssets.textIcon
                            : SVGAssets.docIcon,
                        text: StringUtils.extractFileNameWithExtension(docData),
                        // Display the value or fallback text
                        backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                          context,
                          lightModeColor: AppColors.colorBgPrimary,
                          darkModeColor: AppColors.black2E,
                        ),
                        textColor: AppColors.colorPrimary.adaptiveColor(
                          context,
                          lightModeColor: AppColors.colorPrimary,
                          darkModeColor: AppColors.white,
                        ),
                      ));
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildContactUsSection(BuildContext context, VendorDetailCubit cubit) {
    final socialLinks = cubit.detailData.socialMediaLinks ?? SocialMediaLinks();
    if (socialLinks.isEmpty() && (cubit.detailData.contactNumber == "") && (cubit.detailData.alternativeContactNumbers == null)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            appStrings(context).contactUs,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),

          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UIComponent.customInkWellWidget(
                  onTap: () async {
                    await Utils.launchURL(url: cubit.detailData.socialMediaLinks?.facebook ?? "");
                  },
                  child: SVGAssets.facebookVector.toSvg(context: context, height: 32, width: 32)),
              12.horizontalSpace,
              UIComponent.customInkWellWidget(
                onTap: () async {
                  await Utils.launchURL(url: cubit.detailData.socialMediaLinks?.instagram ?? "");
                },
                child: SVGAssets.instagramVector.toSvg(context: context, height: 32, width: 32),
              ),
              12.horizontalSpace,
              UIComponent.customInkWellWidget(
                onTap: () async {
                  await Utils.launchURL(url: cubit.detailData.socialMediaLinks?.twitter ?? "");
                },
                child: SVGAssets.twitterVector.toSvg(context: context, height: 32, width: 32),
              ),
              12.horizontalSpace,
              UIComponent.customInkWellWidget(
                onTap: () {
                  cubit.detailData.alternativeContactNumbers != null &&
                      cubit.detailData.alternativeContactNumbers?.contactNumber != null &&
                      cubit.detailData.alternativeContactNumbers?.contactNumber != ""
                      ? UIComponent.showCustomBottomSheet(
                    horizontalPadding: 0,
                    verticalPadding: 8,
                    context: context,
                    builder: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 83,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.black14,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        24.verticalSpace,
                        Text(
                          appStrings(context).lblContactDetails,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        24.verticalSpace,
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: 2,
                          // Number of contact numbers
                          itemBuilder: (context, index) {
                            // List of contact numbers
                            final contacts = [
                              // +$phoneCode$contactNumber

                              "+${cubit.detailData.phoneCode.toString()}${cubit.detailData.contactNumber.toString()}",
                              "+${cubit.detailData.alternativeContactNumbers?.phoneCode.toString()}${cubit.detailData.alternativeContactNumbers?.contactNumber.toString()}",
                            ];

                            // Get the contact for the current index
                            final contact = contacts[index];

                            // Check if the contact is null
                            if (contact == null) {
                              return const SizedBox.shrink(); // Return an empty widget for null contacts
                            }

                            return Container(
                              margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.greyF5
                                    .adaptiveColor(context, lightModeColor: AppColors.greyF5, darkModeColor: AppColors.black14),
                              ),
                              child: UIComponent.dataListTile(
                                  title: contact,
                                  icon: SVGAssets.callIcon,
                                  context: context,
                                  onTap: () {
                                    // Handle onTap for the contact item
                                    debugPrint('Contact selected: $contact');
                                    Navigator.pop(context); // Close the bottom sheet
                                    UIComponent.showCustomBottomSheet(
                                        horizontalPadding: 0,
                                        context: context,
                                        builder: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              appStrings(context).lblContactNow,
                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                                            ),
                                            24.verticalSpace,
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: const ClampingScrollPhysics(),
                                              itemCount: cubit.contactNowOptions.length,
                                              itemBuilder: (context, index) {
                                                final option = cubit.contactNowOptions[index];
                                                final isWhatsApp = option.title.toLowerCase() == "whatsapp";

                                                return Container(
                                                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    gradient: isWhatsApp ? AppColors.primaryGradient : null,
                                                    color: !isWhatsApp
                                                        ? AppColors.greyF5.adaptiveColor(context,
                                                        lightModeColor: AppColors.greyF5, darkModeColor: AppColors.black14)
                                                        : null,
                                                  ),
                                                  child: ListTile(
                                                      leading: Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: isWhatsApp
                                                              ? AppColors.white
                                                              : AppColors.colorPrimary.withOpacity(0.10).adaptiveColor(context,
                                                              lightModeColor: AppColors.colorPrimary.withOpacity(0.10),
                                                              darkModeColor: AppColors.colorPrimary),
                                                          borderRadius: BorderRadius.circular(8), // Rounded container
                                                        ),
                                                        child: option.icon.toSvg(
                                                          context: context,
                                                          color: AppColors.colorPrimary.adaptiveColor(context,
                                                              lightModeColor: AppColors.colorPrimary,
                                                              darkModeColor: isWhatsApp ? AppColors.colorPrimary : AppColors.white),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        option.title,
                                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                          color: isWhatsApp ? AppColors.white : Theme.of(context).primaryColor,
                                                        ),
                                                      ),
                                                      trailing: SVGAssets.arrowRightIcon.toSvg(
                                                        context: context,
                                                        color: isWhatsApp
                                                            ? AppColors.white
                                                            : AppColors.colorPrimary.adaptiveColor(context,
                                                            lightModeColor: AppColors.colorPrimary,
                                                            darkModeColor: AppColors.white),
                                                      ),
                                                      onTap: () async {
                                                        switch (index) {
                                                          case 0:
                                                          // Make the phone call
                                                            Utils.makePhoneCall(
                                                              context: context,
                                                              phoneNumber: contact.toString(),
                                                            );

                                                            debugPrint('Item 0 (Direct Call) selected');
                                                            break;

                                                          case 1:
                                                          // Make WhatsApp call
                                                            Utils.makeWhatsAppCall(
                                                              context: context,
                                                              phoneNumber: contact.toString(),
                                                            );

                                                            debugPrint('Item 1 (WhatsApp) selected');
                                                            break;

                                                          case 2:
                                                          // Send SMS
                                                            Utils.makeSms(
                                                              context: context,
                                                              phoneNumber: contact.toString(),
                                                            );

                                                            debugPrint('Item 2 (Text) selected');
                                                            break;

                                                          default:
                                                          // Default action for other items
                                                            debugPrint('Item $index selected: ${option.title}');
                                                            break;
                                                        }

                                                        // Close the bottom sheet
                                                        Navigator.pop(context);

                                                        // Log the selected option title
                                                        debugPrint('${option.title} selected');
                                                      }),
                                                );
                                              },
                                              separatorBuilder: (BuildContext context, int index) {
                                                return 12.verticalSpace;
                                              },
                                            ),
                                          ],
                                        ));
                                  }),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return 12.verticalSpace;
                          },
                        ),
                      ],
                    ),
                  )
                      : UIComponent.showCustomBottomSheet(
                      horizontalPadding: 0,
                      context: context,
                      builder: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            appStrings(context).lblContactNow,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          24.verticalSpace,
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: cubit.contactNowOptions.length,
                            itemBuilder: (context, index) {
                              final option = cubit.contactNowOptions[index];
                              final isWhatsApp = option.title.toLowerCase() == "whatsapp";

                              return Container(
                                margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: isWhatsApp ? AppColors.primaryGradient : null,
                                  color: !isWhatsApp
                                      ? AppColors.greyF5
                                      .adaptiveColor(context, lightModeColor: AppColors.greyF5, darkModeColor: AppColors.black14)
                                      : null,
                                ),
                                child: ListTile(
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isWhatsApp
                                            ? AppColors.white
                                            : AppColors.colorPrimary.withOpacity(0.10).adaptiveColor(context,
                                            lightModeColor: AppColors.colorPrimary.withOpacity(0.10),
                                            darkModeColor: AppColors.colorPrimary),
                                        borderRadius: BorderRadius.circular(8), // Rounded container
                                      ),
                                      child: option.icon.toSvg(
                                        context: context,
                                        color: AppColors.colorPrimary.adaptiveColor(context,
                                            lightModeColor: AppColors.colorPrimary,
                                            darkModeColor: isWhatsApp ? AppColors.colorPrimary : AppColors.white),
                                      ),
                                    ),
                                    title: Text(
                                      option.title,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: isWhatsApp ? AppColors.white : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    trailing: SVGAssets.arrowRightIcon.toSvg(
                                      context: context,
                                      color: isWhatsApp
                                          ? AppColors.white
                                          : AppColors.colorPrimary.adaptiveColor(context,
                                          lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                                    ),
                                    onTap: () async {
                                      switch (index) {
                                        case 0:
                                        // Get phone code and contact number
                                          final phoneCode = cubit.detailData.phoneCode; // Example: 91
                                          final contactNumber = cubit.detailData.contactNumber; // Example: 9898563902

                                          // Format the phone number to include the phoneCode
                                          final formattedPhoneNumber = '+$phoneCode$contactNumber';

                                          // Make the phone call
                                          Utils.makePhoneCall(
                                            context: context,
                                            phoneNumber: formattedPhoneNumber.toString(),
                                          );

                                          debugPrint('Item 0 (Direct Call) selected');
                                          break;

                                        case 1:
                                        // Get phone code and contact number
                                          final phoneCode = cubit.detailData.phoneCode; // Example: 91
                                          final contactNumber = cubit.detailData.contactNumber; // Example: 9898563902

                                          // Format the phone number to include the phoneCode
                                          final formattedPhoneNumber = '+$phoneCode$contactNumber';

                                          // Make WhatsApp call
                                          Utils.makeWhatsAppCall(
                                            context: context,
                                            phoneNumber: formattedPhoneNumber.toString(),
                                          );

                                          debugPrint('Item 1 (WhatsApp) selected');
                                          break;

                                        case 2:
                                        // Get phone code and contact number
                                          final phoneCode = cubit.detailData.phoneCode; // Example: 91
                                          final contactNumber = cubit.detailData.contactNumber; // Example: 9898563902

                                          // Format the phone number to include the phoneCode
                                          final formattedPhoneNumber = '+$phoneCode$contactNumber';

                                          // Send SMS
                                          Utils.makeSms(
                                            context: context,
                                            phoneNumber: formattedPhoneNumber.toString(),
                                          );

                                          debugPrint('Item 2 (Text) selected');
                                          break;

                                        default:
                                        // Default action for other items
                                          debugPrint('Item $index selected: ${option.title}');
                                          break;
                                      }

                                      // Close the bottom sheet
                                      Navigator.pop(context);

                                      // Log the selected option title
                                      debugPrint('${option.title} selected');
                                    }),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return 12.verticalSpace;
                            },
                          ),
                        ],
                      ));
                },
                // onTap: () async {
                //   Utils.makePhoneCall(
                //       context: context,
                //       phoneNumber: cubit.detailData.contactNumber ?? "0");
                // },
                child: SVGAssets.callVector.toSvg(context: context, height: 32, width: 32),
              ),
              12.horizontalSpace,
              UIComponent.customInkWellWidget(
                onTap: () async {
                  await Utils.launchURL(url: cubit.detailData.socialMediaLinks?.website ?? "");
                },
                child: SVGAssets.websiteVector.toSvg(context: context, height: 32, width: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection(BuildContext context, VendorDetailCubit cubit) {
    final offerData = cubit.detailData.offerData;
    if (offerData == null || offerData.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        18.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              appStrings(context).lblOffers,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
            ),
            UIComponent.customInkWellWidget(
              onTap: () {
                context.pushNamed(Routes.kOfferListScreen, pathParameters: {
                  RouteArguments.offersList: jsonEncode(offerData.map((e) => e.toJson()).toList()),
                });
              },
              child: UIComponent.customRTLIcon(
                  child: SVGAssets.arrowRightIcon.toSvg(
                      context: context,
                      color: AppColors.black14.adaptiveColor(context, lightModeColor: AppColors.black14, darkModeColor: AppColors.white)),
                  context: context),
            ),
          ],
        ),
        12.verticalSpace,
        BlocBuilder<VendorDetailCubit, VendorDetailState>(
          builder: (context, state) {
            VendorDetailCubit cubit = context.read<VendorDetailCubit>();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 160,
                        maxHeight: UIComponent.isSystemFontMax(context) ? 210 : 170,
                      ),
                      color: AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black14),
                      child: ListView.separated(
                        itemCount: (offerData.length > 2) ? 2 : offerData.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final OfferData item = offerData[index];
                          bool isSelected = cubit.selectedOffer == item; // Check selection

                          return Container(
                            width: 220,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.colorPrimary.withOpacity(0.1),
                                  blurRadius: 18,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.adaptiveColor(context, lightModeColor: Colors.white, darkModeColor: AppColors.black2E),
                            ),
                            child: UIComponent.customInkWellWidget(
                              onTap: () {
                                //Log the offer view event
                                AnalyticsService.logEvent(
                                  eventName: "offer_view",
                                  parameters: {
                                    AppConstants.analyticsIdOfUserKey: cubit.selectedUserId,
                                    AppConstants.analyticsOfferIdKey: item.sId,
                                    AppConstants.analyticsUserTypeKey: cubit.selectedUserRole,
                                  },
                                );
                                context.pushNamed(Routes.kOfferDetailScreen,
                                    pathParameters: {
                                      RouteArguments.isDraftOffer: "false",
                                    },
                                    extra: item.sId?.trim());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.colorPrimary.adaptiveColor(context,
                                                  lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white)),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => cubit.selectOffer(context, item), // Checkbox selection
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            gradient: isSelected
                                                ? AppColors.primaryGradient
                                                : const LinearGradient(colors: [AppColors.greyE9, AppColors.greyE9]),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: isSelected ? Colors.white : Colors.transparent,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  8.verticalSpace,
                                  Text(
                                    item.description ?? "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey8A
                                            .adaptiveColor(context, lightModeColor: AppColors.grey8A, darkModeColor: AppColors.greyB0)),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                                    child: CustomDivider.colored(context),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.price != null
                                            ? num.parse(item.price!.amount.toString()).formatCurrency(
                                          showSymbol: true,
                                          currencySymbol: item.price!.currencySymbol ?? "",
                                        )
                                            : "-",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.colorPrimary.adaptiveColor(context,
                                                lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.greyB0)),
                                      ),
                                      UIComponent.customRTLIcon(
                                          child: SVGAssets.arrowRightIcon.toSvg(
                                              context: context,
                                              color: AppColors.black14.adaptiveColor(context,
                                                  lightModeColor: AppColors.black14, darkModeColor: AppColors.white)),
                                          context: context),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return 24.horizontalSpace;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        12.verticalSpace,
      ],
    );
  }

  Widget _buildMapSection(BuildContext context, VendorDetailCubit cubit) {
    final location = cubit.detailData.location;
    if (location == null || location.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GoogleMapCardWidget(
        onButtonPressed: () {
          Utils.openMapWithMarker(
            latitude: location.first.latitude ?? 0.0,
            longitude: location.first.longitude ?? 0.0,
          );
        },
        locationLatLng: LatLng(
          location.first.latitude ?? 0.0,
          location.first.longitude ?? 0.0,
        ),
        buttonText: appStrings(context).viewInMap,
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    VendorDetailCubit cubit = context.read<VendorDetailCubit>();
    return BlocListener<VendorDetailCubit, VendorDetailState>(
      listener: (context, state) {},
      child: UIComponent.customInkWellWidget(
        onTap: () {
          var propertyId = GetIt.I<PropertyVendorFinanceService>().getPropertyId() ?? "0";
          var vendorId = GetIt.I<PropertyVendorFinanceService>().getVendorId() ?? "0";
          BankDetailsCubit bankDetailsCubit = context.read<BankDetailsCubit>();
          bankDetailsCubit.offerId = cubit.selectedOffer?.sId;
          cubit.sendFinanceRequest(propertyId: propertyId, vendorId: vendorId, offerId: bankDetailsCubit.offerId ?? "");
        },
        child: Container(
          height: 90,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, color: null),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appStrings(context).btnSendRequest,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.colorPrimary),
                      ),
                      UIComponent.customRTLIcon(
                          child: SVGAssets.arrowRightIcon.toSvg(context: context, color: AppColors.colorPrimary), context: context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).hideIf(widget.isFromFinanceReq),
    );
  }

  Future<void> buildBlocListener(BuildContext context, VendorDetailState state) async {
    if (state is FinanceRequestLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is FinanceRequestSuccess) {
      HomeCubit homeCubit = context.read<HomeCubit>();
      homeCubit.resetPropertyList();
      homeCubit.searchText = context.read<HomeCubit>().searchText;
      homeCubit.refreshData();
      OverlayLoadingProgress.stop();

      if (!context.mounted) return;
      Utils.snackBar(context: context, message: state.message);
      context.goNamed(Routes.kDashboard);
    } else if (state is FinanceRequestFailure) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

