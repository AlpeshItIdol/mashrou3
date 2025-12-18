import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/model/country_list_model.dart';
import 'package:mashrou3/config/resources/app_constants.dart';

import '../../../../../../config/utils.dart';
import '../../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../../model/country_request_mode.dart';

part 'country_selection_state.dart';

class CountrySelectionCubit extends Cubit<CountrySelectionState> {
  CountrySelectionCubit() : super(CountrySelectionInitial());

  TextEditingController searchCtl = TextEditingController(text: "");
  FocusNode searchFn = FocusNode();

  List<CountryListData>? countryList = [];

  CountryListData? selectedCountry;
  CountryListData? selectedMobileNoCountry;
  CountryListData? selectedAltMobileNoCountry;

  dynamic countryFlag = AppConstants.defaultCountryFlag;
  var countryCode = AppConstants.defaultCountryCode;
  var countryName = AppConstants.defaultCountryName;

  List<CountryListData> filteredCountries = [];

  bool showSuffixIcon = false;

  void resetToDefault() {
    countryFlag = AppConstants.defaultCountryFlag;
    countryCode = AppConstants.defaultCountryCode;
    countryName = AppConstants.defaultCountryName;
    selectedCountry = AppConstants.defaultCountry;

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
      printf("CountryList--------${countryList?.length}");
      filteredCountries = countryList ?? [];
      emit(CountryListAPISuccess());
    }
  }

  Future<void> selectedCountryStateUpdate(CountryListData country) async {
    selectedCountry = country;
    emit(CountrySelectionUpdated(country));
  }

  void selectAltMobileNoCountry(CountryListData country) {
    selectedAltMobileNoCountry = country;
    emit(CountrySelectionUpdated(country));
  }

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }
}
