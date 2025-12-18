import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/common_button.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/subscreen/offer_detail/cubit/offer_detail_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/services/property_vendor_finance_service.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/string_utils.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../../../utils/read_more_text.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../banks_list/model/banks_list_response_model.dart';
class OfferDetailScreen extends StatefulWidget {
  const OfferDetailScreen({
    super.key,
    required this.offerId,
    required this.isDraftOffer,
    this.vendorId,
    this.bankId,
    this.propertyId,
    this.isForVendor,
    this.isFromVendor
  });

  final String offerId;
  final String isDraftOffer;
  final String? vendorId;
  final String? bankId;
  final String? propertyId;
  final String? isForVendor;
  final String? isFromVendor;

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen>
    with AppBarMixin {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final PagingController<int, BankUser> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    if (widget.offerId.isEmpty) {
      debugPrint('Error: offerId is empty! Cannot fetch offer details.');
      return;
    }

    context
        .read<OfferDetailCubit>()
        .getData(widget.offerId, widget.isDraftOffer, context);

    // Ensure bank offers are loaded when navigating from Bank (lblBank)
    if ((widget.bankId != null && widget.bankId!.isNotEmpty)) {
      final propertyId = widget.propertyId ?? "";
      // Load banks list for the property via OfferDetailCubit to use in this screen
      context.read<OfferDetailCubit>().getBankOfferList(propertyId: propertyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        requireLeading: true,
        title: appStrings(context).lblOffers,
      ),
      bottomNavigationBar: _buildBottomButton(context),
      body: BlocConsumer<OfferDetailCubit, OfferDetailState>(
        listener: buildBlocListener,
        builder: (context, state) {
          final OfferDetailCubit cubit = context.read<OfferDetailCubit>();
          final bool isBankFlow = widget.bankId?.isNotEmpty == true;
          final BankOffers? bankOffer = (() {
            if (!isBankFlow) return null;
            final banks = cubit.banksForProperty;
            final allOffers = <BankOffers>[];
            for (final bank in banks) {
              if (bank.offers != null) {
                allOffers.addAll(bank.offers!);
              }
            }
            for (final offer in allOffers) {
              if (offer.sId == widget.offerId) {
                return offer;
              }
            }
            return null;
          })();

          final String title = isBankFlow
              ? (bankOffer?.title ?? "")
              : (cubit.detailData.title ?? "");
          final String description = isBankFlow
              ? (bankOffer?.offerDescription ?? "")
              : (cubit.detailData.description ?? "");
          final String rejectionReason = isBankFlow
              ? ""
              : (cubit.detailData.reqDenyReasons ?? "");
          final List<String> offerImages = isBankFlow
              ? ((bankOffer?.image != null && bankOffer!.image!.isNotEmpty)
                  ? [bankOffer.image!]
                  : <String>[])
              : Utils.getAllImageFiles(cubit.detailData.documents ?? []);

          final List<String> offerBankImages = isBankFlow
              ? ((bankOffer?.image != null && bankOffer!.image!.isNotEmpty)
                  ? [bankOffer.image!]
                  : <String>[])
              : Utils.getAllImageFiles(cubit.detailData.documents ?? []);

          final List<String> offerDocFiles = isBankFlow
              ? <String>[]
              : Utils.getAllDocFiles(cubit.detailData.documents ?? []);
          final String? priceLabel = !isBankFlow
              ? _formatPrice(
            cubit.detailData.price?.amount,
            cubit.detailData.price?.currencySymbol,
          )
              : null;
          final String companyLogo = !isBankFlow
              ? ((cubit.detailData.companyLogo?.isNotEmpty == true)
              ? cubit.detailData.companyLogo!
              : cubit.companyLogo)
              : "";

          final bool isLoading = state is OfferDetailLoading || state is OfferDetailInitial;

          if (isBankFlow && bankOffer == null) {
            if (isLoading) {
              return Skeletonizer(
                enabled: true,
                child: UIComponent.getSkeletonOfferDetail(),
              );
            } else {
              return Center(
                child: Text(appStrings(context).emptyOffersList),
              );
            }
          }

          return Skeletonizer(
            enabled: isLoading,
            child: isLoading
                ? UIComponent.getSkeletonOfferDetail()
                : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                if (widget.isForVendor == "true")...[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 320.0,
                    pinned: false,
                    flexibleSpace: _buildImageSlider(
                      offerImages: offerImages,
                      companyLogo: companyLogo,
                    ),
                  ),
                ]else...[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 320.0,
                    pinned: false,
                    flexibleSpace: _buildImageSlider(
                      offerImages: offerBankImages,
                      companyLogo: companyLogo,
                    ),
                  ),
                ]
              ],
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ),
                        16.horizontalSpace,
                        CommonButton(
                          horizontalPadding: 12,
                          isDynamicWidth: true,
                          onTap: () {},
                          buttonTextColor: Theme.of(context).cardColor,
                          buttonBgColor: Theme.of(context).primaryColor,
                          title: priceLabel ?? "",
                          isBorderRequired: false,
                          isGradientColor: false,
                        ).hideIf(priceLabel == null || priceLabel!.isEmpty),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(12)),
                            color: AppColors.greyF8.adaptiveColor(context,
                                lightModeColor: AppColors.greyF8,
                                darkModeColor: AppColors.black2E),
                          ),
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 14.0,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                appStrings(context).rejectionReason,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.red33),
                              ),
                              8.verticalSpace,
                              ReadMoreText(
                                rejectionReason,
                                trimMode: TrimMode.Line,
                                trimLines: 3,
                                locale: Locale(cubit.selectedLanguage),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black3D
                                        .adaptiveColor(context,
                                        lightModeColor:
                                        AppColors.black3D,
                                        darkModeColor:
                                        AppColors.greyB0)),
                                trimCollapsedText:
                                appStrings(context).readMore,
                                trimExpandedText:
                                appStrings(context).readLess,
                                lessStyle: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black3D
                                        .adaptiveColor(context,
                                        lightModeColor:
                                        AppColors.black3D,
                                        darkModeColor:
                                        AppColors.greyB0)),
                                moreStyle: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black3D
                                        .adaptiveColor(context,
                                        lightModeColor:
                                        AppColors.black3D,
                                        darkModeColor:
                                        AppColors.greyB0)),
                              ),
                            ],
                          ),
                        ),
                        14.verticalSpace,
                      ],
                    ).hideIf(rejectionReason.isEmpty),
                    if (description.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black3D
                                        .adaptiveColor(context,
                                        lightModeColor:
                                        AppColors.black3D,
                                        darkModeColor:
                                        AppColors.greyB0),
                                  ),
                                ),
                                20.verticalSpace,
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      appStrings(context).lblDocuments,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .primaryColor),
                                    ),
                                    UIComponent.customInkWellWidget(
                                      onTap: () {
                                        if (offerDocFiles.isEmpty) {
                                          return;
                                        }
                                        UIComponent.showCustomBottomSheet(
                                            horizontalPadding: 0,
                                            context: context,
                                            builder: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  appStrings(context)
                                                      .lblDocuments,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(
                                                      fontWeight:
                                                      FontWeight
                                                          .w700),
                                                ),
                                                24.verticalSpace,
                                                if (offerDocFiles
                                                    .isNotEmpty)
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                    const ClampingScrollPhysics(),
                                                    itemCount:
                                                    offerDocFiles
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final option =
                                                      offerDocFiles[
                                                      index];

                                                      return Container(
                                                        margin:
                                                        const EdgeInsetsDirectional
                                                            .symmetric(
                                                            horizontal:
                                                            16),
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              16),
                                                          color: AppColors.greyF5.adaptiveColor(
                                                              context,
                                                              lightModeColor:
                                                              AppColors
                                                                  .greyF5,
                                                              darkModeColor:
                                                              AppColors
                                                                  .black14),
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
                                                              Navigator.pop(
                                                                  context);
                                                              await Utils.launchURL(
                                                                  url:
                                                                  option);
                                                            }),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext
                                                    context,
                                                        int index) {
                                                      return 12
                                                          .verticalSpace;
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
                                            ?.copyWith(
                                            fontWeight:
                                            FontWeight.w500,
                                            color: Theme.of(context)
                                                .highlightColor),
                                      ).showIf(offerDocFiles.isNotEmpty &&
                                          offerDocFiles.length > 3),
                                    ),
                                  ],
                                ).showIf(offerDocFiles.isNotEmpty),
                                8
                                    .verticalSpace
                                    .showIf(offerDocFiles.isNotEmpty),
                                Skeleton.unite(
                                    child: Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: offerDocFiles
                                          .take(3)
                                          .map<Widget>((docData) {
                                        return UIComponent
                                            .customInkWellWidget(
                                            onTap: () async {
                                              await Utils.launchURL(
                                                  url: docData);
                                            },
                                            child: UIComponent
                                                .dynamicIconRowAndText(
                                              context: context,
                                              svgPath: docData
                                                  .endsWith(".pdf")
                                                  ? SVGAssets.pdfIcon
                                                  : docData.endsWith(
                                                  ".txt")
                                                  ? SVGAssets.textIcon
                                                  : SVGAssets.docIcon,
                                              text: StringUtils
                                                  .extractFileNameWithExtension(
                                                  docData),
                                              // Display the value or fallback text
                                              backgroundColor: AppColors
                                                  .colorBgPrimary
                                                  .adaptiveColor(
                                                context,
                                                lightModeColor: AppColors
                                                    .colorBgPrimary,
                                                darkModeColor:
                                                AppColors.black2E,
                                              ),
                                              textColor: AppColors
                                                  .colorPrimary
                                                  .adaptiveColor(
                                                context,
                                                lightModeColor: AppColors
                                                    .colorPrimary,
                                                darkModeColor:
                                                AppColors.white,
                                              ),
                                            ));
                                      }).toList(),
                                    )).showIf(offerDocFiles.isNotEmpty),
                              ],
                            ),
                          ),
                        ),
                      ),
                    // 10.verticalSpace,
                    // Add bottom padding to prevent content from being hidden behind the button
                    // SizedBox(
                    //   height: (widget.vendorId != null &&
                    //       widget.vendorId!.isNotEmpty) ||
                    //       (widget.bankId != null &&
                    //           widget.bankId!.isNotEmpty)
                    //       ? 80
                    //       : 20,
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build bottom button - shows either "View Vendor Details" or "View Bank Details"
  Widget? _buildBottomButton(BuildContext context) {
    if(widget.isFromVendor == "true"){
      return const SizedBox();
    }
    if (widget.vendorId != null && widget.vendorId!.isNotEmpty) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CommonButton(
            onTap: () {
              if (widget.isForVendor == "true") {
                final service = GetIt.I<PropertyVendorFinanceService>();
                final String vendorId = widget.vendorId ?? "";
                service.setVendorId(vendorId);
                debugPrint(
                    'Navigating to vendor details screen with vendorId: $vendorId');
                context.pushNamed(
                  Routes.kVendorDetailScreen,
                  extra: vendorId,
                  queryParameters: {
                    RouteArguments.isFromFinanceReq: "false",
                  },
                );
              } else {
                debugPrint('Navigating to bank details screen with bankId: ${widget.bankId}');
                context.pushNamed(
                  Routes.kBankDetailsScreen,
                  pathParameters: {
                    RouteArguments.propertyId: widget.propertyId ?? "0",
                    RouteArguments.vendorId: widget.vendorId ?? "0",
                    RouteArguments.isForVendor: widget.isForVendor ?? "false",
                  },
                  extra: widget.bankId ?? "",
                );
              }
            },
            title: widget.isForVendor == "false"
                ? "View Bank Details"
                : "View Vendor's Details",
            buttonBgColor: AppColors.colorPrimary,
            buttonTextColor: AppColors.white,
            isGradientColor: false,
            height: 50,
          ),
        ),
      );
    }

    // Show "View Bank Details" button if bankId is available
    if (widget.bankId != null && widget.bankId!.isNotEmpty) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CommonButton(
            onTap: () {
              debugPrint(
                  'Navigating to bank details screen with bankId: ${widget.bankId}');
              context.pushNamed(
                Routes.kBankDetailsScreen,
                pathParameters: {
                  RouteArguments.propertyId: widget.propertyId ?? "0",
                  RouteArguments.vendorId: widget.vendorId ?? "0",
                  RouteArguments.isForVendor: widget.isForVendor ?? "false",
                },
                extra: widget.bankId,
              );
            },
            title: widget.isForVendor == "false"
                ? "View Bank Details"
                : "View Vendor's Details",
            buttonBgColor: AppColors.colorPrimary,
            buttonTextColor: AppColors.white,
            isGradientColor: false,
            height: 50,
          ),
        ),
      );
    }

    return Container();
  }

  String? _formatPrice(dynamic amount, String? currencySymbol) {
    if (amount == null) return null;
    num? numericAmount;
    if (amount is num) {
      numericAmount = amount;
    } else if (amount is String) {
      final trimmed = amount.trim();
      if (trimmed.isEmpty) return null;
      try {
        numericAmount = num.parse(trimmed);
      } catch (_) {
        return null;
      }
    } else {
      return null;
    }

    try {
      return numericAmount.formatCurrency(
        showSymbol: true,
        currencySymbol: currencySymbol ?? "",
      );
    } catch (_) {
      return null;
    }
  }

  Widget _buildImageSlider(
      {required List<String> offerImages, required String companyLogo}) {
    return Stack(
      children: [
        offerImages.isNotEmpty
            ? PageView.builder(
          key: ValueKey<String>(offerImages.join(',')),
          controller: _pageController,
          itemCount: offerImages.length,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final imageUrl = offerImages[index] ?? "";
            return AspectRatio(
              aspectRatio: 1,
              child: UIComponent.customInkWellWidget(
                onTap: () {
                  context.pushNamed(
                    Routes.kCarouselFullScreen,
                    pathParameters: {
                      RouteArguments.index: index.toString(),
                    },
                    extra: offerImages,
                  );
                },
                child: UIComponent.cachedNetworkImageWidget(
                    imageUrl: imageUrl),
              ),
            );
          },
        )
            : companyLogo.isNotEmpty
            ? UIComponent.customInkWellWidget(
          onTap: () {
            context.pushNamed(
              Routes.kCarouselFullScreen,
              pathParameters: {
                RouteArguments.index: "0",
              },
              extra: [companyLogo],
            );
          },
          child: SizedBox.expand(
            // Ensures the image fills all available space
            child: UIComponent.cachedNetworkImageWidget(
              imageUrl: companyLogo,
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SvgPicture.asset(
            AppAssets.imgNotFound,
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
              offerImages.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPageIndex == index ? 12 : 8,
                height: _currentPageIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPageIndex == index
                      ? AppColors.colorPrimary
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void buildBlocListener(BuildContext context, OfferDetailState state) {
    if (state is OfferDetailFailure) {
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
