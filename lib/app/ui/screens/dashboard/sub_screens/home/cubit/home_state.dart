part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

final class APISuccess extends HomeState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryListUpdate extends HomeState {
  @override
  List<Object> get props => [];
}

final class ToggleSelectPropertiesInit extends HomeState {
  @override
  List<Object> get props => [];
}

final class ToggleSelectPropertiesUpdate extends HomeState {
  @override
  List<Object> get props => [];
}

final class ToggleSelectAllPropertiesInit extends HomeState {
  @override
  List<Object> get props => [];
}

final class ToggleSelectAllPropertiesUpdate extends HomeState {
  final bool isAllSelected;

  const ToggleSelectAllPropertiesUpdate(this.isAllSelected);

  @override
  List<Object> get props => [isAllSelected];
}

final class PropertyCategoryUpdated extends HomeState {
  final String categoryId;

  const PropertyCategoryUpdated({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class PropertyFilterModelUpdate extends HomeState {
  final FilterRequestModel filterRequestModel;

  const PropertyFilterModelUpdate(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}

final class HomeError extends HomeState {
  final String errorMessage;

  const HomeError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyListLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class PropertyListReset extends HomeState {
  @override
  List<Object> get props => [];
}

class PropertyListRefresh extends HomeState {
  @override
  List<Object> get props => [];
}

class PropertyMoreListLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class PropertyListLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

class ToggleFavoriteList extends HomeState {
  final int index;
  final bool value;

  const ToggleFavoriteList(this.index, this.value);

  @override
  List<Object> get props => [index, value];
}

class FavoriteRefresh extends HomeState {
  @override
  List<Object> get props => [];
}

class AddedToFavorite extends HomeState {
  final String successMessage;

  const AddedToFavorite(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class PropertyListSuccess extends HomeState {
  bool isLastPage;
  int currentKey;
  List<PropertyData> propertyList;

  PropertyListSuccess(this.isLastPage, this.currentKey, this.propertyList);

  @override
  List<Object> get props => [isLastPage, currentKey, propertyList];
}

class NoPropertyFoundState extends HomeState {
  @override
  List<Object> get props => [];
}


class PropertyAddFavLoadState extends HomeState {
  @override
  List<Object> get props => [];
}

class PropertyAddFavError extends HomeState {
  final String errorMessage;

  const PropertyAddFavError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyListError extends HomeState {
  final String errorMessage;

  const PropertyListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyRefreshList extends HomeState {
  @override
  List<Object> get props => [];
}

class SortPropertyListUpdate extends HomeState {
  @override
  List<Object> get props => [];
}

class StateRefresh extends HomeState {
  @override
  List<Object> get props => [];
}

class ItemsPerPageUpdated extends HomeState {
  final int itemsPerPage;

  const ItemsPerPageUpdated({required this.itemsPerPage});

  @override
  List<Object> get props => [itemsPerPage];
}
