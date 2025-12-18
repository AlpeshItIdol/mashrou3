import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/repository/offers_management_repository.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../dashboard/sub_screens/home/cubit/home_cubit.dart';
import 'model/price_calculations_response_model.dart';
import 'model/apply_vendor_offer_request.model.dart';

class PricingCalculationResultsScreen extends StatefulWidget {
  final PriceCalculationsResponseModel pricingData;
  final List<String> propertyIds;
  final List<String> offersIds;
  final bool isMultiple;
  final String? offerType;
  final String? startDate;
  final String? endDate;

  const PricingCalculationResultsScreen({
    super.key,
    required this.pricingData,
    required this.propertyIds,
    required this.offersIds,
    required this.isMultiple,
    this.offerType,
    this.startDate,
    this.endDate,
  });

  @override
  State<PricingCalculationResultsScreen> createState() => _PricingCalculationResultsScreenState();
}

class _PricingCalculationResultsScreenState extends State<PricingCalculationResultsScreen> with AppBarMixin {
  bool isAccepted = false;
  bool isApplying = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final data = widget.pricingData.data;
    final firstProperty = data?.propertiesData?.isNotEmpty == true ? data!.propertiesData!.first : null;
    final offerType = widget.offerType ?? firstProperty?.offerType ?? data?.offerType ?? "lifetime";
    final isTimed = offerType == "timed";
    
