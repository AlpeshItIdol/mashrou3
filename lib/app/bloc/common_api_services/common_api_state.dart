// common_api_state.dart

part of 'common_api_cubit.dart';

abstract class CommonApiState extends Equatable {
  const CommonApiState();

  @override
  List<Object> get props => [];
}

class CommonApiInitial extends CommonApiState {}

class CommonApiLoading extends CommonApiState {}

class CommonApiLoaded extends CommonApiState {
  // final List<ClassListData> classListData;

  const CommonApiLoaded(// {required this.classListData}
      );

  @override
  List<Object> get props => [
        /*classListData*/
      ];
}

class CountryListLoaded extends CommonApiState {
  final List<CountryListData> countryListData;

  const CountryListLoaded({required this.countryListData});

  @override
  List<Object> get props => [countryListData];
}

class LanguageListLoaded extends CommonApiState {
  final List<LanguageListData> languageListData;

  const LanguageListLoaded({required this.languageListData});

  @override
  List<Object> get props => [languageListData];
}

class CurrencyListLoaded extends CommonApiState {
  final List<CurrencyListData> currencyData;

  const CurrencyListLoaded({required this.currencyData});

  @override
  List<Object> get props => [currencyData];
}

class CityListLoaded extends CommonApiState {
  final CityListData cityListData;

  const CityListLoaded({required this.cityListData});

  @override
  List<Object> get props => [cityListData];
}

class VendorListLoaded extends CommonApiState {
  final List<VendorListData> vendorListData;

  const VendorListLoaded({required this.vendorListData});

  @override
  List<Object> get props => [vendorListData];
}

class PropertyCategoryListLoaded extends CommonApiState {
  final List<PropertyCategoryData> propertyCategoryListData;

  const PropertyCategoryListLoaded({required this.propertyCategoryListData});

  @override
  List<Object> get props => [propertyCategoryListData];
}

class CommonApiError extends CommonApiState {
  final String errorMessage;

  const CommonApiError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
