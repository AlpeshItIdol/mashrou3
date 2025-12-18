import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    emit(FilterRadiusUpdated(filterRadiusValue));
  }

  bool get isFilterApplied => state is ApplyPropertyFilter;

  Future<void> getData(BuildContext context) async {
    await Future.wait([
      LocationManager.fetchLocation(),
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

  void clearFilters(BuildContext context) {
    selectedConstructionStatus = null;
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
      emit(OwnerFilterInitial());
    } else {
      emit(ApplyPropertyFilter(filterRequestModel));
    }
  }
}
