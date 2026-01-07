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
import 'package:mashrou3/utils/ui_components.dart';

class VendorOfferAnalyticsScreen extends StatefulWidget {
  const VendorOfferAnalyticsScreen({super.key});

  @override
  State<VendorOfferAnalyticsScreen> createState() => _VendorOfferAnalyticsScreenState();
}

class _VendorOfferAnalyticsScreenState extends State<VendorOfferAnalyticsScreen> with AppBarMixin {
  final PagingController<int, VendorOfferAnalyticsOffer> _pagingController = PagingController(firstPageKey: 1);
  String? vendorId;
  bool _isListenerSetup = false;
  final Set<int> _loadedPages = <int>{};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    vendorId = await GetIt.I<AppPreferences>().getUserID();
    if (mounted && vendorId != null && vendorId!.isNotEmpty && !_isListenerSetup) {
      _isListenerSetup = true;
      // Set up listener only after vendorId is available
      final cubit = context.read<VendorOfferAnalyticsCubit>();
      _pagingController.addPageRequestListener((pageKey) {
        // Prevent duplicate API calls for the same page
        if (!_loadedPages.contains(pageKey) && vendorId != null && vendorId!.isNotEmpty) {
          // Mark page as loading immediately to prevent duplicate calls
          _loadedPages.add(pageKey);
          cubit.getVendorOfferAnalytics(page: pageKey, vendorId: vendorId!);
        }
      });
      setState(() {});
      // PagedListView will automatically request the first page when it renders
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
            title: appStrings(context).lblVendorOfferAnalytics,
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
    return RefreshIndicator(
      onRefresh: () async {
        if (vendorId != null && vendorId!.isNotEmpty) {
          // Clear loaded pages to allow refresh
          _loadedPages.clear();
          // Trigger paging controller refresh - this will reset and request page 1
          _pagingController.refresh();
          // Wait a moment for the refresh to be processed
          await Future.delayed(const Duration(milliseconds: 100));
        }
      },
      child: PagedListView<int, VendorOfferAnalyticsOffer>.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return 12.verticalSpace;
        },
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<VendorOfferAnalyticsOffer>(
          firstPageProgressIndicatorBuilder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.colorPrimary,
                ),
              ),
            );
          },
          newPageProgressIndicatorBuilder: (context) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.colorPrimary,
                ),
              ),
            );
          },
          itemBuilder: (context, offer, index) {
            return _buildAnalyticsCard(offer);
          },
          noItemsFoundIndicatorBuilder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: UIComponent.noDataWidgetWithInfo(
                  title: "No Analytics Data",
                  info: "No vendor offer analytics data available",
                  context: context,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(VendorOfferAnalyticsOffer offer) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.adaptiveColor(
          context,
          lightModeColor: AppColors.white,
          darkModeColor: AppColors.black2E,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Name with Logo
            Row(
              children: [
                if (offer.companyLogo != null && offer.companyLogo!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: offer.companyLogo ?? "",
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.colorSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.business, size: 24),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.colorSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.business, size: 24),
                  ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.companyName ?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).highlightColor,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (offer.vendorCategory != null && offer.vendorCategory!.isNotEmpty) ...[
                        4.verticalSpace,
                        Text(
                          offer.vendorCategory ?? "",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.black14.adaptiveColor(
                                  context,
                                  lightModeColor: AppColors.black14,
                                  darkModeColor: AppColors.greyE9,
                                ),
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Divider(
              height: 1,
              color: AppColors.greyE8.adaptiveColor(
                context,
                lightModeColor: AppColors.greyE8,
                darkModeColor: AppColors.grey50,
              ),
            ),
            16.verticalSpace,
            // Offer Title
            Text(
              "Offer Title",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.black3D.adaptiveColor(
                      context,
                      lightModeColor: AppColors.black3D,
                      darkModeColor: AppColors.greyE9,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
            ),
            4.verticalSpace,
            Text(
              offer.offerTitle ?? "",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).highlightColor,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            16.verticalSpace,
            // Metrics Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: "Price",
                    value: "${offer.price?.amount ?? ""} ${offer.price?.currencyCode ?? ""}",
                    isPrimary: true,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildMetricItem(
                    label: "Property with Offers",
                    value: "${offer.analyticsData?.propertyOfferCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            // Finance Request Metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: "Cash",
                    value: "${offer.vendorCashCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildMetricItem(
                    label: "Bank",
                    value: "${offer.vendorFinanceCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            // View Metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: "Offer View",
                    value: "${offer.offerAppliedCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildMetricItem(
                    label: "Unique View",
                    value: "${offer.offerAppliedCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.colorPrimary.withOpacity(0.05)
            : AppColors.greyF8.adaptiveColor(
                context,
                lightModeColor: AppColors.greyF8,
                darkModeColor: AppColors.black3D.withOpacity(0.3),
              ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.black3D.adaptiveColor(
                    context,
                    lightModeColor: AppColors.black3D,
                    darkModeColor: AppColors.greyE9,
                  ),
                  fontWeight: FontWeight.w400,
                ),
          ),
          4.verticalSpace,
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isPrimary
                      ? AppColors.colorPrimary
                      : Theme.of(context).highlightColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
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
            onSelected: (value) async {
              if (value != cubit.itemsPerPage) {
                cubit.updateItemsPerPage(value);
                _pagingController.refresh();
                // Manually trigger API call with new itemsPerPage
                if (vendorId != null && vendorId!.isNotEmpty) {
                  await cubit.getVendorOfferAnalytics(page: 1, vendorId: vendorId!);
                }
              }
            },
            itemBuilder: (context) {
              return itemsPerPageOptions.map((value) {
                final isSelected = value == cubit.itemsPerPage;

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
                    "${cubit.itemsPerPage}",
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
      // Append the data - page is already marked as loaded in the listener
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.offers);
      } else {
        _pagingController.appendPage(state.offers, state.currentPage + 1);
      }
    } else if (state is NoVendorOfferAnalyticsFound) {
      _pagingController.appendLastPage([]);
    } else if (state is VendorOfferAnalyticsError) {
      // Remove the page from loaded pages on error so it can be retried
      // Note: We don't know which page failed, so we clear all
      // In a more sophisticated implementation, we could track which page is loading
      _loadedPages.clear();
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
      _loadedPages.clear();
      _pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

