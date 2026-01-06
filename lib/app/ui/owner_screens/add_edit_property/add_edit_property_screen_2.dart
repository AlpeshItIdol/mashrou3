import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/navigation/app_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/common_row_bottons.dart';
import 'package:mashrou3/app/ui/custom_widget/custom_stepper_widget.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/cubit/add_edit_property_cubit.dart';
import 'package:mashrou3/app/model/property/address_location_response_model.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:mashrou3/utils/validators.dart';
import 'package:place_picker_google/place_picker_google.dart';

import '../../../../config/resources/app_colors.dart';
import '../../../../config/utils.dart';
import '../../../model/nearby_location_model.dart';
import '../../custom_widget/common_button_with_icon.dart';
import '../../custom_widget/loader/overlay_loading_progress.dart';

class AddEditPropertyScreen2 extends StatefulWidget {
  const AddEditPropertyScreen2({super.key});

  @override
  State<AddEditPropertyScreen2> createState() => _AddEditPropertyScreen2State();
}

class _AddEditPropertyScreen2State extends State<AddEditPropertyScreen2> with AppBarMixin {
  bool isRedirecting = false;

  @override
  void initState() {
    super.initState();
    context.read<AddEditPropertyCubit>().editController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        requireLeading: true,
        title: context.read<AddEditPropertyCubit>().isEditModeOn ? appStrings(context).editProperty : appStrings(context).addProperty,
      ),
      bottomNavigationBar: SafeArea(
        child: ButtonRow(
          leftButtonText: appStrings(context).cancel,
          rightButtonText: appStrings(context).next,
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
          onRightButtonTap: () async {
            if (isRedirecting || !context.mounted) return;

            isRedirecting = true;
            final routes = AppRouter.getAllRoutes();
            bool alreadyOpen = routes.contains(RoutePaths.kAddEditPropertyScreen3Path);

            if (!alreadyOpen) {
              context.pushNamed(Routes.kAddEditPropertyScreen3);
            }
            isRedirecting = false;
          },
          leftButtonBgColor: Theme.of(context).cardColor,
          leftButtonBorderColor: Theme.of(context).primaryColor,
          leftButtonTextColor: Theme.of(context).primaryColor,
          isLeftButtonGradient: false,
          isLeftButtonBorderRequired: true,
        ),
      ),
      body: SingleChildScrollView(
        child: _buildBlocConsumer,
      ),
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<AddEditPropertyCubit, AddEditPropertyState>(
      listener: buildBlocListener,
      builder: (context, state) {
        AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();
        return SingleChildScrollView(
          child: Form(
            // key: cubit.formKeyStep2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  const CustomStepperWidget(
                    currentStep: 2,
                    isSixSteps: false,
                    isThreeSteps: true,
                  ),
                  16.verticalSpace,
                  Text(
                    appStrings(context).locationInformation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  22.verticalSpace,

                  /// Property location
                  MyTextFormField(
                    controller: cubit.propertyLocationCtl,
                    focusNode: cubit.propertyLocationFn,
                    fieldName: appStrings(context).propertyLocation,
                    isMandatory: false,
                    readOnly: true,
                    fieldHint: appStrings(context).selectLocation,
                    isShowFieldName: true,
                    maxLines: 2,
                    suffixIcon: SVGAssets.locationBlackIcon.toSvg(
                        height: 22,
                        width: 20,
                        context: context,
                        color: AppColors.colorPrimary
                            .adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white)),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      InputFormatters().textInputArabicFormatter,
                    ],
                    onTap: () async {
                      OverlayLoadingProgress.start(context);
                      await context.read<AddEditPropertyCubit>().getLocation(context, true);
                      OverlayLoadingProgress.stop();
                      UIComponent.showPlacePicker(
                          context: context,
                          onPlacePicked: (LocationResult result) {
                            printf("Selected place: ${result.formattedAddress}");
                            cubit.locationResult = result;
                            cubit.selectedLatLngVal = result.latLng;
                            cubit.propertyLocationCtl.text = result.formattedAddress ?? "";
                            cubit.propertyCountryCtl.text = result.country?.longName ?? "";
                            cubit.propertyCityCtl.text = result.locality?.longName ?? "";
                          },
                          someNullableTextDirection: TextDirection.ltr,
                          initialLocation: cubit.isEditModeOn
                              ? LatLng(cubit.myPropertyDetails.data?.propertyLocation?.latitude ?? cubit.latitude,
                                  cubit.myPropertyDetails.data?.propertyLocation?.longitude ?? cubit.longitude)
                              : LatLng(cubit.latitude, cubit.longitude));
                    },
                    onFieldSubmitted: (v) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                  16.verticalSpace,

                  /// Property Neighborhood
                  ///
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextFormField(
                        fieldName: appStrings(context).propertyNeighborhood,
                        controller: cubit.nearByPropertyLocationCtl,
                        focusNode: cubit.nearByPropertyLocationFn,
                        fieldHint: appStrings(context).selectNeighborhood,
                        isMandatory: false,
                        maxLines: 2,
                        suffixIcon: SVGAssets.locationBlackIcon.toSvg(
                            height: 22,
                            width: 20,
                            context: context,
                            color: AppColors.colorPrimary
                                .adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white)),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {},
                        readOnly: true,
                        onTap: () async {
                          if (!isRedirecting) {
                            isRedirecting = true;
                            context.read<AddEditPropertyCubit>().editController.clear();
                            OverlayLoadingProgress.start(context);
                            await context.read<AddEditPropertyCubit>().getLocation(context, true);
                            OverlayLoadingProgress.stop();
                            UIComponent.showPlacePicker(
                                    context: context,
                                    onPlacePicked: (LocationResult result) async {
                                      if (result.name != null) {
                                        cubit.selectedNeighborhoodTypes.clear();
                                        final editedLocation = await showDialog<String>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Theme.of(context).canvasColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              contentPadding: const EdgeInsetsDirectional.only(
                                                start: 20,
                                                end: 20,
                                                top: 12.0,
                                                bottom: 8.0,
                                              ),
                                              actionsPadding: const EdgeInsetsDirectional.only(
                                                start: 16,
                                                end: 16,
                                                bottom: 8.0,
                                              ),
                                              content: Form(
                                                key: cubit.formKeyLocationDialog,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        appStrings(context).locationTitle,
                                                        style:
                                                            Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                                      ),

                                                      /// Neighborhood Type
                                                      ///
                                                      8.verticalSpace,
                                                      MyTextFormField(
                                                        controller: cubit.editController,
                                                        keyboardType: TextInputType.name,
                                                        validator: (value) {
                                                          return validateNearByPropertyLocation(context, value);
                                                        },
                                                        isMandatory: false,
                                                        isShowFieldName: false,
                                                      ),

                                                      /// Neighborhood Type
                                                      ///
                                                      12.verticalSpace,

                                                      Text(
                                                        appStrings(context).propertyNeighborhoodType,
                                                        style:
                                                            Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                                      ),
                                                      // UIComponent.mandatoryLabel(
                                                      //     context: context,
                                                      //     label: appStrings(context).propertyNeighborhoodType),
                                                      8.verticalSpace,
                                                      BlocBuilder<AddEditPropertyCubit, AddEditPropertyState>(
                                                        builder: (context, state) {
                                                          return Flexible(
                                                            child: ExpansionTile(
                                                              collapsedShape: ContinuousRectangleBorder(
                                                                side: BorderSide(
                                                                  color: AppColors.greyE9.adaptiveColor(
                                                                    context,
                                                                    lightModeColor: AppColors.greyE9,
                                                                    darkModeColor: AppColors.black2E,
                                                                  ),
                                                                  width: 2,
                                                                ),
                                                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                              ),
                                                              shape: ContinuousRectangleBorder(
                                                                side: BorderSide(
                                                                  color: AppColors.greyE9.adaptiveColor(
                                                                    context,
                                                                    lightModeColor: AppColors.greyE9,
                                                                    darkModeColor: AppColors.black2E,
                                                                  ),
                                                                  width: 2,
                                                                ),
                                                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                              ),
                                                              title: Text(
                                                                appStrings(context).select,
                                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                                      color: AppColors.grey77,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                              ),
                                                              initiallyExpanded: false,
                                                              dense: true,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                                  child: Divider(
                                                                    color: AppColors.greyE9.adaptiveColor(
                                                                      context,
                                                                      lightModeColor: AppColors.greyE9,
                                                                      darkModeColor: AppColors.black2E,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 200,
                                                                  width: 200,
                                                                  // Adjust height as needed
                                                                  child: ListView.separated(
                                                                    itemCount: cubit.neighborhoodTypes.length,
                                                                    physics: const ClampingScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    // Ensures the ListView takes only the constrained height
                                                                    itemBuilder: (BuildContext context, int index) {
                                                                      final neighbourhood = cubit.neighborhoodTypes[index];
                                                                      final isSelected =
                                                                          cubit.selectedNeighborhoodTypes.contains(neighbourhood);

                                                                      return InkWell(
                                                                        onTap: () {
                                                                          // Clear previous selection and add the new selection
                                                                          cubit.selectedNeighborhoodTypes.clear();
                                                                          cubit.selectedNeighborhoodTypes.add(neighbourhood);

                                                                          // Rebuild to reflect the selection change
                                                                          (context as Element).markNeedsBuild();
                                                                        },
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              isSelected
                                                                                  ? SVGAssets.checkboxEnableIcon
                                                                                      .toSvg(height: 18, width: 18, context: context)
                                                                                  : SVGAssets.checkboxDisableIcon
                                                                                      .toSvg(height: 18, width: 18, context: context),
                                                                              10.horizontalSpace,
                                                                              Flexible(
                                                                                child: Text(
                                                                                  neighbourhood.name ?? '',
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 2,
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
                                                                    separatorBuilder: (BuildContext context, int index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 0.0),
                                                                        child: Divider(
                                                                          height: 1,
                                                                          color: AppColors.greyE8.adaptiveColor(
                                                                            context,
                                                                            lightModeColor: AppColors.greyE8,
                                                                            darkModeColor: AppColors.black2E,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),

                                                      16.verticalSpace,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    isRedirecting = false;
                                                    Navigator.of(context).pop(); // Close dialog without saving
                                                  },
                                                  child: Text(
                                                    appStrings(context).cancel,
                                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                Material(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      gradient: AppColors.primaryGradient,
                                                      // Use your gradient here
                                                      borderRadius: BorderRadius.circular(8), // Rounded corners
                                                    ),
                                                    child: InkWell(
                                                      borderRadius: BorderRadius.circular(8),
                                                      // Match gradient radius
                                                      onTap: () {
                                                        if (cubit.formKeyLocationDialog.currentState!.validate()) {
                                                          isRedirecting = false;
                                                          Navigator.of(context).pop(cubit.editController.text.trim());
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0, // Smaller padding
                                                        ),
                                                        child: Text(
                                                          appStrings(context).save,
                                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                fontWeight: FontWeight.w500,
                                                                color: Theme.of(context).canvasColor,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (editedLocation != null && editedLocation.isNotEmpty) {
                                          if (!cubit.selectedNeighborhoodProperty.contains(editedLocation)) {
                                            cubit.selectedNeighborhoodProperty.add(NearByLocationModel(
                                                location: editedLocation,
                                                locationLatLng: result.latLng!,
                                                neighborhoodType: cubit.selectedNeighborhoodTypes.first.sId));
                                            cubit.nearByPropertyLocationCtl.text = "";
                                            cubit.locationLatLng = result.latLng!;
                                            cubit.emitNearByState();
                                          }
                                        }
                                      }
                                    },
                                    someNullableTextDirection: TextDirection.ltr,
                                    initialLocation: cubit.isEditModeOn
                                        ? LatLng(cubit.myPropertyDetails.data?.propertyLocation?.latitude ?? cubit.latitude,
                                            cubit.myPropertyDetails.data?.propertyLocation?.longitude ?? cubit.longitude)
                                        : LatLng(cubit.latitude, cubit.longitude))
                                .then((value) {
                              isRedirecting = false;
                            });
                          }
                        },
                        obscureText: false,
                        validator: (value) {
                          return null;
                        },
                      ),
                      8.verticalSpace,
                      // Chips List
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: cubit.selectedNeighborhoodProperty.map((location) {
                          return Chip(
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 4, vertical: 2),
                            backgroundColor: AppColors.colorBgPrimary
                                .adaptiveColor(context, lightModeColor: AppColors.colorBgPrimary, darkModeColor: AppColors.black2E),
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
                            label: UIComponent.customInkWellWidget(
                              onTap: () {
                                Utils.openMapWithMarker(
                                    latitude: location.locationLatLng!.latitude, longitude: location.locationLatLng!.longitude);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SVGAssets.locationBlackIcon.toSvg(
                                      height: 16,
                                      width: 24,
                                      context: context,
                                      color: AppColors.black14
                                          .adaptiveColor(context, lightModeColor: AppColors.black14, darkModeColor: AppColors.white)),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      location.location ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              cubit.selectedNeighborhoodProperty.remove(location);
                              cubit.emitNearByState(); // Update UI
                            },
                          );
                        }).toList(),
                      ),
                      12.verticalSpace
                    ],
                  ),

                  /// Country
                  ///
                  MyTextFormField(
                    controller: cubit.propertyCountryCtl,
                    focusNode: cubit.propertyCountryFn,
                    fieldName: appStrings(context).lblCountry,
                    isMandatory: false,
                    maxLines: 2,
                    readOnly: true,
                    fieldHint: appStrings(context).lblCountry,
                    isDisable: true,
                    isShowFieldName: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      InputFormatters().textInputArabicFormatter,
                    ],
                    onFieldSubmitted: (v) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                  16.verticalSpace,

                  /// City
                  ///
                  MyTextFormField(
                    controller: cubit.propertyCityCtl,
                    focusNode: cubit.propertyCityFn,
                    fieldName: appStrings(context).lblCity,
                    isMandatory: false,
                    maxLines: 2,
                    readOnly: true,
                    isDisable: true,
                    fieldHint: appStrings(context).lblCity,
                    isShowFieldName: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      InputFormatters().textInputArabicFormatter,
                    ],
                    onFieldSubmitted: (v) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                  12.verticalSpace,
                  _buildVideoLinksWidget(),
                  18.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Location Keys (Area Name) - Single dropdown selection
  ///
  Widget _buildVideoLinksWidget() {
    AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();
    final hasSelectedLocation = cubit.selectedAddressLocations.isNotEmpty;
    final selectedLocation = hasSelectedLocation ? cubit.selectedAddressLocations.first : null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Text(
            appStrings(context).lblNeighbourLocations,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.black3D.adaptiveColor(
                    context,
                    lightModeColor: AppColors.black3D,
                    darkModeColor: AppColors.greyB0)),
          ),
        ),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: hasSelectedLocation ? 8 : 10,
              child: UIComponent.customInkWellWidget(
                onTap: () async {
                  final selected = await showAddressLocationSheet(
                      context, cubit.addressLocationList ?? [], 0);
                  if (selected != null) {
                    setState(() {
                      cubit.setSingleAddressLocation(selected);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    border: Border.all(
                        color: AppColors.greyE8.adaptiveColor(context,
                            lightModeColor: AppColors.greyE8,
                            darkModeColor: AppColors.black2E)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedLocation?.text ??
                              appStrings(context).lblNeighbourLocationPlaceholder,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: hasSelectedLocation
                                  ? Theme.of(context).primaryColor
                                  : AppColors.black14.adaptiveColor(context,
                                      lightModeColor: AppColors.black14,
                                      darkModeColor: AppColors.grey77),
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SVGAssets.arrowDownIcon.toSvg(
                          context: context,
                          color: Theme.of(context).highlightColor),
                    ],
                  ),
                ),
              ),
            ),
            if (hasSelectedLocation)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: CommonButtonWithIcon(
                    onTap: () {
                      setState(() {
                        cubit.clearSingleAddressLocation();
                      });
                    },
                    isGradientColor: false,
                    icon: SVGAssets.deleteIcon.toSvg(context: context),
                    borderColor: AppColors.red00,
                    buttonBgColor: AppColors.white.adaptiveColor(context,
                        lightModeColor: AppColors.white,
                        darkModeColor: AppColors.black14),
                  ),
                ),
              ),
          ],
        ),
        12.verticalSpace,
      ],
    );
  }

  Future<AddressLocationItem?> showAddressLocationSheet(
      BuildContext context, List<AddressLocationItem> dataList, int currentIndex) {
    AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();
    final itemCount = dataList.length;
    final isSmall = itemCount <= 5;

    return showModalBottomSheet<AddressLocationItem>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Address Location",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black3D.forLightMode(context)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
            isSmall
                ? ListView.separated(
                    itemCount: dataList.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final item = dataList[index];
                      final isSelected = currentIndex < cubit.selectedAddressLocations.length &&
                          cubit.selectedAddressLocations[currentIndex].sId == item.sId;
                      return UIComponent.customInkWellWidget(
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.text ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppColors.black14
                                          .forLightMode(context),
                                    ),
                              ),
                              if (isSelected)
                                Icon(Icons.check,
                                    color: Theme.of(context).primaryColor)
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: AppColors.greyE8.adaptiveColor(context,
                              lightModeColor: AppColors.greyE8,
                              darkModeColor: AppColors.grey50),
                        ),
                      );
                    },
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: dataList.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final item = dataList[index];
                        final isSelected = currentIndex < cubit.selectedAddressLocations.length &&
                            cubit.selectedAddressLocations[currentIndex].sId == item.sId;
                        return UIComponent.customInkWellWidget(
                          onTap: () {
                            Navigator.pop(context, item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.text ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.black14.forLightMode(
                                            context),
                                      ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check,
                                      color: Theme.of(context).primaryColor)
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 20.0),
                          child: Divider(
                            height: 1,
                            color: AppColors.greyE8.adaptiveColor(context,
                                lightModeColor: AppColors.greyE8,
                                darkModeColor: AppColors.grey50),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }

  String? validateDataDuplicatesForLocation(BuildContext context, String? value, int index) {
    AddEditPropertyCubit cubit = context.read<AddEditPropertyCubit>();

    if ((value ?? "").isNotEmpty) {
      bool isDuplicate = cubit.locationKeys.asMap().entries.any((entry) {
        return entry.key != index && entry.value == value;
      });

      if (isDuplicate) {
        return appStrings(context).errorDuplicateLocation;
      }
    }
    return null;
  }

  @override
  void dispose() {
    // context.read<AddEditPropertyCubit>().clearScreen2Controllers();
    super.dispose();
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(BuildContext context, AddEditPropertyState state) {}
}
