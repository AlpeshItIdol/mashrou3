part of 'in_review_cubit.dart';

sealed class InReviewState extends Equatable {
  const InReviewState();
}

final class InReviewInitial extends InReviewState {
  @override
  List<Object> get props => [];
}

final class InReviewLoading extends InReviewState {
  @override
  List<Object> get props => [];
}

final class InReviewError extends InReviewState {
  final String errorMessage;

  const InReviewError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyListLoading extends InReviewState {
  @override
  List<Object> get props => [];
}

class PropertyMoreListLoading extends InReviewState {
  @override
  List<Object> get props => [];
}

class NoPropertyFound extends InReviewState {
  @override
  List<Object> get props => [];
}

class PropertyListLoaded extends InReviewState {
  @override
  List<Object> get props => [];
}

class PropertyListSuccess extends InReviewState {
  bool isLastPage;
  int currentKey;
  List<PropertyReqData> propertyList;

  PropertyListSuccess(this.isLastPage, this.currentKey, this.propertyList);

  @override
  List<Object> get props => [isLastPage, currentKey, propertyList];
}

class NoPropertyFoundState extends InReviewState {
  @override
  List<Object> get props => [];
}

class PropertyListError extends InReviewState {
  final String errorMessage;

  const PropertyListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PropertyRefreshList extends InReviewState {
  @override
  List<Object> get props => [];
}

class AddedToFavorite extends InReviewState {
  final String successMessage;

  const AddedToFavorite(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

final class PropertyCategoryUpdated extends InReviewState {
  final String categoryId;

  const PropertyCategoryUpdated({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class PropertyFilterModelUpdate extends InReviewState {
  final FilterRequestModel filterRequestModel;

  const PropertyFilterModelUpdate(this.filterRequestModel);

  @override
  List<Object> get props => [filterRequestModel];
}
