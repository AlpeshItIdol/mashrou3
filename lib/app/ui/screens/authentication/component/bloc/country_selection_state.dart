part of 'country_selection_cubit.dart';

abstract class CountrySelectionState extends Equatable {
  const CountrySelectionState();

  @override
  List<Object?> get props => [];
}

class CountrySelectionInitial extends CountrySelectionState {
  @override
  List<Object> get props => [];
}

class CountrySelectionLoading extends CountrySelectionState {
  @override
  List<Object> get props => [];
}

class ResetDataUpdated extends CountrySelectionState {
  @override
  List<Object> get props => [];
}

class CountrySelectionSuccess extends CountrySelectionState {
  @override
  List<Object> get props => [];
}

class CountrySelectionUpdated extends CountrySelectionState {
  final CountryListData country;

  const CountrySelectionUpdated(this.country);

  @override
  List<Object?> get props => [country];
}

class SuffixBoolChangedStateInitial extends CountrySelectionState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends CountrySelectionState {
  final bool? showBool;

  const SuffixBoolChangedState({this.showBool});

  @override
  List<Object> get props => [showBool!];
}

class CountryUpdateInit extends CountrySelectionState {
  @override
  List<Object> get props => [];
}

class CountryListAPISuccess extends CountrySelectionState {
  @override
  List<Object> get props => [];
}

class CountryDetailsLoaded extends CountrySelectionState {
  final List<CountryListData>? countryDetails;

  const CountryDetailsLoaded({
    this.countryDetails,
  });

  @override
  List<Object> get props => [countryDetails!];
}

class CountrySelectionError extends CountrySelectionState {
  final String errorMessage;

  const CountrySelectionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
