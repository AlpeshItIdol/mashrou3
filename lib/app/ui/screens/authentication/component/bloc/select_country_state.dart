part of 'select_country_cubit.dart';

sealed class SelectCountryState extends Equatable {
  const SelectCountryState();
}

final class SelectCountryInitial extends SelectCountryState {
  @override
  List<Object> get props => [];
}

class CountrySelectionInitial extends SelectCountryState {
  @override
  List<Object> get props => [];
}

class CountrySelectionLoading extends SelectCountryState {
  @override
  List<Object> get props => [];
}

class ResetDataUpdated extends SelectCountryState {
  @override
  List<Object> get props => [];
}

class CountrySelectionSuccess extends SelectCountryState {
  @override
  List<Object> get props => [];
}

class CountrySelectionUpdated extends SelectCountryState {
  final CountryListData country;

  const CountrySelectionUpdated(this.country);

  @override
  List<Object?> get props => [country];
}

class SuffixBoolChangedState extends SelectCountryState {
  final bool? showBool;

  const SuffixBoolChangedState({this.showBool});

  @override
  List<Object> get props => [showBool!];
}

class SuffixBoolChangedStateInitial extends SelectCountryState {
  final bool? showBool;

  const SuffixBoolChangedStateInitial({this.showBool});

  @override
  List<Object> get props => [showBool!];
}

class CountryUpdateInit extends SelectCountryState {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends SelectCountryState {
  @override
  List<Object> get props => [];
}

class CountryListAPISuccess extends SelectCountryState {
  @override
  List<Object> get props => [];
}

class CountryDetailsLoaded extends SelectCountryState {
  final List<CountryListData>? countryDetails;

  const CountryDetailsLoaded({
    this.countryDetails,
  });

  @override
  List<Object> get props => [countryDetails!];
}

class CountrySelectionError extends SelectCountryState {
  final String errorMessage;

  const CountrySelectionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

