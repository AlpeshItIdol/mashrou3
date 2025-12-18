part of 'filter_cubit.dart';

sealed class FilterState extends Equatable {
  const FilterState();
}

final class FilterInitial extends FilterState {
  @override
  List<Object> get props => [];
}

final class FilterStatusLoading extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterStatusSuccess extends FilterState {
  final List<FilterStatusData> dataList;

  const FilterStatusSuccess({required this.dataList});

  @override
  List<Object> get props => [dataList];
}

class FilterStatusFailure extends FilterState {
  final String errorMessage;

  const FilterStatusFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PropertyFurnishedLoading extends FilterState {
  @override
  List<Object> get props => [];
}

class PropertyFurnishedSuccess extends FilterState {
  @override
  List<Object> get props => [];
}

class PropertyFurnishedFailure extends FilterState {
  final String errorMessage;

  const PropertyFurnishedFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterCountryLoading extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterCountrySuccess extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterCountryFailure extends FilterState {
  final String errorMessage;

  const FilterCountryFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterCityLoading extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterCitySuccess extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterCityFailure extends FilterState {
  final String errorMessage;

  const FilterCityFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterRadiusUpdated extends FilterState {
  final int radiusValue;

  const FilterRadiusUpdated(this.radiusValue);

  @override
  List<Object> get props => [radiusValue];
}

class ApplyPropertyFilter extends FilterState {
  final FilterRequestModel filterRequestModel;

  const ApplyPropertyFilter(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}

class FilterNeighbourhoodDataSet extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterCurrencyLoading extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterCurrencySuccess extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterCurrencyFailure extends FilterState {
  final String errorMessage;

  const FilterCurrencyFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterNeighbourhoodLoading extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterNeighbourhoodSuccess extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterNeighbourhoodFailure extends FilterState {
  final String errorMessage;

  const FilterNeighbourhoodFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterReset extends FilterState {
  @override
  List<Object> get props => [];
}
