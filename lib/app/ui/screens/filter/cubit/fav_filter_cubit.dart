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
import 'package:mashrou3/app/repository/filter_repository.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/select_country_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_status_list_response_model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/location_manager.dart';

part 'fav_filter_state.dart';

class FavFilterCubit extends Cubit<FavFilterState> {
  FavFilterCubit(
      {required this.filterRepository, required this.propertyRepository})
      : super(FavFilterInitial());

  FilterRepository filterRepository;
  PropertyRepository propertyRepository;

  int filterRadiusValue = 0;
  String? selectedConstructionStatus;
  String? selectedBankLeasingStatus;
  String? selectedVirtualTourStatus;
  String? selectedIsSoldOutStatus;
  List<PropertyCategoryData>? furnishedStatusList = [];
  PropertyCategoryData selectedFurnishedStatus = PropertyCategoryData();
  var selectedCountryId = "";
  CountryListData selectedCountry = CountryListData();
  bool isVendor = false;
  var selectedRole = "";
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
  FilterRequestModel filterRequestModel = FilterRequestModel();
  List<CurrencyListData>? currencyList = [];
  CurrencyListData selectedCurrency = CurrencyListData(
    sId: '5d441ff23b574544e86e97bf',
    currencySymbol: 'د.أ',
    currencyCode: 'JOD',
    currencyName: 'Jordanian Dinar',
  );

  void updateFilterRadius(int newValue) {
    filterRadiusValue = newValue;
    emit(FavFilterRadiusUpdated(filterRadiusValue));
  }

  bool get isFilterApplied => state is FavApplyPropertyFilter;

  Future<void> getData(BuildContext context) async {
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isVendor = selectedRole == AppStrings.vendor;
    await Future.wait([
      getFilterStatusList(context),
      getCurrencyList(),
      getPropertyNeighbourhoodList()
    ]);
    if (filterRequestModel.neighborhood?.isNotEmpty ?? false) {
      selectedNeighborhoodTypes = filterNeighborhoodsById(
          neighborhoodTypes, filterRequestModel.neighborhood!);
    } else {
      selectedNeighborhoodTypes = [];
    }
    emit(FilterFavNeighbourhoodDataSet());
  }

  /// Filter - Status List API
  ///
  Future<void> getFilterStatusList(BuildContext context) async {
    emit(FavFilterStatusLoading());

    final response = await filterRepository.getFilterStatusList();

    if (response is SuccessResponse &&
        response.data is FilterStatusListResponseModel) {
      FilterStatusListResponseModel responseModel =
          response.data as FilterStatusListResponseModel;
      filterStatusList = responseModel.data ?? [];
      emit(FavFilterStatusSuccess(dataList: responseModel.data ?? []));
    } else if (response is FailedResponse) {
      emit(FavFilterStatusFailure(response.errorMessage));
    }
  }

  /// Currency List API
  ///
  Future<void> getCurrencyList() async {
    emit(FavFilterCurrencyLoading());

    final response = await propertyRepository.getCurrencyList();

    if (response is SuccessResponse &&
        response.data is CurrencyListResponseModel) {
      CurrencyListResponseModel responseModel =
          response.data as CurrencyListResponseModel;
      currencyList = responseModel.data ?? [];
      emit(FavFilterCurrencySuccess());
    } else if (response is FailedResponse) {
      emit(FavFilterCurrencyFailure(response.errorMessage));
    }
  }

  List<PropertyNeighbourhoodData> filterNeighborhoodsById(
      List<PropertyNeighbourhoodData> neighborhoods, List<String> idList) {
    return neighborhoods
        .where((neighborhood) => idList.contains(neighborhood.sId))
        .toList();
  }

  /// Property Neighbourhood list API
  Future<void> getPropertyNeighbourhoodList() async {
    emit(FavFilterNeighbourhoodLoading());

    final response = await propertyRepository.getPropertyNeighbourhood();

    if (response is SuccessResponse &&
        response.data is PropertyNeighbourhoodResponseModel) {
      PropertyNeighbourhoodResponseModel propertyNeighbourhoodResponseModel =
          response.data as PropertyNeighbourhoodResponseModel;

      neighborhoodTypes = propertyNeighbourhoodResponseModel.data ?? [];
      printf("PropertyNeighbourhoodList--------${neighborhoodTypes.length}");

      emit(FavFilterNeighbourhoodSuccess());
    } else if (response is FailedResponse) {
      emit(FavFilterNeighbourhoodFailure(response.errorMessage));
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
    filterRequestModel.neighborhood = [];
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
    filterRequestModel.price = null;
    filterRequestModel.area = null;
    emit(FavFilterReset());
    emit(FavFilterInitial());
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
    filterRequestModel.neighborhood = [];
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
    filterRequestModel.price = null;
    filterRequestModel.area = null;
    emit(FavFilterInitial());
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
    if (selectedIsSoldOutStatus != null) {
      filterRequestModel.isSold =
      selectedIsSoldOutStatus == appStrings(context).yes
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

    if (filterRadiusValue != 0) {
      filterRequestModel.selectRadius = filterRadiusValue.toString();
      var position = await LocationManager.checkForPermission();
      if (position != null) {
        filterRequestModel.longitude = position.longitude.toString();
        filterRequestModel.latitude = position.latitude.toString();
      }
    }
    if (filterRequestModel.isEmpty()) {
      emit(FavFilterInitial());
    } else {
      emit(FavApplyPropertyFilter(filterRequestModel));
    }
  }
}
