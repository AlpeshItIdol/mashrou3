part of 'city_list_cubit.dart';

sealed class CityListState extends Equatable {
  const CityListState();
}

final class CityListInitial extends CityListState {
  @override
  List<Object> get props => [];
}

class CityListLoading extends CityListState {
  @override
  List<Object> get props => [];
}

class CityRefreshLoading extends CityListState {
  @override
  List<Object> get props => [];
}


class CityListSuccess extends CityListState {
  List<Cities> cityList;
  bool isLastPage;
  int currentKey;

  CityListSuccess(this.cityList, this.isLastPage, this.currentKey);

  @override
  List<Object> get props => [cityList, isLastPage, currentKey];
}

class NoCityListFoundState extends CityListState {
  @override
  List<Object> get props => [];
}

class CityListError extends CityListState {
  final String errorMessage;

  const CityListError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class SuffixBoolChangedStateInitial extends CityListState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends CityListState {
  final bool? showBool;

  const SuffixBoolChangedState({this.showBool});

  @override
  List<Object> get props => [showBool!];
}
