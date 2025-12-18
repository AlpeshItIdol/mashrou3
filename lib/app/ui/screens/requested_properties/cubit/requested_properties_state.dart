part of 'requested_properties_cubit.dart';

sealed class RequestedPropertiesState extends Equatable {
  const RequestedPropertiesState();
}

final class RequestedPropertiesInitial extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

final class RequestedPropertiesLoading extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

final class APISuccess extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryListUpdate extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryUpdated extends RequestedPropertiesState {
  final String categoryId;

  const PropertyCategoryUpdated({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class RequestedPropertiesFilterModelUpdate extends RequestedPropertiesState {
  final FilterRequestModel filterRequestModel;

  const RequestedPropertiesFilterModelUpdate(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}

final class RequestedPropertiesError extends RequestedPropertiesState {
  final String errorMessage;

  const RequestedPropertiesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class RequestedPropertiesListLoading extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

class RequestedPropertiesMoreListLoading extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

class RequestedPropertiesListLoaded extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

class ToggleFavoriteList extends RequestedPropertiesState {
  final int index;
  final bool value;

  const ToggleFavoriteList(this.index, this.value);

  @override
  List<Object> get props => [index, value];
}

class FavoriteRefresh extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

class AddedToFavorite extends RequestedPropertiesState {
  final String successMessage;

  const AddedToFavorite(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class RequestedPropertiesListSuccess extends RequestedPropertiesState {
  bool isLastPage;
  int currentKey;
  List<VisitRequestData> propertyList;

  RequestedPropertiesListSuccess(this.isLastPage, this.currentKey, this.propertyList);

  @override
  List<Object> get props => [isLastPage, currentKey, propertyList];
}

class NoRequestedPropertiesFoundState extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

class RequestedPropertiesListError extends RequestedPropertiesState {
  final String errorMessage;

  const RequestedPropertiesListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class RequestedPropertiesRefreshList extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

class SortRequestedPropertiesListUpdate extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}

class StateRefresh extends RequestedPropertiesState {
  @override
  List<Object> get props => [];
}
