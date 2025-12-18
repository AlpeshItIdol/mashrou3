part of 'in_review_filter_cubit.dart';

sealed class InReviewFilterState extends Equatable {
  const InReviewFilterState();
}

final class InReviewFilterInitial extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class FilterNeighbourhoodDataSet extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

final class InReviewFilterStatusLoading extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class InReviewFilterStatusSuccess extends InReviewFilterState {
  final List<FilterStatusData> dataList;

  const InReviewFilterStatusSuccess({required this.dataList});

  @override
  List<Object> get props => [dataList];
}

class InReviewFilterStatusFailure extends InReviewFilterState {
  final String errorMessage;

  const InReviewFilterStatusFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PropertyFurnishedLoading extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class PropertyFurnishedSuccess extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class PropertyFurnishedFailure extends InReviewFilterState {
  final String errorMessage;

  const PropertyFurnishedFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterCountryLoading extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class FilterCountrySuccess extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class FilterCountryFailure extends InReviewFilterState {
  final String errorMessage;

  const FilterCountryFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterCityLoading extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class FilterCitySuccess extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class FilterCityFailure extends InReviewFilterState {
  final String errorMessage;

  const FilterCityFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterRadiusUpdated extends InReviewFilterState {
  final int radiusValue;

  const FilterRadiusUpdated(this.radiusValue);

  @override
  List<Object> get props => [radiusValue];
}

class ApplyInReviewFilter extends InReviewFilterState {
  final FilterRequestModel filterRequestModel;

  const ApplyInReviewFilter(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}

class FilterNeighbourhoodLoading extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class FilterNeighbourhoodSuccess extends InReviewFilterState {
  @override
  List<Object> get props => [];
}

class FilterNeighbourhoodFailure extends InReviewFilterState {
  final String errorMessage;

  const FilterNeighbourhoodFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class InReviewFilterReset extends InReviewFilterState {
  @override
  List<Object> get props => [];
}
