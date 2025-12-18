import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/home/cubit/home_cubit.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/debouncer.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../banks_list/cubit/banks_list_cubit.dart';
import '../banks_list/model/banks_list_response_model.dart';
import 'cubit/bank_details_cubit.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key, required this.sId, required this.propertyId, required this.vendorId, required this.isForVendor});

  final String sId;
  final String propertyId;
  final String vendorId;
  final bool isForVendor;

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen>
    with AppBarMixin {

  final _debouncer = Debouncer(milliseconds: 500);
  final PagingController<int, BankUser> _pagingController =
  PagingController(firstPageKey: 1);
  StreamSubscription<BanksListState>? _banksListSubscription;


  @override
  void initState() {
    super.initState();
    // Direct flow: fetch bank list for property, then load details for first bank
    if (mounted && context.mounted) {
      final banksListCubit = context.read<BanksListCubit>();
      banksListCubit.getData(context);
      _banksListSubscription = banksListCubit.stream.listen((state) {
        if (!mounted) return;
        if (state is BanksListSuccess) {
          if (state.banksList.isNotEmpty) {
            final firstBank = state.banksList.first;
            final bankId = (firstBank.bankId ?? firstBank.sId) ?? "";
            if (bankId.isNotEmpty) {
              context.read<BankDetailsCubit>().getData(
                    context,
                    widget.propertyId,
                    widget.vendorId.isEmpty ? "0" : widget.vendorId,
                    bankId,
                    widget.isForVendor,
                  );
            }
          }
          _banksListSubscription?.cancel();
          _banksListSubscription = null;
        } else if (state is NoBanksListFoundState || state is BanksListError) {
          _banksListSubscription?.cancel();
          _banksListSubscription = null;
        }
      });
      banksListCubit.getBanksList(
        pageKey: 1,
        propertyId: widget.propertyId,
        vendorId: widget.vendorId,
        isForVendor: widget.isForVendor,
      );
    }
  }

  @override
  void dispose() {
    _banksListSubscription?.cancel();
    _banksListSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BankDetailsCubit cubit = context.read<BankDetailsCubit>();
    return BlocConsumer<BankDetailsCubit, BankDetailsState>(
      listener: buildBlocListener,
      builder: (context, state) {
        return Scaffold(
            appBar: buildAppBar(
              context: context,
              requireLeading: true,
              title: appStrings(context).lblBankDetails,
            ),
            body: Skeletonizer(
              enabled: (cubit.bankDetails.sId.toString() == "" ||
                  state is BankDetailsLoading ||
                  state is BankDetailsInitial),
              child: cubit.bankDetails.sId.toString() == "" ||
                      state is BankDetailsLoading
                  ? Skeletonizer(
                      enabled: true, child: UIComponent.getBankDetailSkeleton())
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cubit.bankDetails.companyName ?? "",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.black14
                                                    .adaptiveColor(context,
                                                        lightModeColor:
                                                            AppColors.black14,
                                                        darkModeColor:
                                                            AppColors.white)),
                                      ),
                                    ),
                                    Container(
                                        height: 58,
                                        width: 58,
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                start: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color:
                                                AppColors.greyE9.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.greyE9,
                                              darkModeColor: AppColors.black2E,
                                            ),
                                            width: 1,
                                          ), // Round
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: UIComponent
                                              .cachedNetworkImageWidget(
                                                  imageUrl: cubit
                                                      .bankDetails.companyLogo,
                                                  fit: BoxFit.contain),
                                        )),
                                  ],
                                ),
                                20.verticalSpace,
                                // Container(
                                //   width: double.infinity,
                                //   decoration: BoxDecoration(
                                //     borderRadius: const BorderRadius.all(
                                //         Radius.circular(12)),
                                //     color: AppColors.greyF8.adaptiveColor(
                                //         context,
                                //         lightModeColor: AppColors.greyF8,
                                //         darkModeColor: AppColors.black2E),
                                //   ),
                                //   padding:
                                //       const EdgeInsetsDirectional.symmetric(
                                //     horizontal: 14.0,
                                //     vertical: 16,
                                //   ),
                                //   child: Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         appStrings(context).lblOffers,
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .titleMedium
                                //             ?.copyWith(
                                //                 fontWeight: FontWeight.w700,
                                //                 color: Theme.of(context)
                                //                     .primaryColor),
                                //       ),
                                //       8.verticalSpace,
                                //       ListView.builder(
                                //         shrinkWrap: true,
                                //         physics:
                                //             const NeverScrollableScrollPhysics(),
                                //         itemCount: cubit.offers!.length,
                                //         itemBuilder: (context, index) {
                                //           final offer = cubit.offers![index];
                                //           return Padding(
                                //             padding: const EdgeInsets.only(
                                //                 bottom: 8.0),
                                //             child: ExpansionTile(
                                //               backgroundColor: AppColors.greyF8
                                //                   .adaptiveColor(context,
                                //                       lightModeColor:
                                //                           AppColors.greyF8,
                                //                       darkModeColor:
                                //                           AppColors.black2E),
                                //               collapsedBackgroundColor: AppColors
                                //                   .greyF8
                                //                   .adaptiveColor(context,
                                //                       lightModeColor:
                                //                           AppColors.greyF8,
                                //                       darkModeColor:
                                //                           AppColors.black2E),
                                //               collapsedShape:
                                //                   ContinuousRectangleBorder(
                                //                       side: BorderSide(
                                //                           color: AppColors
                                //                               .greyE9
                                //                               .adaptiveColor(
                                //                                   context,
                                //                                   lightModeColor:
                                //                                       AppColors
                                //                                           .greyE9,
                                //                                   darkModeColor:
                                //                                       AppColors
                                //                                           .black3D),
                                //                           width: 2),
                                //                       borderRadius:
                                //                           const BorderRadius
                                //                               .all(
                                //                               Radius.circular(
                                //                                   24))),
                                //               shape: ContinuousRectangleBorder(
                                //                   side: BorderSide(
                                //                       color: AppColors.greyE9
                                //                           .adaptiveColor(
                                //                               context,
                                //                               lightModeColor:
                                //                                   AppColors
                                //                                       .greyE9,
                                //                               darkModeColor:
                                //                                   AppColors
                                //                                       .black3D),
                                //                       width: 2),
                                //                   borderRadius:
                                //                       const BorderRadius.all(
                                //                           Radius.circular(24))),
                                //               title: Text(
                                //                 offer.title ?? "",
                                //                 style: Theme.of(context)
                                //                     .textTheme
                                //                     .titleSmall
                                //                     ?.copyWith(
                                //                       fontWeight:
                                //                           FontWeight.w500,
                                //                       color: AppColors.black14
                                //                           .adaptiveColor(
                                //                         context,
                                //                         lightModeColor:
                                //                             AppColors.black14,
                                //                         darkModeColor:
                                //                             AppColors.greyB0,
                                //                       ),
                                //                     ),
                                //               ),
                                //               initiallyExpanded: false,
                                //               dense: true,
                                //               iconColor: Theme.of(context)
                                //                   .primaryColor,
                                //               children: [
                                //                 Align(
                                //                   alignment:
                                //                       AlignmentDirectional
                                //                           .topStart,
                                //                   child: Padding(
                                //                     padding:
                                //                         const EdgeInsetsDirectional
                                //                             .only(
                                //                       start: 18.0,
                                //                       end: 18.0,
                                //                       bottom: 12,
                                //                     ),
                                //                     child: offer.offerDescription !=
                                //                                 null &&
                                //                             offer
                                //                                 .offerDescription!
                                //                                 .isNotEmpty
                                //                         ? Text(
                                //                             offer.offerDescription ??
                                //                                 "",
                                //                             style:
                                //                                 Theme.of(
                                //                                         context)
                                //                                     .textTheme
                                //                                     .titleSmall
                                //                                     ?.copyWith(
                                //                                       fontWeight:
                                //                                           FontWeight
                                //                                               .w400,
                                //                                       color: AppColors
                                //                                           .black3D
                                //                                           .adaptiveColor(
                                //                                         context,
                                //                                         lightModeColor:
                                //                                             AppColors.black3D,
                                //                                         darkModeColor:
                                //                                             AppColors.greyB0,
                                //                                       ),
                                //                                     ),
                                //                           )
                                //                         : const SizedBox
                                //                             .shrink(),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           );
                                //         },
                                //       ).hideIf(cubit.offers == null ||
                                //           cubit.offers == []),
                                //       Visibility(
                                //           visible: cubit.offers == null ||
                                //               (cubit.offers != null &&
                                //                   cubit.offers!.isEmpty),
                                //           child: Center(
                                //             child: Text(
                                //               appStrings(context).noOffers,
                                //               style: Theme.of(context)
                                //                   .textTheme
                                //                   .titleSmall
                                //                   ?.copyWith(
                                //                     fontWeight: FontWeight.w400,
                                //                     color: AppColors.black3D
                                //                         .adaptiveColor(
                                //                       context,
                                //                       lightModeColor:
                                //                           AppColors.black3D,
                                //                       darkModeColor:
                                //                           AppColors.greyB0,
                                //                     ),
                                //                   ),
                                //             ),
                                //           )),
                                //     ],
                                //   ),
                                // ),
                                // 20.verticalSpace,
                                ExpansionTile(
                                  backgroundColor: AppColors.greyF8
                                      .adaptiveColor(context,
                                          lightModeColor: AppColors.greyF8,
                                          darkModeColor: AppColors.black2E),
                                  collapsedBackgroundColor: AppColors.greyF8
                                      .adaptiveColor(context,
                                          lightModeColor: AppColors.greyF8,
                                          darkModeColor: AppColors.black2E),
                                  collapsedShape:
                                      const ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24))),
                                  shape: const ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24))),
                                  title: Text(
                                    appStrings(context).lblContactDetails,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                  initiallyExpanded: true,
                                  iconColor: Theme.of(context).primaryColor,
                                  dense: true,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                          start: 18.0,
                                          end: 18.0,
                                          bottom: 12,
                                        ),
                                        child: cubit.bankDetails
                                                        .banksAlternativeContact !=
                                                    null &&
                                                cubit
                                                    .bankDetails
                                                    .banksAlternativeContact!
                                                    .isNotEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: cubit
                                                        .bankDetails
                                                        .banksAlternativeContact
                                                        ?.length ??
                                                    0,
                                                itemBuilder: (context, index) {
                                                  final contact = cubit
                                                          .bankDetails
                                                          .banksAlternativeContact?[
                                                      index];
                                                  if (contact == null) {
                                                    return const SizedBox();
                                                  }

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .only(
                                                            start: 4.0,
                                                            end: 4.0,
                                                            bottom: 12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${contact.name}",
                                                            style:
                                                                Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleSmall
                                                                    ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: AppColors
                                                                          .black3D
                                                                          .adaptiveColor(
                                                                        context,
                                                                        lightModeColor:
                                                                            AppColors.black3D,
                                                                        darkModeColor:
                                                                            AppColors.greyB0,
                                                                      ),
                                                                    ),
                                                          ),
                                                        ),
                                                        UIComponent
                                                            .customInkWellWidget(
                                                          onTap: () {
                                                            UIComponent
                                                                .showCustomBottomSheet(
                                                              horizontalPadding:
                                                                  0,
                                                              context: context,
                                                              builder: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    appStrings(
                                                                            context)
                                                                        .lblContactNow,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .labelLarge
                                                                        ?.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                  ),
                                                                  24.verticalSpace,
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const ClampingScrollPhysics(),
                                                                    itemCount: cubit
                                                                        .contactNowOptions
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            optionIndex) {
                                                                      final option =
                                                                          cubit.contactNowOptions[
                                                                              optionIndex];
                                                                      final isWhatsApp = option
                                                                              .title
                                                                              .toLowerCase() ==
                                                                          "whatsapp";

                                                                      return Container(
                                                                        margin: const EdgeInsetsDirectional
                                                                            .symmetric(
                                                                            horizontal:
                                                                                16),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16),
                                                                          gradient: isWhatsApp
                                                                              ? AppColors.primaryGradient
                                                                              : null,
                                                                          color: !isWhatsApp
                                                                              ? AppColors.greyF5
                                                                              : null,
                                                                        ),
                                                                        child:
                                                                            ListTile(
                                                                          leading:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(8),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: isWhatsApp ? AppColors.white : AppColors.colorPrimary.withOpacity(0.10),
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            child:
                                                                                option.icon.toSvg(
                                                                              context: context,
                                                                              color: AppColors.colorPrimary,
                                                                            ),
                                                                          ),
                                                                          title:
                                                                              Text(
                                                                            option.title,
                                                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                                                  color: isWhatsApp ? AppColors.white : AppColors.black,
                                                                                ),
                                                                          ),
                                                                          trailing: SVGAssets
                                                                              .arrowRightIcon
                                                                              .toSvg(
                                                                            context:
                                                                                context,
                                                                            color: isWhatsApp
                                                                                ? AppColors.white
                                                                                : AppColors.colorPrimary,
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            switch (optionIndex) {
                                                                              case 0:
                                                                                final phoneCode = contact.phoneCode;
                                                                                final contactNumber = contact.contactNumber;
                                                                                final formattedPhoneNumber = '+$phoneCode$contactNumber';
                                                                                Utils.makePhoneCall(
                                                                                  context: context,
                                                                                  phoneNumber: formattedPhoneNumber,
                                                                                );
                                                                                debugPrint('Direct Call selected');
                                                                                break;

                                                                              case 1:
                                                                                final phoneCode = contact.phoneCode;
                                                                                final contactNumber = contact.contactNumber;
                                                                                final formattedPhoneNumber = '+$phoneCode$contactNumber';
                                                                                Utils.makeWhatsAppCall(
                                                                                  context: context,
                                                                                  phoneNumber: formattedPhoneNumber,
                                                                                );
                                                                                debugPrint('WhatsApp selected');
                                                                                break;

                                                                              case 2:
                                                                                final phoneCode = contact.phoneCode;
                                                                                final contactNumber = contact.contactNumber;
                                                                                final formattedPhoneNumber = '+$phoneCode$contactNumber';
                                                                                Utils.makeSms(
                                                                                  context: context,
                                                                                  phoneNumber: formattedPhoneNumber,
                                                                                );
                                                                                debugPrint('SMS selected');
                                                                                break;

                                                                              default:
                                                                                debugPrint('Other option selected');
                                                                                break;
                                                                            }

                                                                            Navigator.pop(context);
                                                                            debugPrint('${option.title} selected');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return 12
                                                                          .verticalSpace;
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            "+${contact.phoneCode} ${contact.contactNumber}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall
                                                                ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .highlightColor,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    )
                                  ],
                                ).hideIf(
                                    cubit.bankDetails.banksAlternativeContact ==
                                            null ||
                                        (cubit.bankDetails
                                                    .banksAlternativeContact !=
                                                null &&
                                            cubit
                                                .bankDetails
                                                .banksAlternativeContact!
                                                .isEmpty)),
                                Visibility(
                                  visible: cubit.bankDetails
                                              .banksAlternativeContact ==
                                          null ||
                                      (cubit.bankDetails
                                                  .banksAlternativeContact !=
                                              null &&
                                          cubit
                                              .bankDetails
                                              .banksAlternativeContact!
                                              .isEmpty),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      color: AppColors.greyF8.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.greyF8,
                                          darkModeColor: AppColors.black2E),
                                    ),
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                      horizontal: 14.0,
                                      vertical: 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appStrings(context).lblContactDetails,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        8.verticalSpace,
                                        Center(
                                          child: Text(
                                            appStrings(context)
                                                .noContactDetails,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.black3D
                                                      .adaptiveColor(
                                                    context,
                                                    lightModeColor:
                                                        AppColors.black3D,
                                                    darkModeColor:
                                                        AppColors.greyB0,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                24.verticalSpace,
                                UIComponent.customInkWellWidget(
                                  onTap: () {
                                    setState(() {
                                      cubit.isSelected = !cubit.isSelected;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      cubit.isSelected
                                          ? SVGAssets.checkboxEnableIcon.toSvg(
                                              height: 18,
                                              width: 18,
                                              context: context)
                                          : SVGAssets.checkboxDisableIcon.toSvg(
                                              height: 18,
                                              width: 18,
                                              context: context),
                                      10.horizontalSpace,
                                      Flexible(
                                        child: UIComponent.customInkWellWidget(
                                          onTap: () async {
                                            context.pushNamed(
                                              Routes.kHTMLViewer,
                                              extra: cubit.bankDetails.bankterm
                                                      ?.content?.en ??
                                                  "",
                                            );
                                          },
                                          child: Text(
                                              appStrings(context)
                                                  .termsAndConditions,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color: AppColors.black14
                                                        .forLightMode(context),
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor: AppColors
                                                        .black14
                                                        .forLightMode(context),
                                                  )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            bottomNavigationBar:
                BlocBuilder<BankDetailsCubit, BankDetailsState>(
              builder: (context, state) {
                BankDetailsCubit cubit = context.read<BankDetailsCubit>();
                return UIComponent.customInkWellWidget(
                  onTap: () async {
                    BankDetailsCubit cubit = context.read<BankDetailsCubit>();

                    if (validate(context)) {
                      await cubit.sendFinanceRequest(
                          propertyId: widget.propertyId ?? "",
                          bankId: cubit.bankDetails.sId ?? "",
                          context: context,);
                    }
                  },
                  //   cubit.isSelected
                  // ? () async {
                  //     BankDetailsCubit cubit =
                  //         context.read<BankDetailsCubit>();
                  //
                  //     if (validate(context)) {
                  //       await cubit.sendFinanceRequest(
                  //           propertyId: widget.propertyId ?? "",
                  //           bankId: cubit.bankDetails.sId ?? "",
                  //           context: context,
                  //           vendorId: widget.vendorId);
                  //     }
                  //
                  //   }
                  // : () {
                  //     Utils.snackBar(
                  //         context: context,
                  //         message: appStrings(context).tAndCValidation);
                  //   },
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                        gradient:
                            cubit.isSelected ? AppColors.primaryGradient : null,
                        color: cubit.isSelected ? null : AppColors.grey88),
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      appStrings(context).btnSendRequest,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: cubit.isSelected
                                                  ? AppColors.colorPrimary
                                                  : AppColors.grey88),
                                    ),
                                  ],
                                ),
                                UIComponent.customRTLIcon(
                                    child: SVGAssets.arrowRightIcon.toSvg(
                                        context: context,
                                        color: AppColors.colorPrimary),
                                    context: context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
      },
    );
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, BankDetailsState state) async {
    if (state is BankDetailsLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is BankDetailsSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is BankViewCountSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is AddFinanceRequestSuccess) {
      HomeCubit homeCubit = context.read<HomeCubit>();
      homeCubit.resetPropertyList();
      homeCubit.searchText = context.read<HomeCubit>().searchText;
      homeCubit.refreshData();
      OverlayLoadingProgress.stop();

      if (!context.mounted) return;
      Utils.snackBar(context: context, message: state.model.message ?? "");
      context.goNamed(Routes.kDashboard);
    } else if (state is BankDetailsError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }

  /// Method validation
  ///
  bool validate(BuildContext context) {
    BankDetailsCubit cubit = context.read<BankDetailsCubit>();

    if (!cubit.isSelected) {
      Utils.showErrorMessage(
          context: context,
          message: appStrings(context).termsAgreementErrorMsg);
      return false;
    }
    return true;
  }
}
