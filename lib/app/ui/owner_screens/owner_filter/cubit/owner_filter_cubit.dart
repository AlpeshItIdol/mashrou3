import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
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
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/location_manager.dart';

part 'owner_filter_state.dart';

class OwnerFilterCubit extends Cubit<OwnerFilterState> {
  OwnerFilterCubit(
      {required this.filterRepository, required this.propertyRepository})
      : super(OwnerFilterInitial());
  FilterRepository filterRepository;
  PropertyRepository propertyRepository;

  int filterRadiusValue = 0;
  String? selectedConstructionStatus;
  String? selectedBankLeasingStatus;
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
    await Future.wait([
      LocationManager.fetchLocation(),
      getFilterStatusList(context),
      getCurrencyList(),
      getPropertyNeighbourhoodList(),
      getAddressLocationList(),
      getPropertyCategoryList(),
    ]);
    if (filterRequestModel.neighborhood?.isNotEmpty ?? false) {
      selectedNeighborhoodTypes = filterNeighborhoodsById(
          neighborhoodTypes, filterRequestModel.neighborhood!);
    } else {
      selectedNeighborhoodTypes = [];
    }
    emit(FilterNeighbourhoodDataSet());
  }

  // Future<void> setSliderUI() async {
  //   isSliderEnabled = await LocationManager.hasPermission;
  //   emit(FilterSliderUILoaded());
  // }

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
  Future<void> getPropertySubCategoryList({required String categoryId}) async {
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
      
      // Also load category data for living space filters
      await getPropertyCategoryData(categoryId: categoryId);
      
      emit(FilterStatusSuccess(dataList: filterStatusList ?? []));
    } else if (response is FailedResponse) {
      emit(FilterStatusFailure(response.errorMessage));
    }
  }

  /// Property Category Data API (Living Space Fields)
  Future<void> getPropertyCategoryData({required String categoryId}) async {
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

  void clearFilters(BuildContext context) {
    selectedConstructionStatus = null;
    selectedBankLeasingStatus = null;
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
    filterRequestModel.neighborhood = [];
    priceStartCtl.clear();
    priceEndCtl.clear();
    areaStartCtl.clear();
    areaEndCtl.clear();
    filterRequestModel.selectRadius = null;
    filterRequestModel.underConstruction = null;
    filterRequestModel.furnished = null;
    filterRequestModel.leasingCompany = null;
    filterRequestModel.virtualTour = null;
    filterRequestModel.country = null;
    filterRequestModel.city = null;
    filterRequestModel.currencyCode = null;
    filterRequestModel.neighborhood = null;
    filterRequestModel.locationKeys = null;
    filterRequestModel.price = null;
    filterRequestModel.area = null;
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
    emit(FilterReset());
    emit(OwnerFilterInitial());
  }

  Future<void> applyFilter(BuildContext context) async {
    if (selectedConstructionStatus != null) {
      filterRequestModel.underConstruction =
          selectedConstructionStatus == appStrings(context).yes
              ? "true"
              : "false";
    }
    if (selectedFurnishedStatus.sId != null &&
        selectedFurnishedStatus.sId!.isNotEmpty) {
      filterRequestModel.furnished = selectedFurnishedStatus.sId!;
    }
    if (selectedBankLeasingStatus != null) {
      filterRequestModel.leasingCompany =
          selectedBankLeasingStatus == appStrings(context).yes
              ? "true"
              : "false";
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
    // Set address location if selected
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
    if (filterRequestModel.isEmpty()) {
      emit(OwnerFilterInitial());
    } else {
      emit(ApplyPropertyFilter(filterRequestModel));
    }
  }
}
