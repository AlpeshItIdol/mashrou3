// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mashrou3/app/ui/screens/banks_offer/cubit/banks_offer_list_cubit.dart';
// import 'package:mashrou3/utils/extensions.dart';
//
// import '../../../../../config/resources/app_strings.dart';
//
// import '../../../../../config/resources/app_values.dart';
// import '../../../../../config/resources/app_colors.dart';
// import '../../../../config/resources/app_assets.dart';
// import '../../../../utils/app_localization.dart';
// import '../../../../utils/input_formatters.dart';
// import '../../../../utils/ui_components.dart';
// import '../../custom_widget/text_form_fields/search_text_form_field.dart';
// import '../app_prefereces/cubit/app_preferences_cubit.dart';
// import '../property_details/sub_screens/banks_list/component/banks_list_card.dart';
// class BanksOfferScreen extends StatefulWidget {
//   const BanksOfferScreen({super.key});
//
//   @override
//   State<BanksOfferScreen> createState() => _BanksOfferScreenState();
// }
//
// class _BanksOfferScreenState extends State<BanksOfferScreen> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<BanksOfferListCubit>().refresh();
//     _scrollController.addListener(() {
//       final cubit = context.read<BanksOfferListCubit>();
//       if (_scrollController.position.pixels >=
//               _scrollController.position.maxScrollExtent - 200 &&
//           !cubit.isLoadingMore) {
//         cubit.getBankOffersList(hasMoreData: true);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//   final TextEditingController _controller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(    automaticallyImplyLeading: false,
//         title: const Text('Banks offers'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16.0, vertical: 8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Back button with Arabic localization
//                 Container(
//                   height: 48,
//                   width: 48,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: AppColors.greyE8.adaptiveColor(
//                         context,
//                         lightModeColor: AppColors.greyE8,
//                         darkModeColor: AppColors.black2E,
//                       ),
//                       width: 1,
//                     ),
//                   ),
//                   child: UIComponent.customInkWellWidget(
//                     onTap: () {
//                       if (context.canPop()) {
//                         context.pop();
//                       }
//                     },
//                     child: BlocBuilder<AppPreferencesCubit,
//                         AppPreferencesState>(
//                       builder: (context, state) {
//                         final cubit =
//                         context.watch<AppPreferencesCubit>();
//                         final isArabic = cubit.isArabicSelected;
//                         final arrowIcon = isArabic
//                             ? SVGAssets.arrowRightIcon
//                             : SVGAssets.arrowLeftIcon;
//
//                         return Center(
//                           child: SvgPicture.asset(
//                             arrowIcon,
//                             height: 26,
//                             width: 26,
//                             colorFilter: ColorFilter.mode(
//                               Theme.of(context).focusColor,
//                               BlendMode.srcIn,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 8.horizontalSpace,
//                 Expanded(
//                   child: SearchTextFormField(
//                     controller:_controller,
//                     fieldHint: appStrings(context).textSearch,
//                     onChanged: (value) {
//
//                     },
//                     showSuffixIcon: true,
//                     functionSuffix: () {
//
//                     },
//                     suffixIcon: SVGAssets.searchIcon.toSvg(
//                       context: context,
//                       height: 18,
//                       width: 18,
//                     ),
//                     //     ? SVGAssets.cancelIcon.toSvg(
//                     //   context: context,
//                     //   height: 20,
//                     //   width: 20,
//                     //   color: AppColors.black34,
//                     // )
//                     //     : SVGAssets.searchIcon.toSvg(
//                     //   context: context,
//                     //   height: 18,
//                     //   width: 18,
//                     // ),
//                     onSubmitted: (value) async {
//                       if (value.isEmpty) {
//                         setState(() {
//                           // cubit.showSuffixIcon = false;
//                         });
//                       }
//
//                     },
//                     inputFormatters: [
//                       InputFormatters().emojiRestrictInputFormatter,
//                       // LengthLimitingTextInputFormatter(50),
//                     ],
//                     textInputAction: TextInputAction.search,
//                     keyboardType: TextInputType.text,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ListView.builder(
//              shrinkWrap: true,
//               itemBuilder: (BuildContext context, int index) { return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: BanksListCard(
//                   name: "sbi",
//                   description: "sbi is indias",
//                   city: "Valsad",
//                   country: "Valsad",
//                   imageUrl: "Valsad",
//                   phNo: "992548745",
//                   onTap: () async {
//                   },
//                 ),
//               );},
//               itemCount: 3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//       // BlocConsumer<BanksOfferListCubit, BanksOfferListState>(
//       //   listener: (context, state) {},
//       //   builder: (context, state) {
//       //     if (state is BankOffersListLoading || state is BankOffersRefreshLoading) {
//       //       return const Center(child: CircularProgressIndicator());
//       //     }
//       //     if (state is BankOffersListError) {
//       //       return Center(child: Text(state.message));
//       //     }
//       //     if (state is NoBankOffersFoundState) {
//       //       return Center(child: Text("No data found"));
//       //     }
//       //     if (state is BankOffersListSuccess) {
//       //       final items = state.offers;
//       //       return ListView.separated(
//       //         controller: _scrollController,
//       //         padding: const EdgeInsets.all(16),
//       //         itemCount: items.length,
//       //         separatorBuilder: (_, __) => const SizedBox(height: 12),
//       //         itemBuilder: (context, index) {
//       //           final item = items[index];
//       //           return Container(
//       //             padding: const EdgeInsets.all(16),
//       //             decoration: BoxDecoration(
//       //               color: Theme.of(context).cardColor,
//       //               borderRadius: BorderRadius.circular(12),
//       //               // border: Border.all(color: Colors.grey[300]),
//       //             ),
//       //             child: Column(
//       //               crossAxisAlignment: CrossAxisAlignment.start,
//       //               children: [
//       //                 Text(item.bankName ?? '-', style: Theme.of(context)
//       //                     .textTheme
//       //                     .titleMedium),
//       //                 const SizedBox(height: 4),
//       //                 Text(item.companyName ?? '-', style: Theme.of(context)
//       //                     .textTheme
//       //                     .bodySmall),
//       //                 const SizedBox(height: 8),
//       //                 if ((item.offers ?? []).isNotEmpty)
//       //                   Column(
//       //                     crossAxisAlignment: CrossAxisAlignment.start,
//       //                     children: [
//       //                       Text("Offers", style: Theme.of(context)
//       //                           .textTheme
//       //                           .titleSmall),
//       //                       const SizedBox(height: 4),
//       //                       ...item.offers!.map((o) => Text(o.sId ?? '-')).toList(),
//       //                     ],
//       //                   )
//       //               ],
//       //             ),
//       //           );
//       //         },
//       //       );
//       //     }
//       //     return const SizedBox.shrink();
//       //   },
//       // ),
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/screens/banks_offer/cubit/banks_offer_list_cubit.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../config/resources/app_strings.dart';
import '../../../../../config/resources/app_colors.dart';
import '../../../../config/resources/app_assets.dart';
import '../../../../utils/app_localization.dart';
import '../../../../utils/input_formatters.dart';
import '../../../../utils/ui_components.dart';
import '../../custom_widget/text_form_fields/search_text_form_field.dart';
import '../app_prefereces/cubit/app_preferences_cubit.dart';
import '../property_details/sub_screens/banks_list/component/banks_list_card.dart';

