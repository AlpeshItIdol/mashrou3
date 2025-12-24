import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/repository/offers_management_repository.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../../custom_widget/text_form_fields/my_text_form_field.dart';
import 'cubit/offer_pricing_cubit.dart';

class OfferPricingScreen extends StatefulWidget {
  final List<String> propertyIds;
  final List<String> offersIds;
  final bool isMultiple;
  final bool isAllProperty;

  const OfferPricingScreen({
    super.key,
    required this.propertyIds,
    required this.offersIds,
    required this.isMultiple,
    this.isAllProperty = false,
  });

  @override
  State<OfferPricingScreen> createState() => _OfferPricingScreenState();
}

class _OfferPricingScreenState extends State<OfferPricingScreen> with AppBarMixin {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => OfferPricingCubit(
        repository: GetIt.I<OffersManagementRepository>(),
      )..setOfferType("lifetime"), // Default to lifetime
      child: BlocConsumer<OfferPricingCubit, OfferPricingState>(
        listener: buildBlocListener,
        builder: (context, state) {
          OfferPricingCubit cubit = context.read<OfferPricingCubit>();
          return Scaffold(
            appBar: buildAppBar(
              context: context,
              requireLeading: true,
              title: "Offer Pricing",
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,

                    /// Offer Type Dropdown
                    // UIComponent.buildDropdownFormField<String>(
                    //   context: context,
                    //   labelText: "Offer Type",
                    //   value: cubit.selectedOfferType,
                    //   items: [
                    //     const DropdownMenuItem<String>(
                    //       value: "lifetime",
                    //       child: Text("Lifetime"),
                    //     ),
                    //     const DropdownMenuItem<String>(
                    //       value: "timed",
                    //       child: Text("Timed"),
                    //     ),
                    //   ],
                    //   onChanged: (value) {
                    //     cubit.setOfferType(value);
                    //   },
                    // ),
                    _buildItemsPerPageDropdown(context, cubit),

                    24.verticalSpace,

                    /// Show date pickers only when Timed is selected
                    if (cubit.selectedOfferType == "timed") ...[
                      /// Start Date
                      MyTextFormField(
                        fieldName: "Start Date",
                        controller: cubit.startDateController,
                        isMandatory: true,
                        suffixIcon: SVGAssets.calender1Icon.toSvg(
                          height: 22,
                          width: 22,
                          context: context,
                        ),
                        keyboardType: TextInputType.name,
                        fieldHint: "Select Start Date",
                        onFieldSubmitted: (v) {},
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: cubit.startDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            helpText: "Select Start Date",
                            useRootNavigator: false,
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    cardColor: AppColors.white,
                                    dialogBackgroundColor: Colors.white,
                                    textTheme: Theme.of(context).textTheme.copyWith(
                                          titleSmall: Theme.of(context).textTheme.bodySmall,
                                          titleMedium: Theme.of(context).textTheme.bodyMedium,
                                          titleLarge: Theme.of(context).textTheme.titleMedium,
                                        ),
                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                          surface: AppColors.primaryGradient.colors[1].adaptiveColor(
                                            context,
                                            lightModeColor: AppColors.primaryGradient.colors[1],
                                            darkModeColor: AppColors.goldA1,
                                          ),
                                          primary: AppColors.primaryGradient.colors[1].adaptiveColor(
                                            context,
                                            lightModeColor: AppColors.primaryGradient.colors[1],
                                            darkModeColor: AppColors.goldA1,
                                          ),
                                          onSurface: Theme.of(context).highlightColor,
                                          onPrimary: AppColors.white,
                                        ),
                                  ),
                                  child: child!,
                                ),
                              );
                            },
                          );

