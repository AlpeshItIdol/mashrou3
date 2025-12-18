part of 'view_review_cubit.dart';

sealed class ViewReviewState extends Equatable {
  const ViewReviewState();
}

final class ViewReviewInitial extends ViewReviewState {
  @override
  List<Object> get props => [];
}

class ReviewsLoading extends ViewReviewState {
  @override
  List<Object> get props => [];
}

class ReviewsListSuccess extends ViewReviewState {
  bool isLastPage;
  int currentKey;
  List<ReviewData> reviewListData;

  ReviewsListSuccess(this.isLastPage, this.currentKey, this.reviewListData);

  @override
  List<Object> get props => [isLastPage, currentKey, reviewListData];
}

class ReviewsListError extends ViewReviewState {
  final String errorMessage;

  const ReviewsListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NoReviewsFoundState extends ViewReviewState {
  @override
  List<Object> get props => [];
}

class ReviewsMoreListLoading extends ViewReviewState {
  @override
  List<Object> get props => [];
}

class ReviewsListLoaded extends ViewReviewState {
  @override
  List<Object> get props => [];
}
