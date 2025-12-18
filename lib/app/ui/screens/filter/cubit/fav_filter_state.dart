part of 'fav_filter_cubit.dart';

sealed class FavFilterState extends Equatable {
  const FavFilterState();
}

final class FavFilterInitial extends FavFilterState {
  @override
  List<Object> get props => [];
}

final class FavFilterStatusLoading extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterStatusSuccess extends FavFilterState {
  final List<FilterStatusData> dataList;

  const FavFilterStatusSuccess({required this.dataList});

  @override
  List<Object> get props => [dataList];
}

class FavFilterStatusFailure extends FavFilterState {
  final String errorMessage;

  const FavFilterStatusFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FavPropertyFurnishedLoading extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavPropertyFurnishedSuccess extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavPropertyFurnishedFailure extends FavFilterState {
  final String errorMessage;

  const FavPropertyFurnishedFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FavFilterCountryLoading extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterCountrySuccess extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterCountryFailure extends FavFilterState {
  final String errorMessage;

  const FavFilterCountryFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FavFilterCityLoading extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterCitySuccess extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterCityFailure extends FavFilterState {
  final String errorMessage;

  const FavFilterCityFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FavFilterRadiusUpdated extends FavFilterState {
  final int radiusValue;

  const FavFilterRadiusUpdated(this.radiusValue);

  @override
  List<Object> get props => [radiusValue];
}

class FavApplyPropertyFilter extends FavFilterState {
  final FilterRequestModel filterRequestModel;

  const FavApplyPropertyFilter(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}

class FilterFavNeighbourhoodDataSet extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterNeighbourhoodLoading extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterNeighbourhoodSuccess extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterNeighbourhoodFailure extends FavFilterState {
  final String errorMessage;

  const FavFilterNeighbourhoodFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FavFilterReset extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterCurrencyLoading extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterCurrencySuccess extends FavFilterState {
  @override
  List<Object> get props => [];
}

class FavFilterCurrencyFailure extends FavFilterState {
  final String errorMessage;

  const FavFilterCurrencyFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
