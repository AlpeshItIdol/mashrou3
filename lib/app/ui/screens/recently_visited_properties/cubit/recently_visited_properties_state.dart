part of 'recently_visited_properties_cubit.dart';

sealed class RecentlyVisitedPropertiesState extends Equatable {
  const RecentlyVisitedPropertiesState();
}

final class RecentlyVisitedPropertiesInitial
    extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

final class RecentlyVisitedPropertiesLoading
    extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

final class APISuccess extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryListUpdate extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryUpdated extends RecentlyVisitedPropertiesState {
  final String categoryId;

  const PropertyCategoryUpdated({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class RecentlyVisitedPropertiesFilterModelUpdate
    extends RecentlyVisitedPropertiesState {
  final FilterRequestModel filterRequestModel;

  const RecentlyVisitedPropertiesFilterModelUpdate(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}

final class RecentlyVisitedPropertiesError
    extends RecentlyVisitedPropertiesState {
  final String errorMessage;

  const RecentlyVisitedPropertiesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class RecentlyVisitedPropertiesMoreListLoading
    extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

class RecentlyVisitedPropertiesListLoaded
    extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

class ToggleFavoriteList extends RecentlyVisitedPropertiesState {
  final int index;
  final bool value;

  const ToggleFavoriteList(this.index, this.value);

  @override
  List<Object> get props => [index, value];
}

class FavoriteRefresh extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

class AddedToFavorite extends RecentlyVisitedPropertiesState {
  final String successMessage;

  const AddedToFavorite(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class RecentlyVisitedPropertiesListSuccess
    extends RecentlyVisitedPropertiesState {
  bool isLastPage;
  int currentKey;
  List<PropertyDetailData> propertyList;

  RecentlyVisitedPropertiesListSuccess(
      this.isLastPage, this.currentKey, this.propertyList);

  @override
  List<Object> get props => [isLastPage, currentKey, propertyList];
}

class NoRecentlyVisitedPropertiesFoundState
    extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

class RecentlyVisitedPropertiesListError
    extends RecentlyVisitedPropertiesState {
  final String errorMessage;

  const RecentlyVisitedPropertiesListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class RecentlyVisitedPropertiesRefreshList
    extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

class SortRecentlyVisitedPropertiesListUpdate
    extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

class StateRefresh extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedStateInitial extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends RecentlyVisitedPropertiesState {
  bool showBool;

  SuffixBoolChangedState({required this.showBool});

  @override
  List<Object> get props => [this.showBool];
}

final class ToggleSelectPropertiesInit extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

final class ToggleSelectPropertiesUpdate extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

final class ToggleSelectAllPropertiesInit extends RecentlyVisitedPropertiesState {
  @override
  List<Object> get props => [];
}

final class ToggleSelectAllPropertiesUpdate extends RecentlyVisitedPropertiesState {
  final bool isAllSelected;

  const ToggleSelectAllPropertiesUpdate(this.isAllSelected);

  @override
  List<Object> get props => [isAllSelected];
}
