part of 'favourite_cubit.dart';

sealed class FavouriteState extends Equatable {
  const FavouriteState();
}

final class FavouriteInitial extends FavouriteState {
  @override
  List<Object> get props => [];
}

final class FavouriteLoading extends FavouriteState {
  @override
  List<Object> get props => [];
}

class PropertyFavListRefresh extends FavouriteState {
  @override
  List<Object> get props => [];
}

final class FavouriteError extends FavouriteState {
  final String errorMessage;

  const FavouriteError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyListLoading extends FavouriteState {
  @override
  List<Object> get props => [];
}

class PropertyMoreListLoading extends FavouriteState {
  @override
  List<Object> get props => [];
}

class PropertyListLoaded extends FavouriteState {
  @override
  List<Object> get props => [];
}

class PropertyFavListSuccess extends FavouriteState {
  bool isLastPage;
  int currentKey;
  List<PropertyData> propertyList;

  PropertyFavListSuccess(this.isLastPage, this.currentKey, this.propertyList);

  @override
  List<Object> get props => [isLastPage, currentKey, propertyList];
}

class NoPropertyFavFoundState extends FavouriteState {
  @override
  List<Object> get props => [];
}

class PropertyListError extends FavouriteState {
  final String errorMessage;

  const PropertyListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyRefreshList extends FavouriteState {
  @override
  List<Object> get props => [];
}

class AddedToFavorite extends FavouriteState {
  final String successMessage;

  const AddedToFavorite(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

final class FavCategoryUpdated extends FavouriteState {
  final String categoryId;

  const FavCategoryUpdated({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class FavFilterModelUpdate extends FavouriteState {
  final FilterRequestModel filterRequestModel;

  const FavFilterModelUpdate(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}
