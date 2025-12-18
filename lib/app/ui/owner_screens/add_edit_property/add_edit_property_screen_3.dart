import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/common_row_bottons.dart';
import 'package:mashrou3/app/ui/custom_widget/custom_stepper_widget.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/cubit/add_edit_property_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/model/category_item_data_response_model.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/sub_screens/home/cubit/owner_home_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../config/resources/app_constants.dart';
import '../../../../utils/app_localization.dart';
import '../../custom_widget/app_bar_mixin.dart';
import '../../custom_widget/bottom_navigation_widget/bottom_navigation_cubit.dart';
import '../dashboard/sub_screens/in_review/cubit/in_review_cubit.dart';

class AddEditPropertyScreen3 extends StatefulWidget {
  const AddEditPropertyScreen3({super.key});

  @override
  State<AddEditPropertyScreen3> createState() => _AddEditPropertyScreen3State();
}

class _AddEditPropertyScreen3State extends State<AddEditPropertyScreen3> with AppBarMixin {
  final ScrollController scrollController = ScrollController();
  bool isSaveButtonClicked = false;
  final formKeyStep3 = GlobalKey<FormState>();

  // Map to track validation state for each widget
  final Map<String, bool> validationMap = {};

  @override
  Widget build(BuildContext context) {
    return _buildBlocConsumer;
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<AddEditPropertyCubit, AddEditPropertyState>(
      listener: (BuildContext context, AddEditPropertyState state) async {
        if (state is AddPropertyAPILoading) {
          OverlayLoadingProgress.start(context);
        } else if (state is PropertyCategoryFieldsLoading) {
          OverlayLoadingProgress.start(context);
        } else if (state is AddEditPropertyCategoryFieldsLoaded) {
          OverlayLoadingProgress.stop();
        } else if (state is AddPropertyAPISuccess) {
          /// Navigate to In Review Screen index
          context.read<BottomNavCubit>().selectIndex(1);
          InReviewCubit cubit = context.read<InReviewCubit>();
          cubit.resetPropertyList();
          OverlayLoadingProgress.stop();
          Utils.snackBar(
            context: context,
            message: state.model.message ?? "",
          );
          context.goNamed(Routes.kOwnerDashboard);
          await cubit.getPropertyList(hasMoreData: false, id: AppConstants.propertyCategory[cubit.selectedItemIndex].sId);
          OwnerHomeCubit homeCubit = context.read<OwnerHomeCubit>();
          homeCubit.resetPropertyList();
          if (!context.mounted) return;
          homeCubit.searchText = context.read<OwnerHomeCubit>().searchText ?? "";
          await homeCubit.getPropertyList();
        } else if (state is AddPropertyAPIFailure) {
          OverlayLoadingProgress.stop();
          Utils.showErrorMessage(
              context: context,
              message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
        }
      },
      builder: (context, state) {
        AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();
        return PopScope(
          canPop: state is AddPropertyAPILoading ? false : true,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
          },
          child: Scaffold(
            appBar: buildAppBar(
              context: context,
              requireLeading: true,
              title: context.read<AddEditPropertyCubit>().isEditModeOn ? appStrings(context).editProperty : appStrings(context).addProperty,
            ),
            bottomNavigationBar: SafeArea(
              child: ButtonRow(
                leftButtonText: appStrings(context).cancel,
                rightButtonText: appStrings(context).save,
                onLeftButtonTap: () {
                  // Handle cancel action
                  UIComponent.showCustomBottomSheet(
                      context: context,
                      builder: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SVGAssets.alertIcon.toSvg(context: context),
                          12.verticalSpace,
                          Text(
                            appStrings(context).wantToCancel,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          8.verticalSpace,
                          Text(
                            appStrings(context).cancelPropertyInfo,
                            style: Theme.of(context).textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                          14.verticalSpace,
                          ButtonRow(
                            leftButtonText: appStrings(context).cancel,
                            rightButtonText: appStrings(context).yes,
                            onLeftButtonTap: () {
                              context.pop();
                            },
                            onRightButtonTap: () {
                              context.pop();
                              context.read<AddEditPropertyCubit>().clearScreen1Controllers();
                              context.read<AddEditPropertyCubit>().clearScreen2Controllers();
                              context.read<AddEditPropertyCubit>().clearScreen3Controllers();
                              context.goNamed(Routes.kOwnerDashboard);
                            },
                            rightButtonBorderColor: AppColors.colorPrimary,
                            rightButtonBgColor: Theme.of(context).canvasColor,
                            leftButtonBgColor: Theme.of(context).cardColor,
                            leftButtonBorderColor: Theme.of(context).primaryColor,
                            leftButtonTextColor: Theme.of(context).primaryColor,
                            rightButtonTextColor: AppColors.colorPrimary,
                            isLeftButtonGradient: false,
                            isRightButtonGradient: false,
                            isLeftButtonBorderRequired: true,
                            isRightButtonBorderRequired: true,
                          ),
                        ],
                      ));
                },
                onRightButtonTap: () {
                  onSaveClick(context);
                },
                leftButtonBgColor: Theme.of(context).cardColor,
                leftButtonBorderColor: Theme.of(context).primaryColor,
                leftButtonTextColor: Theme.of(context).primaryColor,
                isLeftButtonGradient: false,
                isLeftButtonBorderRequired: true,
              ),
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    const CustomStepperWidget(
                      currentStep: 3,
                      isSixSteps: false,
                      isThreeSteps: true,
                    ),
                    16.verticalSpace,
                    Text(
                      appStrings(context).livingSpaceAmenities,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    22.verticalSpace,
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formKeyStep3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: cubit.categoryOptions.entries.map((entry) {
                          String key = entry.key;
                          CategoryItemOptions categoryOptions = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              categoryOptions.isMultiple ?? false
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        getMultiSelectionWidget(
                                          context: context,
                                          itemOptions: categoryOptions,
                                          uniqueKey: key,
                                        ),
                                        5.verticalSpace,

                                        /// Render chips for selected banks
                                        if (cubit.selectedMultiItems.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: cubit.selectedMultiItems.values.expand((selectedItems) {
                                                // Iterate over each list of selected items for each category
                                                return selectedItems.map((item) {
                                                  return Chip(
                                                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 4, vertical: 2),
                                                    backgroundColor: AppColors.colorBgPrimary.adaptiveColor(
                                                      context,
                                                      lightModeColor: AppColors.colorBgPrimary,
                                                      darkModeColor: AppColors.black2E,
                                                    ),
                                                    side: BorderSide(
                                                      color: AppColors.colorBgPrimary.adaptiveColor(
                                                        context,
                                                        lightModeColor: AppColors.colorBgPrimary,
                                                        darkModeColor: AppColors.black2E,
                                                      ),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    iconTheme: IconThemeData(
                                                      color: Theme.of(context).highlightColor, // Set the delete icon color
                                                    ),
                                                    label: Text(
                                                      item.name ?? "",
                                                      // Display the name of the selected item
                                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                            color: AppColors.colorPrimary.adaptiveColor(
                                                              context,
                                                              lightModeColor: AppColors.colorPrimary,
                                                              darkModeColor: AppColors.white,
                                                            ),
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                    ),
                                                    onDeleted: () {
                                                      setState(() {
                                                        // Find the key for the current item and remove it from the selected list
                                                        cubit.selectedMultiItems.forEach((key, selectedItems) {
                                                          if (selectedItems.contains(item)) {
                                                            selectedItems.remove(item);
                                                          }
                                                        });
                                                        printf("${cubit.selectedMultiItems}");
                                                      });
                                                    },
                                                  );
                                                });
                                              }).toList(),
                                            ),
                                          ),
                                      ],
                                    )
                                  : getSingleSelectionWidget(
                                      context: context,
                                      itemOptions: categoryOptions,
                                      uniqueKey: key,
                                    ),
                              16.verticalSpace, // Add spacing between widgets
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    18.verticalSpace,
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
                              ? SVGAssets.checkboxEnableIcon.toSvg(height: 18, width: 18, context: context)
                              : SVGAssets.checkboxDisableIcon.toSvg(height: 18, width: 18, context: context),
                          10.horizontalSpace,
                          Flexible(
                            child: UIComponent.termsAndPrivacyText(context: context),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getSingleSelectionWidget({
    required BuildContext context,
    required CategoryItemOptions itemOptions,
    required String uniqueKey,
  }) {
    final AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();

    return BlocConsumer<AddEditPropertyCubit, AddEditPropertyState>(
      listener: (context, state) {
        if (isSaveButtonClicked && (itemOptions.required ?? false)) {
          bool isValidNow = cubit.selectedItems[uniqueKey] != null;
          if (cubit.validationMap[uniqueKey] != isValidNow) {
            cubit.updateValidationStatus(uniqueKey, isValidNow);
          }
        }
      },
      builder: (context, state) {
        // Fetch the latest validation status
        bool isValid = isSaveButtonClicked ? (cubit.validationMap[uniqueKey] ?? true) : true;

        CategoryItemData? selectedCategoryItem = cubit.selectedItems[uniqueKey];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataLabelWidget(
              context: context,
              label: itemOptions.label ?? "",
              isRequired: itemOptions.required ?? false,
            ),
            6.verticalSpace,
            BlocBuilder<AddEditPropertyCubit, AddEditPropertyState>(
              builder: (context, state) {
                return UIComponent.customInkWellWidget(
                  onTap: () async {
                    final selectedItem = await showSingleItemsBottomSheet(
                      context,
                      itemOptions.label!,
                      itemOptions.data!,
                      selectedCategoryItem,
                    );

                    if (selectedItem != null) {
                      // Set selected item and update validation
                      cubit.setSelectedItemForCategory(selectedItem, uniqueKey);
                      cubit.updateValidationStatus(uniqueKey, true);
                      printf("Selected item:-- ${selectedItem.name}");
                    }
                  },
                  child: Container(
                    key: Key(uniqueKey),
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border: Border.all(
                        color: isValid
                            ? AppColors.greyE9.adaptiveColor(context, lightModeColor: AppColors.greyE9, darkModeColor: AppColors.black2E)
                            : AppColors.red00,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              selectedCategoryItem?.name ?? appStrings(context).select,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SVGAssets.arrowDownIcon.toSvg(context: context),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (isSaveButtonClicked && !isValid)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  '${appStrings(context).textPleaseSelect} ${itemOptions.label?.toLowerCase()}.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.red00),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget getMultiSelectionWidget({
    required BuildContext context,
    required CategoryItemOptions itemOptions,
    required String uniqueKey,
  }) {
    final AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();

    return BlocConsumer<AddEditPropertyCubit, AddEditPropertyState>(
      listener: (context, state) {
        if (isSaveButtonClicked && (itemOptions.required ?? false)) {
          bool isValidNow = cubit.selectedMultiItems[uniqueKey]?.isNotEmpty ?? false;
          if (cubit.validationMap[uniqueKey] != isValidNow) {
            cubit.updateValidationStatus(uniqueKey, isValidNow);
          }
        }
      },
      builder: (context, state) {
        // Get latest validation status
        bool isValid = isSaveButtonClicked ? (cubit.validationMap[uniqueKey] ?? true) : true;

        List<CategoryItemData> selectedCategoryItems = cubit.selectedMultiItems[uniqueKey] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataLabelWidget(
              context: context,
              label: itemOptions.label ?? "",
              isRequired: itemOptions.required ?? false,
            ),
            6.verticalSpace,
            BlocBuilder<AddEditPropertyCubit, AddEditPropertyState>(
              builder: (context, state) {
                return UIComponent.customInkWellWidget(
                  onTap: () async {
                    final selectedItems = await showMultiItemsBottomSheet(
                      context,
                      itemOptions.label!,
                      itemOptions.data!,
                      selectedCategoryItems,
                    );

                    if (selectedItems != null) {
                      // Set selected items and update validation
                      cubit.setSelectedItemsForCategory(selectedItems, uniqueKey);
                      cubit.updateValidationStatus(uniqueKey, true);
                      printf("Selected items:-- ${selectedItems.map((e) => e.name).join(', ')}");
                    }
                  },
                  child: Container(
                    key: Key(uniqueKey),
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border: Border.all(
                        color: isValid
                            ? AppColors.greyE9.adaptiveColor(context, lightModeColor: AppColors.greyE9, darkModeColor: AppColors.black2E)
                            : AppColors.red00,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              selectedCategoryItems.isNotEmpty
                                  ? selectedCategoryItems.map((e) => e.name).join(', ')
                                  : appStrings(context).select,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SVGAssets.arrowDownIcon.toSvg(context: context),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (isSaveButtonClicked && !isValid)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  '${appStrings(context).textPleaseSelectAtLeastOne} ${itemOptions.label?.toLowerCase()}.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.red00),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<CategoryItemData?> showSingleItemsBottomSheet(
    BuildContext context,
    String title,
    List<CategoryItemData> items,
    CategoryItemData? currentSelectedItem, // Pass the current selected item
  ) {
    final cubit = context.read<AddEditPropertyCubit>();
    final itemCount = items.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<CategoryItemData?>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        CategoryItemData? selectedItem = currentSelectedItem;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header and Close Button
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${appStrings(context).select} $title",
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black3D.forLightMode(context),
                              ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context, selectedItem);
                        },
                      ),
                    ],
                  ),
                ),
                // List of Items
                isSmall
                    ? ListView.separated(
                        itemCount: items.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final item = items[index];

                          final isSelected = selectedItem?.sId.toString() == item.sId.toString();

                          return UIComponent.customInkWellWidget(
                            onTap: () {
                              setState(() {
                                selectedItem = item; // Only highlight the selected item
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.colorPrimaryShade.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.colorPrimaryShade,
                                          darkModeColor: isSelected ? AppColors.colorPrimary : AppColors.white,
                                        ) // Gray for selected
                                      : Colors.transparent,
                                  // Transparent for unselected
                                  borderRadius: BorderRadius.circular(8), // Optional rounded corners
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name ?? "",
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: AppColors.black14.forLightMode(context),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Divider(
                            color:
                                AppColors.greyE9.adaptiveColor(context, lightModeColor: AppColors.greyE9, darkModeColor: AppColors.black2E),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: items.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final item = items[index];
                            // final isSelected = selectedItem == item;

                            final isSelected = selectedItem?.sId.toString() == item.sId.toString();

                            return UIComponent.customInkWellWidget(
                              padding: 0,
                              onTap: () {
                                setState(() {
                                  selectedItem = item;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.colorPrimaryShade.adaptiveColor(
                                            context,
                                            lightModeColor: AppColors.colorPrimaryShade,
                                            darkModeColor: isSelected ? AppColors.colorPrimary : AppColors.white,
                                          ) // Gray for selected
                                        : Colors.transparent,
                                    // Transparent for unselected
                                    borderRadius: BorderRadius.circular(8), // Optional rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  child: Row(
                                    children: [
                                      // isSelected
                                      //     ? SVGAssets.checkboxEnableIcon.toSvg(
                                      //         height: 18,
                                      //         width: 18,
                                      //         context: context)
                                      //     : SVGAssets.checkboxDisableIcon.toSvg(
                                      //         height: 18,
                                      //         width: 18,
                                      //         context: context),
                                      // const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item.name ?? "",
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                color: AppColors.black14.adaptiveColor(
                                                  context,
                                                  lightModeColor: AppColors.black14,
                                                  darkModeColor: AppColors.white,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Divider(
                              color: AppColors.greyE9
                                  .adaptiveColor(context, lightModeColor: AppColors.greyE9, darkModeColor: AppColors.black2E),
                            ),
                          ),
                        ),
                      ),
                // Select Button
                UIComponent.bottomSheetWithButtonWithGradient(
                  context: context,
                  onTap: () {
                    Navigator.pop(context, selectedItem);
                  },
                  buttonTitle: appStrings(context).select,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<CategoryItemData>?> showMultiItemsBottomSheet(
    BuildContext context,
    String title,
    List<CategoryItemData> items,
    List<CategoryItemData> currentSelectedItems,
  ) {
    final cubit = context.read<AddEditPropertyCubit>();
    final itemCount = items.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<List<CategoryItemData>?>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        List<CategoryItemData> selectedItems = List.from(currentSelectedItems);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header and Close Button
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${appStrings(context).select} $title",
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black3D.forLightMode(context),
                              ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context, selectedItems);
                        },
                      ),
                    ],
                  ),
                ),
                // List of Items
                isSmall
                    ? ListView.separated(
                        itemCount: items.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final item = items[index];
                          final isSelected = selectedItems.firstWhereOrNull(
                                  (element) => element.sId?.toString().toLowerCase() == item.sId?.toString().toLowerCase()) !=
                              null;

                          return UIComponent.customInkWellWidget(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedItems.remove(item);
                                } else {
                                  selectedItems.add(item);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Row(
                                children: [
                                  isSelected
                                      ? SVGAssets.checkboxEnableIcon.toSvg(height: 18, width: 18, context: context)
                                      : SVGAssets.checkboxDisableIcon.toSvg(height: 18, width: 18, context: context),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.name ?? "",
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            color: AppColors.black14.forLightMode(context),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Divider(
                            color:
                                AppColors.greyE9.adaptiveColor(context, lightModeColor: AppColors.greyE9, darkModeColor: AppColors.black2E),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: items.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final item = items[index];
                            // final isSelected = selectedItems.contains(item);

                            final isSelected = selectedItems.firstWhereOrNull(
                                    (element) => element.sId?.toString().toLowerCase() == item.sId?.toString().toLowerCase()) !=
                                null;
                            return UIComponent.customInkWellWidget(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedItems.remove(item);
                                  } else {
                                    selectedItems.add(item);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                child: Row(
                                  children: [
                                    isSelected
                                        ? SVGAssets.checkboxEnableIcon.toSvg(height: 18, width: 18, context: context)
                                        : SVGAssets.checkboxDisableIcon.toSvg(height: 18, width: 18, context: context),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item.name ?? "",
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: AppColors.black14.forLightMode(context),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Divider(
                              color: AppColors.greyE9
                                  .adaptiveColor(context, lightModeColor: AppColors.greyE9, darkModeColor: AppColors.black2E),
                            ),
                          ),
                        ),
                      ),
                // Select Button
                UIComponent.bottomSheetWithButtonWithGradient(
                  context: context,
                  onTap: () {
                    Navigator.pop(context, selectedItems);
                  },
                  buttonTitle: appStrings(context).select,
                ),
              ],
            );
          },
        );
      },
    );
  }

  static dataLabelWidget({
    required BuildContext context,
    required String? label,
    bool isRequired = false,
  }) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.black3D.adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
        children: [
          TextSpan(
            text: isRequired ? ' *' : '',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.black3D.adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
          ),
        ],
      ),
    );
  }

  Future<void> onSaveClick(BuildContext context) async {
    final AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();

    setState(() {
      isSaveButtonClicked = true;
    });

    // Trigger validation
    cubit.validateAllFields();

    // Ensure UI has time to process validation updates before checking
    await Future.delayed(const Duration(milliseconds: 100));

    // Validate the form before proceeding
    if (cubit.isOverallValid && cubit.isSelected) {
      await cubit.addEditPropertyAPI(propertyId: cubit.reviewPropertyDataId);
    } else {
      if (!cubit.isSelected) {
        Utils.snackBar(
          context: context,
          message: appStrings(context).kindlyAgreeTerms,
        );
      } else {
        return;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
