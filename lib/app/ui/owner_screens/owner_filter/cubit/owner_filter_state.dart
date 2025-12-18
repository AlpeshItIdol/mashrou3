part of 'owner_filter_cubit.dart';

sealed class OwnerFilterState extends Equatable {
  const OwnerFilterState();
}

final class OwnerFilterInitial extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterNeighbourhoodDataSet extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

final class FilterStatusLoading extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterStatusSuccess extends OwnerFilterState {
  final List<FilterStatusData> dataList;

  const FilterStatusSuccess({required this.dataList});

  @override
  List<Object> get props => [dataList];
}

class FilterStatusFailure extends OwnerFilterState {
  final String errorMessage;

  const FilterStatusFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PropertyFurnishedLoading extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class PropertyFurnishedSuccess extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class PropertyFurnishedFailure extends OwnerFilterState {
  final String errorMessage;

  const PropertyFurnishedFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterSliderUILoaded extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterCountryLoading extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterCountrySuccess extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterCountryFailure extends OwnerFilterState {
  final String errorMessage;

  const FilterCountryFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterCityLoading extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterCitySuccess extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterCityFailure extends OwnerFilterState {
  final String errorMessage;

  const FilterCityFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterRadiusUpdated extends OwnerFilterState {
  final int radiusValue;

  const FilterRadiusUpdated(this.radiusValue);

  @override
  List<Object> get props => [radiusValue];
}

class ApplyPropertyFilter extends OwnerFilterState {
  final FilterRequestModel filterRequestModel;

  const ApplyPropertyFilter(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}

class FilterNeighbourhoodLoading extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterNeighbourhoodSuccess extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterNeighbourhoodFailure extends OwnerFilterState {
  final String errorMessage;

  const FilterNeighbourhoodFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterReset extends OwnerFilterState {
  @override
  List<Object> get props => [];
}


class FilterCurrencyLoading extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterCurrencySuccess extends OwnerFilterState {
  @override
  List<Object> get props => [];
}

class FilterCurrencyFailure extends OwnerFilterState {
  final String errorMessage;

  const FilterCurrencyFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