class BanksOfferScreen extends StatefulWidget {
  const BanksOfferScreen({super.key});

  @override
  State<BanksOfferScreen> createState() => _BanksOfferScreenState();
}

class _BanksOfferScreenState extends State<BanksOfferScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BanksOfferListCubit>().refresh();

    // Listener for pagination
    _scrollController.addListener(() {
      final cubit = context.read<BanksOfferListCubit>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !cubit.isLoadingMore) {
        cubit.getBankOffersList(hasMoreData: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppPreferencesCubit>().isArabicSelected;
    final arrowIcon = isArabic
        ? SVGAssets.arrowRightIcon
        : SVGAssets.arrowLeftIcon;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Banks Listing'),
        leadingWidth: 64, // Give enough space for padding + icon
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
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
              child: BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
                builder: (context, state) {
                  final isArabic = context.watch<AppPreferencesCubit>().isArabicSelected;
                  final arrowIcon = isArabic
                      ? SVGAssets.arrowRightIcon
                      : SVGAssets.arrowLeftIcon;
                  return Center(
                    child: SvgPicture.asset(
                      arrowIcon,
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).focusColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   height: 48,
                //   width: 48,
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).cardColor,
                //     borderRadius: BorderRadius.circular(16),
                //     border: Border.all(
                //       color: AppColors.greyE8.adaptiveColor(
                //         context,
                //         lightModeColor: AppColors.greyE8,
                //         darkModeColor: AppColors.black2E,
                //       ),
                //       width: 1,
                //     ),
                //   ),
                //   child: UIComponent.customInkWellWidget(
                //     onTap: () {
                //       if (context.canPop()) {
                //         context.pop();
                //       }
                //     },
                //     child: BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
                //       builder: (context, state) {
                //         final isArabic = context.watch<AppPreferencesCubit>().isArabicSelected;
                //         final arrowIcon = isArabic
                //             ? SVGAssets.arrowRightIcon
                //             : SVGAssets.arrowLeftIcon;
                //         return Center(
                //           child: SvgPicture.asset(
                //             arrowIcon,
                //             height: 26,
                //             width: 26,
                //             colorFilter: ColorFilter.mode(
                //               Theme.of(context).focusColor,
                //               BlendMode.srcIn,
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
                8.horizontalSpace,
                // Expanded(
                //   child: SearchTextFormField(
                //     controller: _controller,
                //     fieldHint: appStrings(context).textSearch,
                //     onChanged: (value) {},
                //     showSuffixIcon: true,
                //     functionSuffix: () {
                //       _controller.clear();
                //       banksOfferCubit.refresh();
                //     },
                //     suffixIcon: SVGAssets.searchIcon.toSvg(
                //       context: context,
                //       height: 18,
                //       width: 18,
                //     ),
                //     onSubmitted: (value) async {
                //       banksOfferCubit.refresh(value);
                //     },
                //     inputFormatters: [
                //       InputFormatters().emojiRestrictInputFormatter,
                //     ],
                //     textInputAction: TextInputAction.search,
                //     keyboardType: TextInputType.text,
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<BanksOfferListCubit, BanksOfferListState>(
              listener: (context, state) {
                if (state is BankOffersListError && !state.isFirstFetch) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is BankOffersListLoading || state is BankOffersRefreshLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BankOffersListError && state.isFirstFetch) {
                  return Center(child: Text(state.message));
                }
                if (state is NoBankOffersFoundState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.account_balance, size: 54, color: Colors.grey),
                          const SizedBox(height: 24),
                          Text(
                            "No bank offers found",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "There are currently no bank offers available.\nPlease check back later.",
                            textAlign: TextAlign.center,
                          ),
                          // Uncomment the below for retry button
                          // const SizedBox(height: 18),
                          // ElevatedButton(
                          //   onPressed: () => context.read<BanksOfferListCubit>().refresh(),
                          //   child: Text('Try Again'),
                          // ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is BankOffersListSuccess) {
                  final offers = state.offers;
                  if (offers.isEmpty) {
                    return Center(child: Text(AppStrings.noDataFound));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: state.hasMoreData ? offers.length + 1 : offers.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= offers.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final item = offers[index];
                      debugPrint("CHECCCKK == $item");
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        // This is the corrected implementation.
                        // Ensure your BanksListCard can handle these potentially empty/default values.
                        child: //Text('test')
                        BanksListCard(
                          name: item?.companyName ?? 'N/A',
                          description: item.bankOfferSummary ?? 'No description available',
                          city: item.bankLocation?.city ?? 'N/A',
                          country: item.bankLocation?.country ?? 'N/A',
                          imageUrl: item.companyLogo ?? '', // Pass an empty string for the URL
                          phNo: (item.banksAlternativeContact != null && item.banksAlternativeContact!.isNotEmpty)
                              ? item.banksAlternativeContact![0].contactNumber ?? 'N/A'
                              : 'N/A',
                          onTap: () async {
                            // Implement navigation or other actions here
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}


