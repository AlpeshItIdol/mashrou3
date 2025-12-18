import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/city_list_response_model.dart';
import 'package:mashrou3/app/model/country_list_model.dart';
import 'package:mashrou3/app/model/property/currency_list_response_model.dart';
import 'package:mashrou3/app/model/property/property_category_response_model.dart';
import 'package:mashrou3/app/model/property/property_neighbourhood_response_model.dart';
import 'package:mashrou3/app/model/property/address_location_response_model.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/model/sub_category_response_model.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/model/category_item_data_response_model.dart';
import 'package:mashrou3/app/repository/filter_repository.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/select_country_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_status_list_response_model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/location_manager.dart';

import '../../../custom_widget/loader/overlay_loading_progress.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit(
      {required this.filterRepository, required this.propertyRepository})
      : super(FilterInitial());
  FilterRepository filterRepository;
  PropertyRepository propertyRepository;

  int filterRadiusValue = 0;
  String? selectedConstructionStatus;
  String? selectedBankLeasingStatus;
  String? selectedIsSoldOutStatus;
  String? selectedVirtualTourStatus;
  List<PropertyCategoryData>? furnishedStatusList = [];
  PropertyCategoryData selectedFurnishedStatus = PropertyCategoryData();
  var selectedCountryId = "";
  CountryListData selectedCountry = CountryListData();
  List<FilterStatusData>? filterStatusList = [];
  var selectedCity = Cities();
  bool isSelectedCountry = false;
  TextEditingController priceStartCtl = TextEditingController();
  FocusNode priceStartFn = FocusNode();
  TextEditingController priceEndCtl = TextEditingController();
  FocusNode priceEndFn = FocusNode();
  TextEditingController areaStartCtl = TextEditingController();
  FocusNode areaStartFn = FocusNode();
  TextEditingController areaEndCtl = TextEditingController();
  FocusNode areaEndFn = FocusNode();
  TextEditingController searchCtl = TextEditingController();
  FocusNode searchFn = FocusNode();
  List<PropertyNeighbourhoodData> neighborhoodTypes = [];
  List<PropertyNeighbourhoodData> selectedNeighborhoodTypes = [];
  List<AddressLocationItem>? addressLocationList = [];
  AddressLocationItem selectedAddressLocation = AddressLocationItem();
  List<PropertyCategoryData>? propertyCategoryList = [];
  PropertyCategoryData selectedPropertyCategory = PropertyCategoryData();
  List<PropertySubCategoryData>? propertySubCategoryList = [];
  List<PropertySubCategoryData> selectedPropertySubCategories = [];
  CategoryItem? categoryItemData;
  Map<String, CategoryItemOptions> categoryOptions = {};
  Map<String, CategoryItemData> selectedLivingSpaceItems = {}; // Single select items
  Map<String, List<CategoryItemData>> selectedLivingSpaceMultiItems = {}; // Multi select items
  // Pre-loaded data structures
  Map<String, List<PropertySubCategoryData>> allSubCategoriesByCategory = {}; // categoryId -> sub categories
  Map<String, Map<String, CategoryItemOptions>> allCategoryOptionsByCategory = {}; // categoryId -> categoryOptions
  FilterRequestModel filterRequestModel = FilterRequestModel();
  bool isVendor = false;
  var selectedRole = "";
  List<CurrencyListData>? currencyList = [];
  CurrencyListData selectedCurrency = CurrencyListData(
    sId: '5d441ff23b574544e86e97bf',
    currencySymbol: 'د.أ',
    currencyCode: 'JOD',
    currencyName: 'Jordanian Dinar',
  );

  void updateFilterRadius(int newValue) {
    filterRadiusValue = newValue;
    emit(FilterRadiusUpdated(filterRadiusValue));
  }

  bool get isFilterApplied => state is ApplyPropertyFilter;

  Future<void> getData(BuildContext context) async {
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isVendor = selectedRole == AppStrings.vendor;
    OverlayLoadingProgress.start(context);
    await Future.wait([
      LocationManager.fetchLocation(),
      getFilterStatusList(context),
      getCurrencyList(),
      getPropertyNeighbourhoodList(),
      getAddressLocationList(),
      getPropertyCategoryList(),
    ]);
    
    // Load all sub categories and living space data for all categories upfront
    await loadAllCategoryRelatedData();
    
    // Pre-select the first category and load its sub-categories and living space details
    await preSelectFirstCategory();
    
    OverlayLoadingProgress.stop();
    if (filterRequestModel.neighborhood?.isNotEmpty ?? false) {
      selectedNeighborhoodTypes = filterNeighborhoodsById(
          neighborhoodTypes, filterRequestModel.neighborhood!);
    } else {
      selectedNeighborhoodTypes = [];
    }
    emit(FilterNeighbourhoodDataSet());
  }

  /// Pre-select the first category and load its sub-categories and living space details
  Future<void> preSelectFirstCategory() async {
    if (propertyCategoryList == null || propertyCategoryList!.isEmpty) {
      printf("No categories available to pre-select");
      return;
    }
    
    // Select the first category
    final firstCategory = propertyCategoryList!.first;
    if (firstCategory.sId != null && firstCategory.sId!.isNotEmpty) {
      selectedPropertyCategory = firstCategory;
      selectedPropertySubCategories = [];
      propertySubCategoryList = [];
      
      printf("Pre-selecting first category: ${firstCategory.name} (${firstCategory.sId})");
      
      // Load sub-categories and living space details for the pre-selected category
      // Data is already pre-loaded, so this will be instant
      await getPropertySubCategoryList(categoryId: firstCategory.sId!);
      await getPropertyCategoryData(categoryId: firstCategory.sId!);
      
      printf("Pre-loaded sub-categories: ${propertySubCategoryList?.length ?? 0}, Living space options: ${categoryOptions.length}");
    }
  }

  /// Load all sub categories and living space data for all categories
  /// This loads all data upfront so that when a user selects a category,
  /// the sub categories and living space details appear immediately
  Future<void> loadAllCategoryRelatedData() async {
    allSubCategoriesByCategory.clear();
    allCategoryOptionsByCategory.clear();
    
    if (propertyCategoryList == null || propertyCategoryList!.isEmpty) {
      printf("No categories available to load sub categories and living space data");
      return;
    }
    
    printf("Loading sub categories and living space data for ${propertyCategoryList!.length} categories...");
    
    // Load sub categories and living space data for each category in parallel
    final futures = <Future>[];
    for (final category in propertyCategoryList!) {
      if (category.sId != null && category.sId!.isNotEmpty) {
        futures.add(_loadCategoryData(category.sId!));
      }
    }
    
    // Wait for all data to load (errors in individual categories won't stop others)
    await Future.wait(futures, eagerError: false);
    
    printf("Finished loading data: ${allSubCategoriesByCategory.length} categories with sub categories, ${allCategoryOptionsByCategory.length} categories with living space data");
    
    // Verify data was loaded
    for (final category in propertyCategoryList!) {
      if (category.sId != null && category.sId!.isNotEmpty) {
        final hasSubCategories = allSubCategoriesByCategory.containsKey(category.sId);
        final hasLivingSpace = allCategoryOptionsByCategory.containsKey(category.sId);
        printf("Category ${category.name} (${category.sId}): SubCategories=${hasSubCategories}, LivingSpace=${hasLivingSpace}");
      }
    }
    
    // Emit state to notify that all data has been loaded
    emit(FilterStatusSuccess(dataList: filterStatusList ?? []));
  }

  /// Load sub categories and living space data for a specific category
  Future<void> _loadCategoryData(String categoryId) async {
    // Load sub categories
    try {
      final subCategoryResponse = await propertyRepository.getPropertySubCategories(
        categoryId: categoryId,
      );
      if (subCategoryResponse is SuccessResponse &&
          subCategoryResponse.data is SubCategoryResponseModel) {
        SubCategoryResponseModel responseModel =
            subCategoryResponse.data as SubCategoryResponseModel;
        allSubCategoriesByCategory[categoryId] = responseModel.data ?? [];
        printf("Loaded ${responseModel.data?.length ?? 0} sub categories for category $categoryId");
      } else if (subCategoryResponse is FailedResponse) {
        printf("Failed to load sub categories for category $categoryId: ${subCategoryResponse.errorMessage}");
        // Store empty list to indicate we attempted to load
        allSubCategoriesByCategory[categoryId] = [];
      }
    } catch (e) {
      printf("Error loading sub categories for category $categoryId: $e");
      // Store empty list to indicate we attempted to load
      allSubCategoriesByCategory[categoryId] = [];
    }
    
    // Load living space data
    try {
      final categoryDataResponse = await propertyRepository.getPropertyCategoryData(
        categoryId: categoryId,
      );
      if (categoryDataResponse is SuccessResponse &&
          categoryDataResponse.data is CategoryItemDataResponseModel) {
        CategoryItemDataResponseModel responseModel =
            categoryDataResponse.data as CategoryItemDataResponseModel;
        final categoryItem = responseModel.data;
        
        if (categoryItem != null) {
          Map<String, CategoryItemOptions> options = {};
          if (categoryItem.floors != null) {
            options['floors'] = categoryItem.floors!;
          }
          if (categoryItem.bedrooms != null) {
            options['bedrooms'] = categoryItem.bedrooms!;
          }
          if (categoryItem.bathrooms != null) {
            options['bathrooms'] = categoryItem.bathrooms!;
          }
          if (categoryItem.amenities != null) {
            options['amenities'] = categoryItem.amenities!;
          }
          if (categoryItem.facades != null) {
            options['facade'] = categoryItem.facades!;
          }
          if (categoryItem.furnishedTypes != null) {
            options['furnishedType'] = categoryItem.furnishedTypes!;
          }
          if (categoryItem.buildingAge != null) {
            options['buildingAge'] = categoryItem.buildingAge!;
          }
          if (categoryItem.mortgaged != null) {
            options['mortgaged'] = categoryItem.mortgaged!;
          }
          allCategoryOptionsByCategory[categoryId] = options;
          printf("Loaded ${options.length} living space options for category $categoryId");
        } else {
          // Store empty map to indicate we attempted to load
          allCategoryOptionsByCategory[categoryId] = {};
        }
      } else if (categoryDataResponse is FailedResponse) {
        printf("Failed to load living space data for category $categoryId: ${categoryDataResponse.errorMessage}");
        // Store empty map to indicate we attempted to load
        allCategoryOptionsByCategory[categoryId] = {};
      }
    } catch (e) {
      printf("Error loading category data for category $categoryId: $e");
      // Store empty map to indicate we attempted to load
      allCategoryOptionsByCategory[categoryId] = {};
    }
  }

  /// Filter - Status List API
  ///
  Future<void> getFilterStatusList(BuildContext context) async {
    emit(FilterStatusLoading());

    final response = await filterRepository.getFilterStatusList();

    if (response is SuccessResponse &&
        response.data is FilterStatusListResponseModel) {
      FilterStatusListResponseModel responseModel =
          response.data as FilterStatusListResponseModel;
      filterStatusList = responseModel.data ?? [];
      emit(FilterStatusSuccess(dataList: responseModel.data ?? []));
    } else if (response is FailedResponse) {
      emit(FilterStatusFailure(response.errorMessage));
    }
  }

  /// Currency List API
  ///
  Future<void> getCurrencyList() async {
    emit(FilterCurrencyLoading());

    final response = await propertyRepository.getCurrencyList();

    if (response is SuccessResponse &&
        response.data is CurrencyListResponseModel) {
      CurrencyListResponseModel responseModel =
          response.data as CurrencyListResponseModel;
      currencyList = responseModel.data ?? [];
      emit(FilterCurrencySuccess());
    } else if (response is FailedResponse) {
      emit(FilterCurrencyFailure(response.errorMessage));
    }
  }

  /// Property Neighbourhood list API
  Future<void> getPropertyNeighbourhoodList() async {
    emit(FilterNeighbourhoodLoading());

    final response = await propertyRepository.getPropertyNeighbourhood();

    if (response is SuccessResponse &&
        response.data is PropertyNeighbourhoodResponseModel) {
      PropertyNeighbourhoodResponseModel propertyNeighbourhoodResponseModel =
          response.data as PropertyNeighbourhoodResponseModel;

      neighborhoodTypes = propertyNeighbourhoodResponseModel.data ?? [];
      printf("PropertyNeighbourhoodList--------${neighborhoodTypes.length}");

      emit(FilterNeighbourhoodSuccess());
    } else if (response is FailedResponse) {
      emit(FilterNeighbourhoodFailure(response.errorMessage));
    }
  }

  List<PropertyNeighbourhoodData> filterNeighborhoodsById(
      List<PropertyNeighbourhoodData> neighborhoods, List<String> idList) {
    return neighborhoods
        .where((neighborhood) => idList.contains(neighborhood.sId))
        .toList();
  }

  /// Address Location List API
  Future<void> getAddressLocationList() async {
    emit(FilterStatusLoading());

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
      emit(FilterStatusSuccess(dataList: filterStatusList ?? []));
    } else if (response is FailedResponse) {
      emit(FilterStatusFailure(response.errorMessage));
    }
  }

  /// Property Category List API
  Future<void> getPropertyCategoryList() async {
    emit(FilterStatusLoading());

    final response = await propertyRepository.getPropertyCategories();

    if (response is SuccessResponse &&
        response.data is PropertyCategoryResponseModel) {
      PropertyCategoryResponseModel responseModel =
          response.data as PropertyCategoryResponseModel;
      propertyCategoryList = responseModel.data ?? [];
      emit(FilterStatusSuccess(dataList: filterStatusList ?? []));
    } else if (response is FailedResponse) {
      emit(FilterStatusFailure(response.errorMessage));
    }
  }

  /// Property Sub Category List API
  /// Now uses pre-loaded data instead of making API call
  /// Data should already be loaded when filter screen opens
  Future<void> getPropertySubCategoryList({required String categoryId}) async {
    // Use pre-loaded data if available (should always be available after initial load)
    if (allSubCategoriesByCategory.containsKey(categoryId)) {
      final subCategories = allSubCategoriesByCategory[categoryId] ?? [];
      propertySubCategoryList = subCategories;
      selectedPropertySubCategories = []; // Reset selection
      printf("Using pre-loaded sub categories for category $categoryId: ${subCategories.length} items");
      // Emit state to trigger UI update immediately (data is already loaded, so this is instant)
      // Use FilterNeighbourhoodDataSet to ensure UI rebuilds (it's a distinct state)
      emit(FilterNeighbourhoodDataSet());
    } else {
      printf("WARNING: Pre-loaded sub categories not found for category $categoryId, falling back to API call");
      printf("Available categories in pre-loaded data: ${allSubCategoriesByCategory.keys.toList()}");
      // Fallback to API call if pre-loaded data not available
      emit(FilterStatusLoading());

      final response = await propertyRepository.getPropertySubCategories(
        categoryId: categoryId,
      );

      if (response is SuccessResponse &&
          response.data is SubCategoryResponseModel) {
        SubCategoryResponseModel responseModel =
            response.data as SubCategoryResponseModel;
        propertySubCategoryList = responseModel.data ?? [];
        selectedPropertySubCategories = []; // Reset selection
        emit(FilterStatusSuccess(dataList: filterStatusList ?? []));
      } else if (response is FailedResponse) {
        emit(FilterStatusFailure(response.errorMessage));
      }
    }
  }

  /// Property Category Data API (Living Space Fields)
  /// Now uses pre-loaded data instead of making API call
  /// Data should already be loaded when filter screen opens
  Future<void> getPropertyCategoryData({required String categoryId}) async {
    // Use pre-loaded data if available (should always be available after initial load)
    if (allCategoryOptionsByCategory.containsKey(categoryId)) {
      final options = Map<String, CategoryItemOptions>.from(
        allCategoryOptionsByCategory[categoryId] ?? {},
      );
      categoryOptions = options;
      selectedLivingSpaceItems.clear();
      selectedLivingSpaceMultiItems.clear();
      printf("Using pre-loaded living space data for category $categoryId: ${options.length} options");
      // Emit state to trigger UI update immediately (data is already loaded, so this is instant)
      // Use FilterNeighbourhoodDataSet to ensure UI rebuilds (it's a distinct state)
      emit(FilterNeighbourhoodDataSet());
    } else {
      printf("WARNING: Pre-loaded living space data not found for category $categoryId, falling back to API call");
      printf("Available categories in pre-loaded data: ${allCategoryOptionsByCategory.keys.toList()}");
      // Fallback to API call if pre-loaded data not available
      emit(FilterStatusLoading());

      final response = await propertyRepository.getPropertyCategoryData(
        categoryId: categoryId,
      );

      if (response is SuccessResponse &&
          response.data is CategoryItemDataResponseModel) {
        CategoryItemDataResponseModel responseModel =
            response.data as CategoryItemDataResponseModel;
        categoryItemData = responseModel.data;
        
        // Initialize category options map
        categoryOptions.clear();
        selectedLivingSpaceItems.clear();
        selectedLivingSpaceMultiItems.clear();
        
        if (categoryItemData != null) {
          if (categoryItemData!.floors != null) {
            categoryOptions['floors'] = categoryItemData!.floors!;
          }
          if (categoryItemData!.bedrooms != null) {
            categoryOptions['bedrooms'] = categoryItemData!.bedrooms!;
          }
          if (categoryItemData!.bathrooms != null) {
            categoryOptions['bathrooms'] = categoryItemData!.bathrooms!;
          }
          if (categoryItemData!.amenities != null) {
            categoryOptions['amenities'] = categoryItemData!.amenities!;
          }
          if (categoryItemData!.facades != null) {
            categoryOptions['facade'] = categoryItemData!.facades!;
          }
          if (categoryItemData!.furnishedTypes != null) {
            categoryOptions['furnishedType'] = categoryItemData!.furnishedTypes!;
          }
          if (categoryItemData!.buildingAge != null) {
            categoryOptions['buildingAge'] = categoryItemData!.buildingAge!;
          }
          if (categoryItemData!.mortgaged != null) {
            categoryOptions['mortgaged'] = categoryItemData!.mortgaged!;
          }
        }
        
        emit(FilterStatusSuccess(dataList: filterStatusList ?? []));
      } else if (response is FailedResponse) {
        emit(FilterStatusFailure(response.errorMessage));
      }
    }
  }

  void clearFilters(BuildContext context) {
    selectedConstructionStatus = null;
    selectedBankLeasingStatus = null;
    selectedIsSoldOutStatus = null;
    selectedFurnishedStatus = PropertyCategoryData();
    selectedVirtualTourStatus = null;
    selectedCountryId = "";
    selectedCountry = CountryListData();
    isSelectedCountry = false;
    context.read<SelectCountryCubit>().resetToDefault();
    filterRadiusValue = 0;
    selectedCity = Cities(name: null, sId: null);
    selectedNeighborhoodTypes = [];
    selectedAddressLocation = AddressLocationItem();
    selectedPropertyCategory = PropertyCategoryData();
    selectedPropertySubCategories = [];
    propertySubCategoryList = [];
    categoryItemData = null;
    categoryOptions.clear();
    selectedLivingSpaceItems.clear();
    selectedLivingSpaceMultiItems.clear();
    // Note: allSubCategoriesByCategory and allCategoryOptionsByCategory are not cleared
    // as they contain pre-loaded data that should persist
    filterRequestModel.neighborhood = [];
    filterRequestModel.locationKeys = null;
    priceStartCtl.clear();
    priceEndCtl.clear();
    areaStartCtl.clear();
    areaEndCtl.clear();
    filterRequestModel.selectRadius = null;
    filterRequestModel.underConstruction = null;
    filterRequestModel.furnished = null;
    filterRequestModel.virtualTour = null;
    filterRequestModel.country = null;
    filterRequestModel.city = null;
    filterRequestModel.currencyCode = null;
    filterRequestModel.neighborhood = null;
    filterRequestModel.locationKeys = null;
    filterRequestModel.category = null;
    filterRequestModel.subCategoryId = null;
    filterRequestModel.floors = null;
    filterRequestModel.bedrooms = null;
    filterRequestModel.bathrooms = null;
    filterRequestModel.amenities = null;
    filterRequestModel.facade = null;
    filterRequestModel.furnishedType = null;
    filterRequestModel.buildingAge = null;
    filterRequestModel.mortgaged = null;
    filterRequestModel.price = null;
    filterRequestModel.area = null;
    emit(FilterReset());
    emit(FilterInitial());
  }

  void resetAndClearFilters(BuildContext context) {
    selectedConstructionStatus = null;
    selectedBankLeasingStatus = null;
    selectedIsSoldOutStatus = null;
    selectedFurnishedStatus = PropertyCategoryData();
    selectedVirtualTourStatus = null;
    selectedCountryId = "";
    selectedCountry = CountryListData();
    isSelectedCountry = false;
    context.read<SelectCountryCubit>().resetToDefault();
    filterRadiusValue = 0;
    selectedCity = Cities(name: null, sId: null);
    selectedNeighborhoodTypes = [];
    selectedAddressLocation = AddressLocationItem();
    selectedPropertyCategory = PropertyCategoryData();
    selectedPropertySubCategories = [];
    propertySubCategoryList = [];
    categoryItemData = null;
    categoryOptions.clear();
    selectedLivingSpaceItems.clear();
    selectedLivingSpaceMultiItems.clear();
    // Note: allSubCategoriesByCategory and allCategoryOptionsByCategory are not cleared
    // as they contain pre-loaded data that should persist
    filterRequestModel.neighborhood = [];
    filterRequestModel.locationKeys = null;
    priceStartCtl.clear();
    priceEndCtl.clear();
    areaStartCtl.clear();
    areaEndCtl.clear();
    filterRequestModel.selectRadius = null;
    filterRequestModel.underConstruction = null;
    filterRequestModel.furnished = null;
    filterRequestModel.virtualTour = null;
    filterRequestModel.country = null;
    filterRequestModel.city = null;
    filterRequestModel.currencyCode = null;
    filterRequestModel.neighborhood = null;
    filterRequestModel.locationKeys = null;
    filterRequestModel.category = null;
    filterRequestModel.subCategoryId = null;
    filterRequestModel.floors = null;
    filterRequestModel.bedrooms = null;
    filterRequestModel.bathrooms = null;
    filterRequestModel.amenities = null;
    filterRequestModel.facade = null;
    filterRequestModel.furnishedType = null;
    filterRequestModel.buildingAge = null;
    filterRequestModel.mortgaged = null;
    filterRequestModel.price = null;
    filterRequestModel.area = null;
    emit(FilterInitial());
  }

  Future<void> applyFilter(BuildContext context) async {
    // Reset filter request model to ensure clean state
    filterRequestModel = FilterRequestModel();
    
    printf("Selected Category: ${selectedPropertyCategory.sId}, Name: ${selectedPropertyCategory.name}");
    
    if (selectedConstructionStatus != null) {
      filterRequestModel.underConstruction =
          selectedConstructionStatus == appStrings(context).yes
              ? "true"
              : "false";
    }
    if (selectedBankLeasingStatus != null) {
      filterRequestModel.leasingCompany =
      selectedBankLeasingStatus == appStrings(context).yes
          ? "true"
          : "false";
    }
    if (selectedIsSoldOutStatus != null) {
      filterRequestModel.isSold =
      selectedIsSoldOutStatus == appStrings(context).yes
          ? "true"
          : "false";
    }
    if (selectedFurnishedStatus.sId != null &&
        selectedFurnishedStatus.sId!.isNotEmpty) {
      filterRequestModel.furnished = selectedFurnishedStatus.sId!;
    }
    if (selectedVirtualTourStatus != null) {
      filterRequestModel.virtualTour =
          selectedVirtualTourStatus == appStrings(context).yes
              ? "true"
              : "false";
    }
    if (selectedCountry.name != null) {
      filterRequestModel.country = selectedCountry.name;
    }
    if (selectedCity.sId != null) {
      filterRequestModel.city = selectedCity.name;
    }
    if (priceStartCtl.text.trim().isNotEmpty &&
        priceEndCtl.text.trim().isNotEmpty) {
      if (selectedCurrency.currencyCode != null) {
        filterRequestModel.currencyCode = selectedCurrency.currencyCode;
      }
      filterRequestModel.price = MinMaxModel(
        min: priceStartCtl.text.trim(),
        max: priceEndCtl.text.trim(),
      );
    }
    if (areaStartCtl.text.trim().isNotEmpty &&
        areaEndCtl.text.trim().isNotEmpty) {
      filterRequestModel.area = MinMaxModel(
        min: areaStartCtl.text.trim(),
        max: areaEndCtl.text.trim(),
      );
    }
    if (selectedNeighborhoodTypes.isNotEmpty) {
      List<String> neighborhoodIds = selectedNeighborhoodTypes
          .map((neighborhood) => neighborhood.sId!)
          .toList();
      filterRequestModel.neighborhood = neighborhoodIds;
    }

    // Set category if selected
    if (selectedPropertyCategory.sId != null && selectedPropertyCategory.sId!.isNotEmpty) {
      filterRequestModel.category = selectedPropertyCategory.sId;
      printf("Setting category: ${selectedPropertyCategory.sId}");
    } else {
      printf("Category not set - sId is null or empty. selectedPropertyCategory: ${selectedPropertyCategory.name}, sId: ${selectedPropertyCategory.sId}");
    }

    // Set sub categories if selected
    if (selectedPropertySubCategories.isNotEmpty) {
      List<String> subCategoryIds = selectedPropertySubCategories
          .where((subCategory) => subCategory.sId != null && subCategory.sId!.isNotEmpty)
          .map((subCategory) => subCategory.sId!)
          .toList();
      filterRequestModel.subCategoryId = subCategoryIds;
      printf("Setting subCategoryId: ${filterRequestModel.subCategoryId}");
      
      // If sub categories are selected but category is not set, try to get it from the first sub category
      if (filterRequestModel.category == null || filterRequestModel.category!.isEmpty) {
        final firstSubCategory = selectedPropertySubCategories.first;
        if (firstSubCategory.categoryId != null && firstSubCategory.categoryId!.isNotEmpty) {
          filterRequestModel.category = firstSubCategory.categoryId;
          printf("Setting category from subCategory.categoryId: ${firstSubCategory.categoryId}");
        }
      }
    }

    // Add living space filters
    if (selectedLivingSpaceItems.isNotEmpty || selectedLivingSpaceMultiItems.isNotEmpty) {
      // Floors
      if (selectedLivingSpaceItems.containsKey('floors') && selectedLivingSpaceItems['floors']?.sId != null) {
        filterRequestModel.floors = [selectedLivingSpaceItems['floors']!.sId!];
      }
      // Bedrooms
      if (selectedLivingSpaceItems.containsKey('bedrooms') && selectedLivingSpaceItems['bedrooms']?.sId != null) {
        filterRequestModel.bedrooms = [selectedLivingSpaceItems['bedrooms']!.sId!];
      }
      // Bathrooms
      if (selectedLivingSpaceItems.containsKey('bathrooms') && selectedLivingSpaceItems['bathrooms']?.sId != null) {
        filterRequestModel.bathrooms = [selectedLivingSpaceItems['bathrooms']!.sId!];
      }
      // Facade
      if (selectedLivingSpaceItems.containsKey('facade') && selectedLivingSpaceItems['facade']?.sId != null) {
        filterRequestModel.facade = [selectedLivingSpaceItems['facade']!.sId!];
      }
      // Furnished Type
      if (selectedLivingSpaceItems.containsKey('furnishedType') && selectedLivingSpaceItems['furnishedType']?.sId != null) {
        filterRequestModel.furnishedType = [selectedLivingSpaceItems['furnishedType']!.sId!];
      }
      // Building Age
      if (selectedLivingSpaceItems.containsKey('buildingAge') && selectedLivingSpaceItems['buildingAge']?.sId != null) {
        filterRequestModel.buildingAge = [selectedLivingSpaceItems['buildingAge']!.sId!];
      }
      // Mortgaged
      if (selectedLivingSpaceItems.containsKey('mortgaged') && selectedLivingSpaceItems['mortgaged']?.sId != null) {
        filterRequestModel.mortgaged = [selectedLivingSpaceItems['mortgaged']!.sId!];
      }
      // Amenities (multi-select)
      if (selectedLivingSpaceMultiItems.containsKey('amenities') && selectedLivingSpaceMultiItems['amenities']!.isNotEmpty) {
        filterRequestModel.amenities = selectedLivingSpaceMultiItems['amenities']!
            .where((item) => item.sId != null && item.sId!.isNotEmpty)
            .map((item) => item.sId!)
            .toList();
      }
    }

    if (selectedAddressLocation.sId != null && selectedAddressLocation.sId!.isNotEmpty) {
      filterRequestModel.locationKeys = [selectedAddressLocation.sId!];
      printf("Setting locationKeys: ${filterRequestModel.locationKeys}");
    }

    if (filterRadiusValue != 0) {
      filterRequestModel.selectRadius = filterRadiusValue.toString();
      var position = await LocationManager.checkForPermission();
      if (position != null) {
        filterRequestModel.longitude = position.longitude.toString();
        filterRequestModel.latitude = position.latitude.toString();
      }
    }
    // Debug: Print filter data before emitting
    printf("Filter Request Model JSON: ${filterRequestModel.toJson()}");
    printf("Category in filterRequestModel: ${filterRequestModel.category}");
    printf("SubCategoryId in filterRequestModel: ${filterRequestModel.subCategoryId}");
    
    if (filterRequestModel.isEmpty()) {
      emit(FilterInitial());
    } else {
      emit(ApplyPropertyFilter(filterRequestModel));
    }
  }
}