    return Scaffold(
            appBar: buildAppBar(
              context: context,
              requireLeading: true,
              title: "Pricing Calculation",
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,

                    /// Offer Details Card
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.black2E : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.greyE8,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow("Offer Type", _capitalizeFirst(offerType)),
                          12.verticalSpace,
                          if (isTimed) ...[
                            _buildDetailRow("Start Date", widget.startDate ?? firstProperty?.startDate ?? data?.startDate ?? "-"),
                            12.verticalSpace,
                            _buildDetailRow("End Date", widget.endDate ?? firstProperty?.endDate ?? data?.endDate ?? "-"),
                            12.verticalSpace,
                            _buildDetailRow("Total Days", "${firstProperty?.totalDays ?? data?.totalDays ?? _calculateTotalDays()}"),
                            12.verticalSpace,
                          ],
                          _buildDetailRow("Total Selected Property", "${data?.totalSelectedProperty ?? data?.propertiesData?.length ?? widget.propertyIds.length}"),
                        ],
                      ),
                    ),

                    24.verticalSpace,

                    /// Total Amount Display
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount:",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${data?.finalSum?.amount?.toStringAsFixed(2) ?? data?.totalAmount?.toStringAsFixed(2) ?? "0.00"}",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (data?.finalSum?.currencySymbol != null || data?.currencySymbol != null) ...[
                                4.horizontalSpace,
                                Text(
                                  data?.finalSum?.currencySymbol ?? data?.currencySymbol ?? "",
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    24.verticalSpace,

                    /// Acceptance Checkbox
                    UIComponent.customInkWellWidget(
                      onTap: () {
                        setState(() {
                          isAccepted = !isAccepted;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          isAccepted
                              ? SVGAssets.checkboxEnableIcon.toSvg(
                                  height: 20,
                                  width: 20,
                                  context: context,
                                )
                              : SVGAssets.checkboxDisableIcon.toSvg(
                                  height: 20,
                                  width: 20,
                                  context: context,
                                ),
                          12.horizontalSpace,
                          Expanded(
                            child: Text(
                              "I accept this pricing in order to apply offer for the selected properties.",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppColors.greyB0 : AppColors.black3D,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: 90,
              decoration: BoxDecoration(
                color: isDark ? null : AppColors.white,
                gradient: isDark ? AppColors.primaryGradient : null,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.colorPrimary.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Back Button
                  Expanded(
                    child: UIComponent.customInkWellWidget(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.white.withOpacity(0.1) : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.white.withOpacity(0.2) : AppColors.greyE8,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIComponent.customRTLIcon(
                              context: context,
                              child: SVGAssets.arrowLeftIcon.toSvg(
                                context: context,
                                color: isDark ? AppColors.white : AppColors.black3D,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            8.horizontalSpace,
                            Text(
                              "Back",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: isDark ? AppColors.white : AppColors.black3D,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  12.horizontalSpace,

                  /// Apply Offer Button
                  Expanded(
                    child: Opacity(
                      opacity: (isAccepted && !isApplying) ? 1.0 : 0.5,
                      child: UIComponent.customInkWellWidget(
                        onTap: (isAccepted && !isApplying) ? () async {
                          await _applyVendorOffer(context);
                        } : null,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: (isAccepted && !isApplying)
                                ? AppColors.primaryGradient
                                : AppColors.greyGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SVGAssets.myOfferIcon.toSvg(
                                context: context,
                                color: AppColors.white,
                                height: 20,
                                width: 20,
                              ),
                              8.horizontalSpace,
                              Text(
                                "Apply Offer",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildDetailRow(String label, String value) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.greyB0 : AppColors.black3D,
                fontWeight: FontWeight.w400,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.white : AppColors.black3D,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  int _calculateTotalDays() {
    if (widget.startDate != null && widget.endDate != null) {
      try {
        final start = DateTime.parse(widget.startDate!);
        final end = DateTime.parse(widget.endDate!);
        return end.difference(start).inDays + 1; // +1 to include both start and end days
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  Future<void> _applyVendorOffer(BuildContext context) async {
    setState(() {
      isApplying = true;
    });
    OverlayLoadingProgress.start(context);

    try {
      final data = widget.pricingData.data;
      final offerType = widget.offerType ?? data?.offerType ?? "lifetime";
      
      // Build propertiesData array
      List<PropertyData> propertiesDataList = [];
      if (data?.propertiesData != null && data!.propertiesData!.isNotEmpty) {
        // Use propertiesData from API response
        for (var propData in data.propertiesData!) {
          propertiesDataList.add(PropertyData(
            propertyId: propData.propertyId,
            pricing: propData.pricing,
            timedRate: propData.timedRate != null
                ? Rate(
                    amount: propData.timedRate!.amount,
                    currencyCode: propData.timedRate!.currencyCode,
                    currencySymbol: propData.timedRate!.currencySymbol,
                  )
                : null,
            lifetimeRate: propData.lifetimeRate != null
                ? Rate(
                    amount: propData.lifetimeRate!.amount,
                    currencyCode: propData.lifetimeRate!.currencyCode,
                    currencySymbol: propData.lifetimeRate!.currencySymbol,
                  )
                : null,
            originalAmount: propData.originalAmount,
          ));
        }
      } else {
        // Construct propertiesData from available data (fallback)
        final totalAmount = data?.finalSum?.amount ?? data?.totalAmount ?? 0.0;
        final currencyCode = data?.finalSum?.currencyCode ?? data?.currency ?? "JOD";
        final currencySymbol = data?.finalSum?.currencySymbol ?? data?.currencySymbol ?? "د.أ";
        final perPropertyAmount = widget.propertyIds.isNotEmpty
            ? totalAmount / widget.propertyIds.length
            : totalAmount;
        
        for (var propertyId in widget.propertyIds) {
          final rate = Rate(
            amount: perPropertyAmount.toStringAsFixed(2),
            currencyCode: currencyCode,
            currencySymbol: currencySymbol,
          );
          
          propertiesDataList.add(PropertyData(
            propertyId: propertyId,
            pricing: perPropertyAmount,
            timedRate: offerType == "timed" ? rate : null,
            lifetimeRate: offerType == "lifetime" ? rate : null,
            originalAmount: perPropertyAmount,
          ));
        }
      }

      // Build finalSum from API response
      final finalSum = FinalSum(
        amount: data?.finalSum?.amount ?? data?.totalAmount ?? 0.0,
        currencyCode: data?.finalSum?.currencyCode ?? "JOD",
        currencySymbol: data?.finalSum?.currencySymbol ?? "د.أ",
      );

      // Build request model
      final requestModel = ApplyVendorOfferRequestModel(
        propertyId: widget.propertyIds,
        offersIds: widget.offersIds,
        offerType: offerType,
        propertiesData: propertiesDataList,
        finalSum: finalSum,
        action: NetworkConstants.kActionOfferApply,
        isAllProperty: false,
        startDate: widget.startDate ?? data?.propertiesData?.firstOrNull?.startDate ?? data?.startDate,
        endDate: widget.endDate ?? data?.propertiesData?.firstOrNull?.endDate ?? data?.endDate,
        totalDays: data?.propertiesData?.firstOrNull?.totalDays ?? data?.totalDays ?? _calculateTotalDays(),
      );

      final repository = GetIt.I<OffersManagementRepository>();
      final response = await repository.applyVendorOffer(requestModel: requestModel);

      OverlayLoadingProgress.stop();
      setState(() {
        isApplying = false;
      });

      if (response is SuccessResponse) {
        // Reset property list and refresh home screen data
        if (context.mounted) {
          try {
            final homeCubit = context.read<HomeCubit>();
            homeCubit.resetPropertyList();
            homeCubit.searchText = context.read<HomeCubit>().searchText;
            homeCubit.refreshData();
          } catch (e) {
            // HomeCubit might not be available in context, continue with navigation
            debugPrint('HomeCubit not available: $e');
          }
          
          Utils.snackBar(
            context: context,
            message: "Offer applied successfully",
          );
          // Navigate to Dashboard/Home screen - clears navigation stack and returns to home
          context.goNamed(Routes.kDashboard);
        }
      } else if (response is FailedResponse) {
        Utils.showErrorMessage(
          context: context,
          message: response.errorMessage,
        );
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      setState(() {
        isApplying = false;
      });
      Utils.showErrorMessage(
        context: context,
        message: "Failed to apply offer: ${e.toString()}",
      );
    }
  }
}

