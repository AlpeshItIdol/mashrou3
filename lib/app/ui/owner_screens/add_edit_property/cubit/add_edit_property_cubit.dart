import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/model/contact_number_model.dart';
import 'package:mashrou3/app/model/property/add_edit_property_response_model.dart';
import 'package:mashrou3/app/model/property/property_category_response_model.dart';
import 'package:mashrou3/app/model/property/property_detail_response_model.dart';
import 'package:mashrou3/app/model/property/property_neighbourhood_response_model.dart';
import 'package:mashrou3/app/model/property/address_location_response_model.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/model/category_item_data_response_model.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/model/sub_category_response_model.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/country_selection_cubit.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:place_picker_google/place_picker_google.dart';

import '../../../../../config/utils.dart';
import '../../../../../utils/location_manager.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/country_list_model.dart';
import '../../../../model/country_request_mode.dart';
import '../../../../model/nearby_location_model.dart';
import '../../../../model/neighborhood_property_model.dart';
import '../../../../model/property/add_property_request_model.dart';
import '../../../../model/property/currency_list_response_model.dart';
import '../model/sub_category_request_model.dart';

part 'add_edit_property_state.dart';

class AddEditPropertyCubit extends Cubit<AddEditPropertyState> {
  AddEditPropertyCubit({required this.propertyRepository}) : super(AddEditPropertyInitial());

  PropertyRepository propertyRepository;

  final formKeyLocationDialog = GlobalKey<FormState>();
  TextEditingController propertyCategoryCtl = TextEditingController();
  FocusNode propertyCategoryFn = FocusNode();
  TextEditingController propertyTitleCtl = TextEditingController();
  FocusNode propertyTitleFn = FocusNode();
  TextEditingController propertyPriceCtl = TextEditingController();
  FocusNode propertyPriceFn = FocusNode();
  TextEditingController currencyCtl = TextEditingController();
  FocusNode currencyFn = FocusNode();
  TextEditingController mobileNumberCtl = TextEditingController();
  FocusNode mobileNumberFn = FocusNode();
  TextEditingController altMobileNumberCtl = TextEditingController();
  FocusNode altMobileNumberFn = FocusNode();
  TextEditingController propertyAreaCtl = TextEditingController();
  FocusNode propertyAreaFn = FocusNode();
  TextEditingController property3DTourCtl = TextEditingController();
  FocusNode property3DTourFn = FocusNode();
  TextEditingController propertyDescCtl = TextEditingController();
  FocusNode propertyDescFn = FocusNode();
  TextEditingController propertyLocationCtl = TextEditingController();
  FocusNode propertyLocationFn = FocusNode();
  TextEditingController nearByPropertyLocationCtl = TextEditingController();
  FocusNode nearByPropertyLocationFn = FocusNode();
  LocationResult locationResult = LocationResult();
  TextEditingController propertyCountryCtl = TextEditingController();
  FocusNode propertyCountryFn = FocusNode();
  TextEditingController propertyCityCtl = TextEditingController();
  FocusNode propertyCityFn = FocusNode();
  TextEditingController searchCtl = TextEditingController(text: "");
  FocusNode searchFn = FocusNode();
  TextEditingController editController = TextEditingController(text: "");
  Key? uniqueKey1;
  bool isEditModeOn = false;
  bool isForInReview = false;
  bool showSuffixIcon = false;
  List<String> videoLinksList = [];
  List<String> locationKeys = []; // Keep for backward compatibility, will store IDs
  List<AddressLocationItem>? addressLocationList = [];
  List<AddressLocationItem> selectedAddressLocations = [];
  List<CountryListData>? countryList = [];
  List<CountryListData> filteredCountries = [];
  List<PropertyCategoryData>? propertyCategoryList = [];
  List<PropertySubCategoryData>? propertySubCategoryList = [];
  List<CurrencyListData>? currencyList = [];
  List<dynamic> propertyAttachmentList = [];
  var thumbnailImgList = <String>[];
  List<PropertyNeighbourhoodData> neighborhoodTypes = [];
  List<PropertyNeighbourhoodData> selectedNeighborhoodTypes = [];
  List<CategoryItemData> selectedAmenitiesData = [];

  CountryListData selectedCountry = CountryListData();
  CurrencyListData selectedCurrency = CurrencyListData(
    sId: '5d441ff23b574544e86e97bf',
    currencySymbol: 'د.أ',
    currencyCode: 'JOD',
    currencyName: 'Jordanian Dinar',
  );
  CountryListData selectedMobileNoCountry = CountryListData();
  CountryListData selectedAltMobileNoCountry = CountryListData();
  PropertyCategoryData selectedPropertyCategory = PropertyCategoryData();
  PropertySubCategoryData selectedPropertySubCategory = PropertySubCategoryData();
  CategoryItem categoryItemData = CategoryItem();
  String countryCodeMobileNo = '';
  String countryCodeAltMobileNo = '';
  bool isDataLoaded = false;
  bool isValid = false;
  bool isValidForSingleSelection = false;
  List<TextEditingController> videoLinksControllers = [TextEditingController()];
  List<TextEditingController> locationKeysControllers = [TextEditingController()];
  var addPropertyRequestModel = AddPropertyRequestModel();
  String propertyId = "";
  String reviewPropertyDataId = "";
  LatLng? selectedLatLngVal;
  var myPropertyDetails = PropertyDetailsResponseModel();
  bool isSelected = false;
  bool isCategorySelected = false;
  LatLng? locationLatLng;
  List<NearByLocationModel> selectedNeighborhoodProperty = [];
  double latitude = 31.963158; // Downtown Amman
  double longitude = 35.930359; // Downtown Amman
  final categoryOptions = <String, CategoryItemOptions>{};
  final categorySelectedOptions = <String, CategoryItemOptions>{};

  Map<String, CategoryItemData> selectedItems = {};
  Map<String, List<CategoryItemData>> selectedMultiItems = {};
  Map<String, bool> validationMap = {};

