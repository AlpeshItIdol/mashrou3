import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/model/country_list_model.dart';
import 'package:mashrou3/app/model/country_request_mode.dart';

part 'select_country_state.dart';

class SelectCountryCubit extends Cubit<SelectCountryState> {
  SelectCountryCubit() : super(SelectCountryInitial());

  TextEditingController searchCtl = TextEditingController(text: "");
  FocusNode searchFn = FocusNode();

  List<CountryListData>? countryList = [];

  CountryListData? selectedCountry;
  CountryListData? selectedMobileNoCountry;
  CountryListData? selectedAltMobileNoCountry;
  CountryListData selectedCountryData = CountryListData();

  List<CountryListData> filteredCountries = [];

  bool showSuffixIcon = false;

  void resetToDefault() {
    selectedCountryData = CountryListData();
    emit(ResetDataUpdated());
  }

  /// Country List API
  ///
  Future<void> getCountryList(BuildContext context) async {
    emit(CountrySelectionLoading());

    final model = CountryListRequestModel(
      searchQuery: searchCtl.text,
    );

    final response = await context
        .read<CommonApiCubit>()
        .fetchCountryList(requestModel: model);

    if (response is String) {
      emit(CountrySelectionError(response));
    } else {
      countryList = response;
      filteredCountries = countryList ?? [];
      emit(CountryListAPISuccess());
    }
  }

  void updateFilteredCountries(String searchValue) {
    filteredCountries = countryList!
        .where((country) =>
            country.name!.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
    emit(CountryDetailsLoaded(countryDetails: filteredCountries));
  }

  Future<void> selectedCountryStateUpdate(CountryListData country) async {
    selectedCountry = country;
    emit(CountrySelectionUpdated(country));
  }



  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }
}
