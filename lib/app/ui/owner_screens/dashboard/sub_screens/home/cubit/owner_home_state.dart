part of 'owner_home_cubit.dart';

sealed class OwnerHomeState extends Equatable {
  const OwnerHomeState();
}

final class APISuccess extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryListUpdate extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

final class OwnerHomeInitial extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

final class OwnerHomeLoading extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

final class OwnerHomeError extends OwnerHomeState {
  final String errorMessage;

  const OwnerHomeError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyListLoading extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

class PropertyMoreListLoading extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

class PropertyListLoaded extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

class ToggleFavoriteList extends OwnerHomeState {
  final int index;
  final bool value;

  const ToggleFavoriteList(this.index, this.value);

  @override
  List<Object> get props => [index, value];
}

class FavoriteRefresh extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

class AddedToFavorite extends OwnerHomeState {
  final String successMessage;

  const AddedToFavorite(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class PropertyListSuccess extends OwnerHomeState {
  bool isLastPage;
  int currentKey;
  List<PropertyData> propertyList;

  PropertyListSuccess(this.isLastPage, this.currentKey, this.propertyList);

  @override
  List<Object> get props => [isLastPage, currentKey, propertyList];
}

class NoPropertyFoundState extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

class SoldOutLoadedState extends OwnerHomeState {
  final bool soldOut;

  const SoldOutLoadedState(this.soldOut);

  @override
  List<Object> get props => [];
}

class PropertyListError extends OwnerHomeState {
  final String errorMessage;

  const PropertyListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyRefreshList extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

class SortPropertyListUpdate extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

class StateRefresh extends OwnerHomeState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryUpdated extends OwnerHomeState {
  final String categoryId;

  const PropertyCategoryUpdated({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class PropertyFilterModelUpdate extends OwnerHomeState {
  final FilterRequestModel filterRequestModel;

  const PropertyFilterModelUpdate(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}
