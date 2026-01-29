import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/owner_offer_analytics/owner_offer_analytics_response_model.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/owner_offer_analytics/cubit/owner_offer_analytics_cubit.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

class OwnerOfferAnalyticsScreen extends StatefulWidget {
  const OwnerOfferAnalyticsScreen({super.key});

  @override
  State<OwnerOfferAnalyticsScreen> createState() =>
      _OwnerOfferAnalyticsScreenState();
}

class _OwnerOfferAnalyticsScreenState extends State<OwnerOfferAnalyticsScreen>
    with AppBarMixin {
  final PagingController<int, OwnerPropertyAnalytics> _pagingController =
      PagingController(firstPageKey: 1);

  String? ownerId;
  bool _isListenerSetup = false;
  final Set<int> _loadedPages = <int>{};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    ownerId = await GetIt.I<AppPreferences>().getUserID();
    if (mounted &&
        ownerId != null &&
        ownerId!.isNotEmpty &&
        !_isListenerSetup) {
      _isListenerSetup = true;
      final cubit = context.read<OwnerOfferAnalyticsCubit>();
      _pagingController.addPageRequestListener((pageKey) {
        if (!_loadedPages.contains(pageKey) &&
            ownerId != null &&
            ownerId!.isNotEmpty) {
          _loadedPages.add(pageKey);
          cubit.getOwnerOfferAnalytics(page: pageKey, ownerId: ownerId!);
        }
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerOfferAnalyticsCubit, OwnerOfferAnalyticsState>(
      listener: _buildBlocListener,
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(
            context: context,
            requireLeading: true,
            title: appStrings(context).lblOwnerOfferAnalytics,
          ),
          body: ownerId == null || ownerId!.isEmpty
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
        if (ownerId != null && ownerId!.isNotEmpty) {
          _loadedPages.clear();
          _pagingController.refresh();
          await Future.delayed(const Duration(milliseconds: 100));
        }
      },
      child: PagedListView<int, OwnerPropertyAnalytics>.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return 12.verticalSpace;
        },
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<OwnerPropertyAnalytics>(
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
          itemBuilder: (context, property, index) {
            return _buildAnalyticsCard(property);
          },
          noItemsFoundIndicatorBuilder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: UIComponent.noDataWidgetWithInfo(
                  title: "No Analytics Data",
                  info: "No owner offer analytics data available",
                  context: context,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(OwnerPropertyAnalytics property) {
    final analytics = property.analyticsData;
    final finance = property.financeData;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.adaptiveColor(
          context,
          lightModeColor: AppColors.white,
          darkModeColor: AppColors.black2E,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.colorSecondary,
                  ),
                  child: const Icon(Icons.home_filled, size: 18),
                ),
                6.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title ?? "",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).highlightColor,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      1.verticalSpace,
                      Text(
                        property.subCategoryName ?? "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.black14.adaptiveColor(
                                context,
                                lightModeColor: AppColors.black14,
                                darkModeColor: AppColors.greyE9,
                              ),
                            ),
                      ),
                      1.verticalSpace,
                      Text(
                        "${property.country ?? ""}${property.city != null ? ", ${property.city}" : ""}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.black14.adaptiveColor(
                                context,
                                lightModeColor: AppColors.black14,
                                darkModeColor: AppColors.greyE9,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
                6.horizontalSpace,
                if (property.companyLogo != null &&
                    property.companyLogo!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: property.companyLogo ?? "",
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.colorSecondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.business, size: 20),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.colorSecondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.business, size: 20),
                  ),
              ],
            ),
            8.verticalSpace,
            Divider(
              height: 1,
              color: AppColors.greyE8.adaptiveColor(
                context,
                lightModeColor: AppColors.greyE8,
                darkModeColor: AppColors.grey50,
              ),
            ),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: "Vendors",
                    value: "${property.propertyVendorCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildMetricItem(
                    label: "Banks",
                    value: "${property.propertyBankCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
              ],
            ),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: "Visit Request",
                    value: "${property.visitRequestProperty ?? 0}",
                    isPrimary: true,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildMetricItem(
                    label: "Property Finance",
                    value: "${finance?.propertyFinanceCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: "Vendor Finance",
                    value: "${finance?.vendorFinanceCount ?? 0}",
                    isPrimary: true,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildMetricItem(
                    label: "Total Clicks",
                    value: "${property.noOfClicks ?? 0}",
                    isPrimary: true,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildMetricChip(
                  label: "Direct Call",
                  value: "${analytics?.propertyDirectCallCount ?? 0}",
                ),
                _buildMetricChip(
                  label: "Map",
                  value: "${analytics?.propertyMapCount ?? 0}",
                ),
                _buildMetricChip(
                  label: "Share",
                  value: "${analytics?.propertyShareCount ?? 0}",
                ),
                _buildMetricChip(
                  label: "Video",
                  value: "${analytics?.propertyVideoCount ?? 0}",
                ),
                _buildMetricChip(
                  label: "Virtual Tour",
                  value: "${analytics?.propertyVirtualTourCount ?? 0}",
                ),
                _buildMetricChip(
                  label: "Text Message",
                  value: "${analytics?.propertyTextMessageCount ?? 0}",
                ),
                _buildMetricChip(
                  label: "WhatsApp",
                  value: "${analytics?.propertyWhatsAppCount ?? 0}",
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: "Property View",
                    value: "${analytics?.propertyCount ?? 0}",
                    isPrimary: false,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildMetricItem(
                    label: "Unique View",
                    value: "${analytics?.propertyUniqueView ?? 0}",
                    isPrimary: false,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildMetricItem(
                    label: "Spent Time",
                    value: analytics?.propertySpentTime ?? "--:--:--",
                    isPrimary: false,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.colorPrimary.withOpacity(0.05)
            : AppColors.greyF8.adaptiveColor(
                context,
                lightModeColor: AppColors.greyF8,
                darkModeColor: AppColors.black3D.withOpacity(0.3),
              ),
        borderRadius: BorderRadius.circular(10),
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
                  fontSize: 11,
                ),
          ),
          2.verticalSpace,
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
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

  Widget _buildMetricChip({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greyF8.adaptiveColor(
          context,
          lightModeColor: AppColors.greyF8,
          darkModeColor: AppColors.black3D.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.black3D.adaptiveColor(
                    context,
                    lightModeColor: AppColors.black3D,
                    darkModeColor: AppColors.greyE9,
                  ),
                  fontSize: 11,
                ),
          ),
          6.horizontalSpace,
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.colorPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControl() {
    final cubit = context.read<OwnerOfferAnalyticsCubit>();
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (value) async {
              if (value != cubit.itemsPerPage) {
                cubit.updateItemsPerPage(value);
                _pagingController.refresh();
                if (ownerId != null && ownerId!.isNotEmpty) {
                  await cubit.getOwnerOfferAnalytics(page: 1, ownerId: ownerId!);
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : Colors.transparent,
                    ),
                    child: Text(
                      "$value",
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                color:
                                    isSelected ? Colors.white : AppColors.black14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                    ),
                  ),
                );
              }).toList();
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  const Icon(Icons.arrow_drop_down,
                      color: selectedColor, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buildBlocListener(
      BuildContext context, OwnerOfferAnalyticsState state) async {
    if (state is OwnerOfferAnalyticsSuccess) {
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.properties);
      } else {
        _pagingController.appendPage(
            state.properties, state.currentPage + 1);
      }
    } else if (state is NoOwnerOfferAnalyticsFound) {
      _pagingController.appendLastPage([]);
    } else if (state is OwnerOfferAnalyticsError) {
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
    } else if (state is OwnerOfferAnalyticsRefresh) {
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