                          if (pickedDate != null) {
                            cubit.setStartDate(pickedDate);
                          }
                        },
                        obscureText: false,
                        validator: (value) {
                          if (cubit.selectedOfferType == "timed" && (value == null || value.isEmpty)) {
                            return "Please select start date";
                          }
                          return null;
                        },
                      ),

                      16.verticalSpace,

                      /// End Date
                      MyTextFormField(
                        fieldName: "End Date",
                        controller: cubit.endDateController,
                        isMandatory: true,
                        suffixIcon: SVGAssets.calender1Icon.toSvg(
                          height: 22,
                          width: 22,
                          context: context,
                        ),
                        keyboardType: TextInputType.name,
                        fieldHint: "Select End Date",
                        onFieldSubmitted: (v) {},
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: cubit.endDate ?? (cubit.startDate ?? DateTime.now()),
                            firstDate: cubit.startDate ?? DateTime.now(),
                            lastDate: DateTime(2100),
                            helpText: "Select End Date",
                            useRootNavigator: false,
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    cardColor: AppColors.white,
                                    dialogBackgroundColor: Colors.white,
                                    textTheme: Theme.of(context).textTheme.copyWith(
                                          titleSmall: Theme.of(context).textTheme.bodySmall,
                                          titleMedium: Theme.of(context).textTheme.bodyMedium,
                                          titleLarge: Theme.of(context).textTheme.titleMedium,
                                        ),
                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                          surface: AppColors.primaryGradient.colors[1].adaptiveColor(
                                            context,
                                            lightModeColor: AppColors.primaryGradient.colors[1],
                                            darkModeColor: AppColors.goldA1,
                                          ),
                                          primary: AppColors.primaryGradient.colors[1].adaptiveColor(
                                            context,
                                            lightModeColor: AppColors.primaryGradient.colors[1],
                                            darkModeColor: AppColors.goldA1,
                                          ),
                                          onSurface: Theme.of(context).highlightColor,
                                          onPrimary: AppColors.white,
                                        ),
                                  ),
                                  child: child!,
                                ),
                              );
                            },
                          );

                          if (pickedDate != null) {
                            cubit.setEndDate(pickedDate);
                          }
                        },
                        obscureText: false,
                        validator: (value) {
                          if (cubit.selectedOfferType == "timed" && (value == null || value.isEmpty)) {
                            return "Please select end date";
                          }
                          return null;
                        },
                      ),
                    ],
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
                          color: isDark ? AppColors.white.withOpacity(0.1) : AppColors.greyE8,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
                        child: Center(
                          child: Text(
                            "Back",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: isDark ? AppColors.white : AppColors.black3D,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  12.horizontalSpace,

                  /// View Offer Pricing Button
                  Expanded(
                    child: UIComponent.customInkWellWidget(
                      onTap: () {
                        if (cubit.selectedOfferType == null) {
                          Utils.showErrorMessage(context: context, message: "Please select an offer type");
                          return;
                        }
                        if (cubit.selectedOfferType == "timed") {
                          if (cubit.startDate == null || cubit.endDate == null) {
                            Utils.showErrorMessage(context: context, message: "Please select both start and end dates");
                            return;
                          }
                          if (cubit.endDate!.isBefore(cubit.startDate!)) {
                            Utils.showErrorMessage(context: context, message: "End date must be after start date");
                            return;
                          }
                        }
                        cubit.getPriceCalculations(
                          propertyIds: widget.propertyIds,
                          isAllProperty: widget.isAllProperty,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
                        child: Center(
                          child: Text(
                            "View Offer Pricing",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> buildBlocListener(BuildContext context, OfferPricingState state) async {
    if (state is OfferPricingLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is OfferPricingSuccess) {
      OverlayLoadingProgress.stop();
      // Navigate to results screen
      final cubit = context.read<OfferPricingCubit>();
      context.pushNamed(
        Routes.kPricingCalculationResultsScreen,
        extra: {
          'pricingData': state.model,
          'propertyIds': widget.propertyIds,
          'offersIds': widget.offersIds,
          'isMultiple': widget.isMultiple,
          'isAllProperty': widget.isAllProperty,
          'offerType': cubit.selectedOfferType,
          'startDate': cubit.startDate != null ? cubit.startDateController.text : null,
          'endDate': cubit.endDate != null ? cubit.endDateController.text : null,
        },
      );
    } else if (state is OfferPricingError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(context: context, message: state.errorMessage);
    }
  }

  // dart
  Widget _buildItemsPerPageDropdown(BuildContext context, OfferPricingCubit cubit) {
    final options = [
      {'value': 'lifetime', 'label': 'Lifetime'},
      {'value': 'timed', 'label': 'Timed'},
    ];
    const selectedColor = Color.fromRGBO(62, 113, 119, 1.0);

    String currentValueNormalized() {
      final sel = cubit.selectedOfferType;
      return (sel == null) ? options.first['value']! : sel.toString().toLowerCase();
    }

    String labelFor(String value) {
      return options.firstWhere((o) => o['value'] == value, orElse: () => {'label': value})['label']!;
    }

    final currentValue = currentValueNormalized();

    return PopupMenuButton<String>(
      initialValue: currentValue,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AppColors.white.adaptiveColor(
        context,
        lightModeColor: AppColors.white,
        darkModeColor: AppColors.black2E,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        // compare normalized values to avoid case-mismatch issues
        if (value.toLowerCase() != cubit.selectedOfferType?.toLowerCase()) {
          cubit.setOfferType(value);
        } else {
          // still set to ensure consistent format
          cubit.setOfferType(value);
        }
        // force rebuild of this widget in case cubit doesn't emit a new state
        if (mounted) setState(() {});
      },
      itemBuilder: (context) {
        return options.map((opt) {
          final value = opt['value']!;
          final isSelected = value == currentValue;
          return PopupMenuItem<String>(
            value: value,
            padding: EdgeInsets.zero,
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : Colors.transparent,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      opt['label']!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected ? Colors.white : AppColors.black14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        height: 56,
        width: MediaQuery.sizeOf(context).width,
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
            Expanded(
              child: Text(
                labelFor(currentValue),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: selectedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: selectedColor, size: 18),
          ],
        ),
      ),
    );
  }

}