  List<SubCategoryRequestModel> subCategoryRequestModels = [];
  List<SubCategoryMultiRequestModel> subCategoryMultiRequestModels = [];

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context, String sID, bool isReview) async {
    emit(AddEditPropertyFieldsLoading());
    isDataLoaded = false;
    isForInReview = isReview;
    isEditModeOn = false;
    isValid = false;
    isSelected = false;
    subCategoryMultiRequestModels.clear();
    subCategoryRequestModels.clear();
    selectedItems.clear();
    selectedMultiItems.clear();
    validationMap.clear();
    reviewPropertyDataId = sID;
    currencyCtl.text = 'د.أ';
    selectedLatLngVal = AppConstants.defaultLatLng;
    if (sID.isEmpty || sID.toString() == "0") {
      clearScreen1Controllers();
      clearScreen2Controllers();
      clearScreen3Controllers();
    }
    selectedMobileNoCountry = AppConstants.defaultCountry;
    selectedAltMobileNoCountry = AppConstants.defaultCountry;

    OverlayLoadingProgress.start(context);

    await Future.wait([
      getCurrencyList(),
      getPropertyCategoryList(),
      getCountryList(context),
      getPropertyNeighbourhoodList(),
      getAddressLocationList(),
    ]);

    videoLinksList.clear();
    locationKeys.clear();
    selectedAddressLocations.clear();
    if (sID.isNotEmpty && sID.toString() != "0") {
      isEditModeOn = true;
      if (!context.mounted) return;
      await getPropertyDetails(propertyId: sID, context: context, isReview: isReview);
      await getPropertyCategoryData(context);
      if (isEditModeOn = true) {
        // categoryOptions.clear();
        isCategorySelected = true;

        await getPropertySubCategoryList(catId: selectedPropertyCategory.sId ?? "0");
        selectedPropertySubCategory.name = propertySubCategoryList
            ?.firstWhere(
              (item) => item.sId == myPropertyDetails.data?.subCategoryId,
              orElse: () => PropertySubCategoryData(), // In case no match is found, return null
            )
            .name;

        printf("categoryname----- ${selectedPropertySubCategory.name}");
        // assuming you already have the response data
        Map<String, dynamic> detailsResponse = myPropertyDetails.data?.toJson() ?? PropertyDetailData().toJson();

        printf(detailsResponse.toString());
        await Future.delayed(const Duration(milliseconds: 600));
        await populateSelectedItemsFromOptions(detailsResponse);
      }
    }
    if (videoLinksList.isEmpty) {
      videoLinksList.add("");
      videoLinksControllers.add(TextEditingController());
    }
    if (locationKeys.isEmpty) {
      locationKeys.add("");
      locationKeysControllers.add(TextEditingController());
    }
    OverlayLoadingProgress.stop();
    emit(AddEditPropertyFieldsLoaded());
  }

  Future<void> populateSelectedItemsFromOptions(Map<String, dynamic> detailsResponse) async {
    // Clear existing selections
    selectedItems.clear();
    selectedMultiItems.clear();

    // Iterate over category options
    for (var entry in categoryOptions.entries) {
      String categoryKey = entry.key;
      CategoryItemOptions options = entry.value;

      printf("options----- ${options.toJson().toString()}");
      if (options.isMultiple == true) {
        List<CategoryItemData> matchingItems = options.data?.where((item) {
              // Check if detailsResponse[categoryKey] is a list or a single item
              var categoryValue = detailsResponse["propertyAmenitiesData"];

              printf("categoryValue----- ${categoryValue.toString()}");

              if (categoryValue is List) {
                // If it's a list, check if any item has a matching _id
                return categoryValue.any((amenity) => amenity['_id'] == item.sId);
              } else if (categoryValue is String || categoryValue is Map) {
                // If it's a single value or a map (handle case where it's not a list)
                return categoryValue['_id'] == item.sId;
              }

              return false; // If it's neither a list nor a valid value, return false
            }).toList() ??
            [];

        if (matchingItems.isNotEmpty) {
          selectedMultiItems[categoryKey] = matchingItems;
        }
      } else {
        // Handle single-select items
        CategoryItemData? matchingItem = options.data?.firstWhere(
          (item) => detailsResponse[categoryKey].toString() == item.sId.toString(),
          orElse: () => CategoryItemData(),
        );

        if (matchingItem != null) {
          selectedItems[categoryKey] = matchingItem;
        }
      }
    }
    printf(selectedMultiItems.toString());
    printf(selectedItems.toString());
  }

  Future<void> getLocation(BuildContext context, bool isNeighbourhood) async {
    await getLatLng(context, isNeighbourhood);
  }

  Future<void> getLatLng(BuildContext context, bool isNeighbourhood) async {
    var position = await LocationManager.fetchLocation(context: context, isNeighbourhood: isNeighbourhood);
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;

      printf('Latitude: $latitude, Longitude: $longitude');
    } else {
      printf('Failed to fetch location.');
    }
  }

  Future<void> getPropertyCategoryData(BuildContext context) async {
    await getPropertyCategoryDataApi(propertyCatId: context.read<AddEditPropertyCubit>().selectedPropertyCategory.sId ?? "");
    if (isEditModeOn) {
      setCategoryItemData(categoryItemData, myPropertyDetails.data ?? PropertyDetailData());
      await _setCategoryOptions(myPropertyDetails.data ?? PropertyDetailData());
      // isSelected = true;
    }
  }

  void updateSelectedMobileCountry(CountryListData country) {
    selectedMobileNoCountry = country;
    emit(AddPropertyCountryChangedState(country)); // Trigger rebuild
  }

  void updateSelectedAltMobileCountry(CountryListData country) {
    selectedAltMobileNoCountry = country;
    emit(AddPropertyAltCountryChangedState(country)); // Trigger rebuild
  }

  /// Currency List API
  ///
  Future<void> getCurrencyList() async {
    emit(AddEditPropertyLoading());

    final response = await propertyRepository.getCurrencyList();

    if (response is SuccessResponse && response.data is CurrencyListResponseModel) {
      CurrencyListResponseModel responseModel = response.data as CurrencyListResponseModel;
      currencyList = responseModel.data ?? [];
      emit(CurrencyListAPISuccess(model: responseModel));
    } else if (response is FailedResponse) {
      emit(AddEditPropertyCountryFetchError(response.errorMessage));
    }
  }

  void addVideoLink(String question) {
    if (videoLinksList.length < 3) {
      videoLinksList.add(question);
      videoLinksControllers.add(TextEditingController());
      emit(AddMoreVideoLinks(
        videoLinks: List.from(videoLinksList),
        videoLinksCtls: List.from(videoLinksControllers),
      ));
    }
  }

  void updateVideoLink(int index, String profileLink) {
    if (index >= 0 && index < videoLinksList.length) {
      videoLinksList[index] = profileLink;
      emit(AddMoreVideoLinks(
        videoLinks: List.from(videoLinksList),
        videoLinksCtls: List.from(videoLinksControllers),
      ));
    }
  }

  void deleteVideoLink(int index) {
    if (index >= 0 && index < videoLinksList.length) {
      videoLinksList.removeAt(index);

      // Dispose the controller before removing it from the list
      videoLinksControllers[index].dispose();
      videoLinksControllers.removeAt(index);

      emit(AddMoreVideoLinks(
        videoLinks: List.from(videoLinksList),
        videoLinksCtls: List.from(videoLinksControllers),
      ));
    }
  }

  void addLocationKeys(String question) {
    locationKeys.add(question);
    locationKeysControllers.add(TextEditingController());
    // Also add empty AddressLocationItem for UI consistency
    selectedAddressLocations.add(AddressLocationItem(sId: question, text: question));
    emit(AddMoreNeighbourhoodKeys(
      neighbourhoodKeys: List.from(locationKeys),
      neighbourhoodKeysCtrl: List.from(locationKeysControllers),
    ));
  }

  void updateLocationKeys(int index, String profileLink) {
    if (index >= 0 && index < locationKeys.length) {
      locationKeys[index] = profileLink;
      emit(AddMoreNeighbourhoodKeys(
        neighbourhoodKeys: List.from(locationKeys),
        neighbourhoodKeysCtrl: List.from(locationKeysControllers),
      ));
    }
  }

  void deleteLocationKeys(int index) {
    if (index >= 0 && index < locationKeys.length) {
      locationKeys.removeAt(index);

      // Dispose the controller before removing it from the list
      locationKeysControllers[index].dispose();
      locationKeysControllers.removeAt(index);
      
      // Also remove from selectedAddressLocations if it exists
      if (index < selectedAddressLocations.length) {
        selectedAddressLocations.removeAt(index);
      }

      emit(AddMoreNeighbourhoodKeys(
        neighbourhoodKeys: List.from(locationKeys),
        neighbourhoodKeysCtrl: List.from(locationKeysControllers),
      ));
    }
  }

  // New methods for address location dropdown
  void addAddressLocation(AddressLocationItem location) {
    if (!selectedAddressLocations.contains(location)) {
      selectedAddressLocations.add(location);
      locationKeys.add(location.sId ?? "");
      locationKeysControllers.add(TextEditingController(text: location.text ?? ""));
      emit(AddMoreNeighbourhoodKeys(
        neighbourhoodKeys: List.from(locationKeys),
        neighbourhoodKeysCtrl: List.from(locationKeysControllers),
      ));
    }
  }

  void removeAddressLocation(int index) {
    // deleteLocationKeys will handle removing from both lists
    deleteLocationKeys(index);
  }

  void setAddressLocationForIndex(int index, AddressLocationItem location) {
    if (index >= 0) {
      // If index exists, update it; otherwise add it
      if (index < selectedAddressLocations.length) {
        selectedAddressLocations[index] = location;
      } else {
        selectedAddressLocations.add(location);
      }
      
      // Update locationKeys
      if (index < locationKeys.length) {
        locationKeys[index] = location.sId ?? "";
      } else {
        locationKeys.add(location.sId ?? "");
      }
      
      // Update controller
      if (index < locationKeysControllers.length) {
        locationKeysControllers[index].text = location.text ?? "";
      } else {
        locationKeysControllers.add(TextEditingController(text: location.text ?? ""));
      }
      
      emit(AddMoreNeighbourhoodKeys(
        neighbourhoodKeys: List.from(locationKeys),
        neighbourhoodKeysCtrl: List.from(locationKeysControllers),
      ));
    }
  }

  /// Set a single address location (replaces the entire list)
  void setSingleAddressLocation(AddressLocationItem? location) {
    selectedAddressLocations.clear();
    locationKeys.clear();
    // Dispose existing controllers
    for (var controller in locationKeysControllers) {
      controller.dispose();
    }
    locationKeysControllers.clear();
    
    if (location != null) {
      selectedAddressLocations.add(location);
      locationKeys.add(location.sId ?? "");
      locationKeysControllers.add(TextEditingController(text: location.text ?? ""));
    }
    
    emit(AddMoreNeighbourhoodKeys(
      neighbourhoodKeys: List.from(locationKeys),
      neighbourhoodKeysCtrl: List.from(locationKeysControllers),
    ));
  }

  /// Clear the single address location
  void clearSingleAddressLocation() {
    setSingleAddressLocation(null);
  }

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }

  // Update validation status for a specific key
  void updateValidationStatus(String key, bool isValid) {
    emit(ValidationStateInit());
    validationMap[key] = isValid;
    emit(ValidationStateUpdate()); // Trigger UI rebuild
  }

  // Validate all fields before submission
  void validateAllFields() {
    validationMap.forEach((key, _) {
      bool isValid = selectedItems[key] != null || selectedMultiItems[key]?.isNotEmpty == true;
      updateValidationStatus(key, isValid);
    });
  }

  // Check overall validity by ensuring all keys are valid
  bool get isOverallValid {
    emit(ValidateExecuted());
    return validationMap.values.every((isValid) => isValid);
  }

  /// Method to set the selected item
  ///
  void setSelectedItemForCategory(CategoryItemData selectedItem, String uniqueKey) {
    emit(SingleItemStateInit());

    selectedItems[uniqueKey] = selectedItem;
    emit(SingleItemStateUpdate());
  }

  /// Method to set the selected multi items
  ///
  void setSelectedItemsForCategory(List<CategoryItemData> selectedItems, String uniqueKey) {
    emit(MultiItemStateInit());

    selectedMultiItems[uniqueKey] = selectedItems;
    emit(MultiItemStateUpdate());
  }

  /// Country Code List API
  ///
  Future<void> getCountryList(BuildContext context) async {
    emit(AddEditPropertyCountryFetching());

    final model = CountryListRequestModel(
      searchQuery: searchCtl.text,
    );

    final response = await context.read<CommonApiCubit>().fetchCountryList(requestModel: model);

    if (response is String) {
      emit(AddEditPropertyCountryFetchError(response));
    } else {
      countryList = response;
      printf("CountryList--------${countryList?.length}");
      filteredCountries = countryList ?? [];
      emit(AddEditPropertyCountryFetchSuccess());
    }
  }

  void updateAttachments(List<dynamic> documents, BuildContext context) {
    printf('Attachments ${documents.length}');

    emit(AddEditPropertyAttachmentLoaded());
  }

  void updateThumbnail(List<dynamic> images, BuildContext context) {
    printf('Thumbnail ${images.length}');

    emit(AddEditPropertyThumbnailLoaded());
  }

  void emitNearByState() {
    emit(NearByPropertyAddedState(
      selectedLocations: List.from(selectedNeighborhoodProperty),
    ));
  }

  /// Property category list API
  Future<void> getPropertyCategoryList() async {
    emit(AddEditPropertyCategoryLoading());

    final response = await propertyRepository.getPropertyCategories();

    if (response is SuccessResponse && response.data is PropertyCategoryResponseModel) {
      PropertyCategoryResponseModel categoryResponse = response.data as PropertyCategoryResponseModel;

      propertyCategoryList = categoryResponse.data ?? [];
      printf("PropertyCategoryList--------${propertyCategoryList?.length}");

      emit(AddEditPropertyCategorySuccess());
    } else if (response is FailedResponse) {
      emit(AddEditPropertyCategoryFailure(response.errorMessage));
    }
  }

  /// Property category list API
  Future<void> getPropertySubCategoryList({required String catId}) async {
    emit(AddEditPropertySubCategoryLoading());
    selectedItems.clear();
    selectedMultiItems.clear();
    final response = await propertyRepository.getPropertySubCategories(categoryId: catId);

    if (response is SuccessResponse && response.data is SubCategoryResponseModel) {
      SubCategoryResponseModel subCategoryResponseModel = response.data as SubCategoryResponseModel;

      propertySubCategoryList = subCategoryResponseModel.data ?? [];
      if (isEditModeOn) {
        selectedPropertySubCategory.name = propertySubCategoryList
            ?.firstWhere(
              (item) => item.sId == myPropertyDetails.data?.subCategoryId,
              orElse: () => PropertySubCategoryData(), // In case no match is found, return null
            )
            .name;
        selectedPropertySubCategory.sId = propertySubCategoryList
            ?.firstWhere(
              (item) => item.sId == myPropertyDetails.data?.subCategoryData?.sId,
              orElse: () => PropertySubCategoryData(), // In case no match is found, return null
            )
            .sId;
      }
      printf("Property SubCategory List--------${propertySubCategoryList?.length}");

      emit(AddEditPropertySubCategorySuccess(dataList: subCategoryResponseModel.data ?? []));
    } else if (response is FailedResponse) {
      emit(AddEditPropertySubCategoryFailure(response.errorMessage));
    }
  }

  /// Property Neighbourhood list API
  Future<void> getPropertyNeighbourhoodList() async {
    emit(AddEditPropertyCategoryLoading());

    final response = await propertyRepository.getPropertyNeighbourhood();

    if (response is SuccessResponse && response.data is PropertyNeighbourhoodResponseModel) {
      PropertyNeighbourhoodResponseModel propertyNeighbourhoodResponseModel = response.data as PropertyNeighbourhoodResponseModel;

      neighborhoodTypes = propertyNeighbourhoodResponseModel.data ?? [];
      printf("PropertyNeighbourhoodList--------${neighborhoodTypes.length}");

      emit(AddEditPropertyCategorySuccess());
    } else if (response is FailedResponse) {
      emit(AddEditPropertyCategoryFailure(response.errorMessage));
    }
  }

  /// Address Location List API
  Future<void> getAddressLocationList() async {
    emit(AddEditPropertyCategoryLoading());

    final response = await propertyRepository.getAddressLocation(
      page: 1,
      limit: 100,
      search: "",
      isAll: true,
    );

    if (response is SuccessResponse &&
        response.data is AddressLocationResponseModel) {
      AddressLocationResponseModel responseModel =
          response.data as AddressLocationResponseModel;
      addressLocationList = responseModel.data?.locationData ?? [];
      printf("AddressLocationList--------${addressLocationList?.length ?? 0}");
      emit(AddEditPropertyCategorySuccess());
    } else if (response is FailedResponse) {
      emit(AddEditPropertyCategoryFailure(response.errorMessage));
    }
  }

  /// Property category fields API
  Future<void> getPropertyCategoryDataApi({
    required String propertyCatId,
  }) async {
    emit(PropertyCategoryDataLoading());
    categoryItemData = CategoryItem();
    final response = await propertyRepository.getPropertyCategoryData(categoryId: propertyCatId);

    if (response is SuccessResponse && response.data is CategoryItemDataResponseModel) {
      CategoryItemDataResponseModel responseModel = response.data as CategoryItemDataResponseModel;

      categoryItemData = responseModel.data ?? CategoryItem();

      await initializeFields(responseModel.data ?? CategoryItem());
      emit(PropertyCategoryDataSuccess());
    } else if (response is FailedResponse) {
      emit(PropertyCategoryDataFailure(response.errorMessage));
    }
  }

  Future<void> initializeFields(CategoryItem categoryItem) async {
    emit(PropertyCategoryFieldsLoading());

    try {
      Map<String, CategoryItemOptions> newCategoryOptions = {};

      if (categoryItem.floors != null) {
        newCategoryOptions[categoryItem.floors!.key ?? ''] = CategoryItemOptions(
          data: categoryItem.floors!.data,
          required: false, // Make non-mandatory
          label: categoryItem.floors!.label,
          isMultiple: categoryItem.floors!.isMultiple,
          key: categoryItem.floors!.key,
        );
      }
      if (categoryItem.bedrooms != null) {
        newCategoryOptions[categoryItem.bedrooms!.key ?? ''] = CategoryItemOptions(
          data: categoryItem.bedrooms!.data,
          required: false, // Make non-mandatory
          label: categoryItem.bedrooms!.label,
          isMultiple: categoryItem.bedrooms!.isMultiple,
          key: categoryItem.bedrooms!.key,
        );
      }
      if (categoryItem.bathrooms != null) {
        newCategoryOptions[categoryItem.bathrooms!.key ?? ''] = CategoryItemOptions(
          data: categoryItem.bathrooms!.data,
          required: false, // Make non-mandatory
          label: categoryItem.bathrooms!.label,
          isMultiple: categoryItem.bathrooms!.isMultiple,
          key: categoryItem.bathrooms!.key,
        );
      }
      if (categoryItem.facades != null) {
        newCategoryOptions[categoryItem.facades!.key ?? ''] = CategoryItemOptions(
          data: categoryItem.facades!.data,
          required: false, // Make non-mandatory
          label: categoryItem.facades!.label,
          isMultiple: categoryItem.facades!.isMultiple,
          key: categoryItem.facades!.key,
        );
      }
      if (categoryItem.amenities != null) {
        newCategoryOptions[categoryItem.amenities!.key ?? ''] = CategoryItemOptions(
          data: categoryItem.amenities!.data,
          required: false, // Make non-mandatory
          label: categoryItem.amenities!.label,
          isMultiple: categoryItem.amenities!.isMultiple,
          key: categoryItem.amenities!.key,
        );
      }
      if (categoryItem.furnishedTypes != null) {
        newCategoryOptions[categoryItem.furnishedTypes!.key ?? ''] = CategoryItemOptions(
          data: categoryItem.furnishedTypes!.data,
          required: false, // Make non-mandatory
          label: categoryItem.furnishedTypes!.label,
          isMultiple: categoryItem.furnishedTypes!.isMultiple,
          key: categoryItem.furnishedTypes!.key,
        );
      }
      if (categoryItem.buildingAge != null) {
        newCategoryOptions[categoryItem.buildingAge!.key ?? ''] = CategoryItemOptions(
          data: categoryItem.buildingAge!.data,
          required: false, // Make non-mandatory
          label: categoryItem.buildingAge!.label,
          isMultiple: categoryItem.buildingAge!.isMultiple,
          key: categoryItem.buildingAge!.key,
        );
      }
      if (categoryItem.mortgaged != null) {
        newCategoryOptions[categoryItem.mortgaged!.key ?? ''] = CategoryItemOptions(
          data: categoryItem.mortgaged!.data,
          required: false, // Make non-mandatory
          label: categoryItem.mortgaged!.label,
          isMultiple: categoryItem.mortgaged!.isMultiple,
          key: categoryItem.mortgaged!.key,
        );
      }

      categoryOptions.addAll(newCategoryOptions);

      emit(AddEditPropertyCategoryFieldsLoaded(categories: categoryOptions));
    } catch (error) {
      emit(AddEditPropertyCategoryFieldsFailure(error.toString()));
    }
  }

  List<CategoryItemData> getSelectedItems(String categoryId) {
    final currentState = state;
    if (currentState is CategoryOptionState) {
      return currentState.categories[categoryId]?.selectedItems ?? <CategoryItemData>[];
    }
    return <CategoryItemData>[];
  }

  void handleError(String errorMessage) {
    emit(CategoryOptionState(
      categories: (state is CategoryOptionState) ? (state as CategoryOptionState).categories : {},
      errorMessage: errorMessage,
    ));
  }

  /// Property Details API
  Future<void> getPropertyDetails({
    required String propertyId,
    required bool isReview,
    required BuildContext context,
  }) async {
    emit(PropertyDetailsLoading());

    final response = isReview
        ? await propertyRepository.getReviewPropertyDetails(propertyId: propertyId)
        : await propertyRepository.getPropertyDetails(context: context, propertyId: propertyId);

    if (response is SuccessResponse && response.data is PropertyDetailsResponseModel) {
      PropertyDetailsResponseModel responseModel = response.data as PropertyDetailsResponseModel;
      if (responseModel.data != null) {
        setEditData(responseModel.data!, context);
      }
      await Future.delayed(const Duration(milliseconds: 600));
      emit(PropertyDetailsSuccess(model: responseModel));
      myPropertyDetails = responseModel;
    } else if (response is FailedResponse) {
      emit(PropertyDetailsFailure(response.errorMessage));
    }
  }

  Future<void> setEditData(PropertyDetailData propertyDetailData, BuildContext context) async {
    selectedPropertyCategory.sId = propertyDetailData.categoryId ?? "";
    selectedPropertyCategory.name = getNameById(propertyCategoryList, propertyDetailData.categoryId ?? "");
    propertyTitleCtl.text = propertyDetailData.title ?? "";
    propertyPriceCtl.text = propertyDetailData.price?.amount ?? "";
    selectedCurrency = currencyList!.firstWhere(
      (currency) => currency.currencyCode == propertyDetailData.price?.currencyCode,
      orElse: () => CurrencyListData(), // Provide a default value if no match is found
    );
    mobileNumberCtl.text = propertyDetailData.contactNumber?.contactNumber?.toString() ?? '';
    selectedMobileNoCountry = propertyDetailData.contactNumber != null
        ? CountryListData(
            phoneCode: propertyDetailData.contactNumber?.phoneCode ?? "",
            countryCode: propertyDetailData.contactNumber?.countryCode ?? "",
            emoji: propertyDetailData.contactNumber?.emoji ?? "")
        : AppConstants.defaultCountry;
    context.read<CountrySelectionCubit>().selectedMobileNoCountry = selectedMobileNoCountry;
    altMobileNumberCtl.text = propertyDetailData.alternateContactNumber?.contactNumber?.toString() ?? '';
    selectedAltMobileNoCountry = propertyDetailData.alternateContactNumber != null
        ? CountryListData(
            phoneCode: propertyDetailData.alternateContactNumber?.phoneCode ?? "",
            countryCode: propertyDetailData.alternateContactNumber?.countryCode ?? "",
            emoji: propertyDetailData.alternateContactNumber?.emoji ?? "")
        : AppConstants.defaultCountry;
    context.read<CountrySelectionCubit>().selectedAltMobileNoCountry = selectedAltMobileNoCountry;
    if (propertyDetailData.propertyFiles != null) {
      propertyAttachmentList = [];
      propertyAttachmentList.addAll(propertyDetailData.propertyFiles ?? []);
    }

    if (propertyDetailData.thumbnail != null) {
      thumbnailImgList = [];
      if (propertyDetailData.thumbnail!.isNotEmpty) {
        thumbnailImgList.add(propertyDetailData.thumbnail!);
      }
    }
    videoLinksList = propertyDetailData.videoLink ?? [];
    videoLinksControllers.clear();
    for (var link in videoLinksList) {
      videoLinksControllers.add(TextEditingController(text: link));
    }
    emit(AddMoreVideoLinks(
      videoLinks: List.from(videoLinksList),
      videoLinksCtls: List.from(videoLinksControllers),
    ));

    // Prepare neighbour locations (Area Names) - Single selection only
    final allLocationKeys = propertyDetailData.locationKeys ?? [];
    // Take only the first location key for single selection
    locationKeys = allLocationKeys.isNotEmpty && allLocationKeys.first.isNotEmpty 
        ? [allLocationKeys.first] 
        : [];
    locationKeysControllers.clear();
    selectedAddressLocations.clear();
    
    // Store locationKeys IDs - will be matched with addressLocationList when it loads
    // For single selection, only process the first location key
    if (locationKeys.isNotEmpty && locationKeys.first.isNotEmpty) {
      final locationKeyId = locationKeys.first;
      // Try to find in already loaded list, otherwise create placeholder
      AddressLocationItem? matchedLocation;
      if (addressLocationList != null && addressLocationList!.isNotEmpty) {
        try {
          matchedLocation = addressLocationList!.firstWhere(
            (location) => location.sId == locationKeyId,
          );
        } catch (e) {
          // Not found, create placeholder
          matchedLocation = AddressLocationItem(sId: locationKeyId, text: locationKeyId);
        }
      } else {
        // List not loaded yet, create placeholder
        matchedLocation = AddressLocationItem(sId: locationKeyId, text: locationKeyId);
      }
      selectedAddressLocations.add(matchedLocation);
      locationKeysControllers.add(TextEditingController(text: matchedLocation.text ?? locationKeyId));
    }
    
    emit(AddMoreNeighbourhoodKeys(
      neighbourhoodKeys: List.from(locationKeys),
      neighbourhoodKeysCtrl: List.from(locationKeysControllers),
    ));

    propertyAreaCtl.text = propertyDetailData.area?.amount.toString() ?? "";
    property3DTourCtl.text = propertyDetailData.virtualTour ?? "";
    propertyDescCtl.text = propertyDetailData.description ?? "";
    propertyLocationCtl.text = propertyDetailData.propertyLocation?.address ?? "";
    selectedLatLngVal = LatLng(propertyDetailData.propertyLocation?.latitude ?? AppConstants.defaultLatLng.latitude,
        propertyDetailData.propertyLocation?.longitude ?? AppConstants.defaultLatLng.longitude);
    selectedNeighborhoodProperty = propertyDetailData.neighbourHoodTypeData?.map((neighborhoodData) {
          double lat = neighborhoodData.latitude ?? latitude;
          double lng = neighborhoodData.longitude ?? longitude;

          return NearByLocationModel(
            location: neighborhoodData.address,
            locationLatLng: LatLng(lat, lng),
            neighborhoodType: neighborhoodData.neighborhoodType?.sId,
          );
        }).toList() ??
        [];

    selectedNeighborhoodTypes = filterNeighborhoodsById(neighborhoodTypes, propertyDetailData.neighborhoodType ?? []);
    propertyCountryCtl.text = propertyDetailData.country ?? "";
    propertyCityCtl.text = propertyDetailData.city ?? "";

    await _setCategoryOptions(myPropertyDetails.data ?? PropertyDetailData());

    emit(PropertyDetailsLoaded());
  }

  Future<void> _setCategoryOptions(PropertyDetailData propertyDetailData) async {
    for (var element in categoryOptions.keys) {
      printf("element $element:${categorySelectedOptions[element]}");
      final obj = categoryOptions.values
          .firstWhere((element) => element.label == propertyDetailData.floorsData?.name, orElse: () => categoryOptions.values.first);

      if (element == "floors") {
        setSelectedItemForCategory(
            CategoryItemData(name: propertyDetailData.floorsData?.name, sId: propertyDetailData.floorsData?.sId), element);
      }
      if (element == "furnishedType") {
        setSelectedItemForCategory(
            CategoryItemData(name: propertyDetailData.furnishedData?.name, sId: propertyDetailData.furnishedData?.sId), element);
      }
      if (element == "bedrooms") {
        setSelectedItemForCategory(
            CategoryItemData(name: propertyDetailData.bedroomData?.name, sId: propertyDetailData.bedroomData?.sId), element);
      }
      if (element == "bathrooms") {
        setSelectedItemForCategory(
            CategoryItemData(name: propertyDetailData.bathroomData?.name, sId: propertyDetailData.bathroomData?.sId), element);
      }
      if (element == "buildingAge") {
        setSelectedItemForCategory(
            CategoryItemData(name: propertyDetailData.buildingAgeData?.name, sId: propertyDetailData.buildingAgeData?.sId), element);
      }
      if (element == "facade") {
        setSelectedItemForCategory(
            CategoryItemData(name: propertyDetailData.facadeData?.name, sId: propertyDetailData.facadeData?.sId), element);
      }
      if (element == "amenities") {
        final list = (propertyDetailData.propertyAmenitiesData ?? [])
            .map((element) => CategoryItemData(sId: element.sId, name: element.name))
            .toList();
        setSelectedItemsForCategory(list, element);
      }

      if (element == "mortgaged") {
        final isMortgaged = propertyDetailData.mortgaged == true
            ? "Yes"
            : propertyDetailData.mortgaged == false
                ? "No"
                : "null"; // Default to "null" if null
        final obj = categoryOptions[element]?.data?.firstWhere(
              (e) => e.name == isMortgaged,
              orElse: () => CategoryItemData(), // Provide a fallback if no matching element is found
            );

        if (obj != null) {
          setSelectedItemForCategory(obj, element);
        } else {
          // Handle the case where obj is null, if necessary
          printf("No matching item found for element: $element");
        }
      }

      // if (element == "mortgaged") {
      //   final obj = categoryOptions[element]!.data?.firstWhere((e) =>
      //       e.name == ((propertyDetailData.mortgaged ?? false) ? "Yes" : "No"));
      //   setSelectedItemForCategory(obj!, element);
      // }
    }
  }

  String? getNameById(List<PropertyCategoryData>? list, String id) {
    return list?.firstWhere((item) => item.sId == id, orElse: () => PropertyCategoryData(name: "Unknown")).name;
  }

  String? getSubNameById(List<PropertySubCategoryData>? list, String id) {
    return list?.firstWhere((item) => item.sId == id, orElse: () => PropertySubCategoryData(name: "Unknown")).name;
  }

  void setCategoryItemData(CategoryItem categoryItemData, PropertyDetailData detailData) {}

  List<PropertyNeighbourhoodData> convertToNeighborhoodList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => PropertyNeighbourhoodData.fromJson(json)).toList();
  }

  void updateNeighborhoodNames(List<PropertyNeighbourhoodData> neighborhoods, List<Map<String, dynamic>> apiData) {
    for (var neighborhood in neighborhoods) {
      var match = apiData.firstWhere(
        (item) => item['_id'] == neighborhood.sId,
        orElse: () => {'_id': neighborhood.sId, 'name': ''},
      );

      neighborhood.name = match['name'];
    }
  }

  List<PropertyNeighbourhoodData> filterNeighborhoodsById(List<PropertyNeighbourhoodData> neighborhoods, List<String> idList) {
    return neighborhoods.where((neighborhood) => idList.contains(neighborhood.sId)).toList();
  }

  List<PropertyAmenitiesData> filterAmenitiesById(List<PropertyAmenitiesData> amenities, List<PropertyAmenitiesData> idList) {
    var idSet = idList.map((e) => e.sId).toSet();

    return amenities.where((amenity) => idSet.contains(amenity.sId)).toList();
  }

  void clearScreen3Controllers() {
    categoryItemData = CategoryItem();
    categoryOptions.clear();
    categorySelectedOptions.clear();
  }

  void clearScreen2Controllers() {
    propertyLocationCtl.clear();
    propertyCountryCtl.clear();
    propertyCityCtl.clear();
    selectedNeighborhoodTypes = [];
    selectedNeighborhoodProperty = [];
    locationKeys.clear();
    selectedAddressLocations.clear();
    locationKeysControllers.clear();
  }

  void clearScreen1Controllers() {
    selectedPropertyCategory = PropertyCategoryData();
    isCategorySelected = false;
    selectedPropertySubCategory = PropertySubCategoryData();
    propertyTitleCtl.clear();
    propertyPriceCtl.clear();
    mobileNumberCtl.clear();
    editController.clear();
    selectedMobileNoCountry = CountryListData(
        countryCode: AppConstants.defaultCountryCode, phoneCode: AppConstants.defaultPhoneCode, emoji: AppConstants.defaultCountryFlag);
    altMobileNumberCtl.clear();
    selectedAltMobileNoCountry = CountryListData(
        countryCode: AppConstants.defaultCountryCode, phoneCode: AppConstants.defaultPhoneCode, emoji: AppConstants.defaultCountryFlag);
    propertyAreaCtl.clear();
    property3DTourCtl.clear();
    videoLinksControllers.clear();
    videoLinksList.clear();
    locationKeysControllers.clear();
    locationKeys.clear();
    propertyDescCtl.clear();
    propertyAttachmentList = [];
    thumbnailImgList = [];
  }

  /// Method Validation
  ///
  bool validateStep1(BuildContext context) {
    if (selectedPropertyCategory.sId == null || selectedPropertyCategory.sId == "") {
      Utils.showErrorMessage(context: context, message: appStrings(context).propertyCategoryEmptyError);
      return false;
    } else if (selectedPropertySubCategory.sId == null || selectedPropertySubCategory.sId == "") {
      Utils.showErrorMessage(context: context, message: appStrings(context).propertySubCategoryEmptyError);
      return false;
    }

    return true;
  }

  /// Method Validation
  ///
  bool validateStep2(BuildContext context) {
    if (selectedNeighborhoodProperty.isEmpty) {
      Utils.showErrorMessage(context: context, message: appStrings(context).propertyNeighborhoodTypeEmptyError);
      return false;
    }

    return true;
  }

  /// MULTIPART CREATE Property API
  ///
  Future<void> addEditPropertyAPI({String? propertyId}) async {
    emit(AddPropertyAPILoading());
    List<dynamic> httpAttachmentList = [];
    Map<String, dynamic> formDataMap = {};
    List<MapEntry<String, String>> formFields = [];

    if (propertyAttachmentList.isNotEmpty) {
      httpAttachmentList = propertyAttachmentList.where((item) => item.startsWith('http')).cast<String>().toList();
      formDataMap[NetworkParams.kPropertyFiles] = jsonEncode(httpAttachmentList);
    }

    if (selectedPropertyCategory.sId != null && selectedPropertyCategory.sId!.isNotEmpty) {
      formDataMap[NetworkParams.kCategoryId] = selectedPropertyCategory.sId!;
    }

    if (selectedPropertySubCategory.sId != null && selectedPropertySubCategory.sId!.isNotEmpty) {
      formDataMap[NetworkParams.kSubCategoryId] = selectedPropertySubCategory.sId!;
    }

    if (propertyTitleCtl.text.trim().isNotEmpty) {
      formDataMap[NetworkParams.kTitle] = propertyTitleCtl.text.trim();
    }

    if (property3DTourCtl.text.trim().isNotEmpty) {
      formDataMap[NetworkParams.kVirtualTour] = property3DTourCtl.text.trim();
    }

    if (videoLinksList.isNotEmpty) {
      formDataMap[NetworkParams.kVideoLink] =
          jsonEncode(videoLinksList.isEmpty || videoLinksList.every((link) => link.isEmpty) ? [] : videoLinksList);
    }
    if (locationKeys.isNotEmpty) {
      formDataMap[NetworkParams.kLocationKeys] =
          jsonEncode(locationKeys.isEmpty || locationKeys.every((link) => link.isEmpty) ? [] : locationKeys);
    }

    if (propertyDescCtl.text.trim().isNotEmpty) {
      formDataMap[NetworkParams.kDescription] = propertyDescCtl.text.trim();
    }

    if (propertyCountryCtl.text.isNotEmpty) {
      formDataMap[NetworkParams.kCountry] = propertyCountryCtl.text.trim();
    }

    if (propertyCityCtl.text.isNotEmpty) {
      formDataMap[NetworkParams.kCity] = propertyCityCtl.text.trim();
    }

    // formDataMap[NetworkParams.kFurnishedType] = 123;

    // List<String> amenitiesIds = selectedAmenitiesData
    //     .map((amenity) => amenity.sId)
    //     .where((id) => id != null && id.isNotEmpty)
    //     .cast<String>()
    //     .toList();
    //
    // if (amenitiesIds.isNotEmpty) {
    //   formDataMap[NetworkParams.kAmenities] = jsonEncode(amenitiesIds);
    // }

    FormData formData = FormData.fromMap(formDataMap);

    formData.fields.addAll([
      MapEntry(
        NetworkParams.kNeighborLocation,
        jsonEncode(
          selectedNeighborhoodProperty.map((location) {
            return NeighborhoodPropertyModel(
              latitude: location.locationLatLng?.latitude,
              longitude: location.locationLatLng?.longitude,
              address: location.location,
              neighborhoodType: location.neighborhoodType,
            ).toJson();
          }).toList(),
        ),
      ),
    ]);

    printf("FormData-----$formData");

    if (thumbnailImgList.isNotEmpty) {
      dynamic multipartFile = "";
      if (!thumbnailImgList.first.startsWith('http')) {
        multipartFile = await MultipartFile.fromFile(thumbnailImgList.first);
        formData.files.add(MapEntry(NetworkParams.kPropertyThumbnail, multipartFile));
      } else {
        multipartFile = thumbnailImgList.first;
        formData.fields.add(MapEntry(NetworkParams.kPropertyThumbnail, multipartFile));
      }
    } else {
      formData.fields.add(const MapEntry(NetworkParams.kPropertyThumbnail, ""));
    }

    if (propertyAttachmentList.isNotEmpty) {
      for (var file in propertyAttachmentList) {
        if (!file.startsWith('http') && file.length > 2) {
          final multipartFile = await MultipartFile.fromFile(file);
          formData.files.add(MapEntry(NetworkParams.kPropertyFiles, multipartFile));
        }
      }
    }

    if (propertyPriceCtl.text.trim().isNotEmpty) {
      formFields.add(MapEntry(
        NetworkParams.kPrice,
        jsonEncode(
          Price(
            amount: propertyPriceCtl.text.trim(),
            currencySymbol: selectedCurrency.currencySymbol ?? 'د.أ',
            currencyCode: selectedCurrency.currencyCode ?? 'JOD',
          ).toJson(),
        ),
      ));
    }

    if (propertyAreaCtl.text.trim().isNotEmpty) {
      formFields.add(MapEntry(
        NetworkParams.kArea,
        jsonEncode(
          Area(
            amount: propertyAreaCtl.text.trim(),
            unit: 'sqm',
          ).toJson(),
        ),
      ));
    }

    if (mobileNumberCtl.text.trim().isNotEmpty) {
      formFields.add(MapEntry(
        NetworkParams.kContactNumber,
        jsonEncode(
          ContactNumberModel(
            contactNumber: mobileNumberCtl.text.trim(),
            emoji: selectedMobileNoCountry.emoji,
            countryCode: selectedMobileNoCountry.countryCode,
            phoneCode: selectedMobileNoCountry.phoneCode,
          ).toJson(),
        ),
      ));
    }

    if (altMobileNumberCtl.text.trim().isNotEmpty) {
      formFields.add(MapEntry(
        NetworkParams.kAlternateContactNumber,
        jsonEncode(
          ContactNumberModel(
            contactNumber: altMobileNumberCtl.text.trim(),
            emoji: selectedAltMobileNoCountry.emoji,
            countryCode: selectedAltMobileNoCountry.countryCode,
            phoneCode: selectedAltMobileNoCountry.phoneCode,
          ).toJson(),
        ),
      ));
    }

    if (selectedLatLngVal != null && propertyLocationCtl.text.isNotEmpty) {
      formFields.add(MapEntry(
        NetworkParams.kPropertyLocation,
        jsonEncode(
          PropertyLocation(
            latitude: selectedLatLngVal!.latitude,
            longitude: selectedLatLngVal!.longitude,
            address: propertyLocationCtl.text,
          ),
        ),
      ));
    }

    selectedItems.forEach((key, value) {
      printf("Key: $key, Value: ${value.sId.toString()}");
    });

    if (selectedItems.isNotEmpty) {
      selectedItems.forEach((key, items) {
        subCategoryRequestModels.add(
          SubCategoryRequestModel(
            key: key,
            id: items.sId ?? '',
          ),
        );
      });
    }

    if (selectedMultiItems.isNotEmpty) {
      selectedMultiItems.forEach((key, items) {
        subCategoryMultiRequestModels.add(
          SubCategoryMultiRequestModel(
            key: key,
            id: items.map((item) => item.sId ?? '').where((id) => id.isNotEmpty).toList(),
          ),
        );
      });
    }
    printf("subCategoryMultiRequestModels-----${subCategoryMultiRequestModels.toString()}");

// Add subCategoryRequestModels dynamically to formFields using their `key`
    for (var model in subCategoryRequestModels) {
      if (model.key != null) {
        formFields.add(
          MapEntry(
            model.key!,
            model.id,
          ),
        );
      }
    }

    for (var model in subCategoryMultiRequestModels) {
      if (model.key != null) {
        formData.fields.addAll([
          MapEntry(
            model.key!,
            jsonEncode(model.id!),
          )
        ]);
      }
    }

// Debugging: Print the encoded formFields to verify the data
    printf("FormFields for API Request: $formFields");

    formData.fields.addAll(formFields);
    printf(selectedNeighborhoodProperty.length);
    printf(formData.fields);
    printf(formData);
    final createPropertyResponse = isEditModeOn
        ? isForInReview
            ? await propertyRepository.editPropertyInReview(data: formData, propertyId: propertyId ?? '')
            : await propertyRepository.editProperty(data: formData, propertyId: propertyId ?? '')
        : await propertyRepository.addProperty(
            data: formData,
          );

    if (createPropertyResponse is FailedResponse) {
      emit(AddPropertyAPIFailure(createPropertyResponse.errorMessage));
    } else if (createPropertyResponse is SuccessResponse) {
      AddEditPropertyResponseModel response = createPropertyResponse.data;
      emit(AddPropertyAPISuccess(model: response));
    }
  }

  @override
  Future<void> close() {
    // clearScreen1Controllers();
    // clearScreen2Controllers();
    // clearScreen3Controllers();
    return super.close();
  }
}
