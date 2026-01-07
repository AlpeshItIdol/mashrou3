import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/model/vendor_offer_analytics/vendor_offer_analytics_response_model.dart';
import 'package:mashrou3/app/ui/screens/vendor_offer_analytics/cubit/vendor_offer_analytics_cubit.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';

class VendorOfferAnalyticsScreen extends StatefulWidget {
  const VendorOfferAnalyticsScreen({super.key});

  @override
  State<VendorOfferAnalyticsScreen> createState() => _VendorOfferAnalyticsScreenState();
}

class _VendorOfferAnalyticsScreenState extends State<VendorOfferAnalyticsScreen> with AppBarMixin {
  final PagingController<int, VendorOfferAnalyticsOffer> _pagingController = PagingController(firstPageKey: 1);
  String? vendorId;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    vendorId = await GetIt.I<AppPreferences>().getUserID();
    if (mounted && vendorId != null && vendorId!.isNotEmpty) {
      final cubit = context.read<VendorOfferAnalyticsCubit>();
      _pagingController.addPageRequestListener((pageKey) {
        cubit.getVendorOfferAnalytics(page: pageKey, vendorId: vendorId!);
      });
      // Trigger the first page request immediately
      if (mounted) {
        setState(() {});
        // Directly trigger the first page request
        cubit.getVendorOfferAnalytics(page: 1, vendorId: vendorId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VendorOfferAnalyticsCubit, VendorOfferAnalyticsState>(
      listener: _buildBlocListener,
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(
            context: context,
            requireLeading: true,
            title: "Vendor Offer Analytics",
          ),
          body: vendorId == null || vendorId!.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildPaginationControl(),
                    Expanded(
                      child: _buildTable(),
                    ),

                  ],
                ),
        );
      },
    );
  }

  Widget _buildTable() {
    if (_pagingController.itemList == null || _pagingController.itemList!.isEmpty) {
      if (_pagingController.value.status == PagingStatus.firstPageError) {
        return Center(
          child: Text(
            'Error loading data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }

    final offers = _pagingController.itemList!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            AppColors.colorPrimary.withOpacity(0.1),
          ),
          columnSpacing: 20,
          dataRowMinHeight: 60,
          dataRowMaxHeight: 100,
          columns: const [
            DataColumn(label: Text('COMPANY NAME')),
            DataColumn(label: Text('OFFER TITLE')),
            DataColumn(label: Text('OFFER CATEGORY\n(VENDOR CATEGORY)')),
            DataColumn(label: Text('PRICE')),
            DataColumn(label: Text('PROPERTY WITH\nOFFERS')),
            DataColumn(label: Text('OFFER REQUEST\n(FINANCE)')),
            DataColumn(label: Text('OFFER VIEW')),
            DataColumn(label: Text('OFFER UNIQUE\nVIEW')),
          ],
          rows: offers.map((offer) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (offer.companyLogo != null && offer.companyLogo!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: offer.companyLogo ?? "",
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.colorSecondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.business, size: 20),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.colorSecondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.business, size: 20),
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          offer.companyName ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    offer.offerTitle ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(
                    offer.vendorCategory ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(
                    "${offer.price?.amount ?? ""} ${offer.price?.currencyCode ?? ""}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(
                    "${offer.analyticsData?.propertyOfferCount ?? 0}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cash: ${offer.vendorCashCount ?? 0}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "Bank: ${offer.vendorFinanceCount ?? 0}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    "${offer.offerAppliedCount ?? 0}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(
                    "${offer.offerAppliedCount ?? 0}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaginationControl() {
    final cubit = context.read<VendorOfferAnalyticsCubit>();
    final itemsPerPageOptions = [10, 25, 50, 75, 100];
    const selectedColor = Color.fromRGBO(62, 113, 119, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<int>(
            offset: const Offset(0, 40),
            color: AppColors.white.adaptiveColor(
              context,
              lightModeColor: AppColors.white,
              darkModeColor: AppColors.black2E,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (value) {
              if (value != itemsPerPage) {
                setState(() {
                  itemsPerPage = value;
                });
                cubit.updateItemsPerPage(value);
                _pagingController.refresh();
              }
            },
            itemBuilder: (context) {
              return itemsPerPageOptions.map((value) {
                final isSelected = value == itemsPerPage;

                return PopupMenuItem<int>(
                  value: value,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : Colors.transparent,
                    ),
                    child: Text(
                      "$value",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isSelected ? Colors.white : AppColors.black14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                    ),
                  ),
                );
              }).toList();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.greyE8.adaptiveColor(
                    context,
                    lightModeColor: AppColors.greyE8,
                    darkModeColor: AppColors.black2E,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$itemsPerPage",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: selectedColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_drop_down, color: selectedColor, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buildBlocListener(BuildContext context, VendorOfferAnalyticsState state) async {
    if (state is VendorOfferAnalyticsSuccess) {
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.offers);
      } else {
        _pagingController.appendPage(state.offers, state.currentPage + 1);
      }
    } else if (state is NoVendorOfferAnalyticsFound) {
      _pagingController.appendLastPage([]);
    } else if (state is VendorOfferAnalyticsError) {
      _pagingController.error = state.errorMessage;
      if (mounted) {
        Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage,
        );
      }
    } else if (state is VendorOfferAnalyticsRefresh) {
      _pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

