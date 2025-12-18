part of 'add_rating_cubit.dart';

sealed class AddRatingState extends Equatable {
  const AddRatingState();
}

final class AddRatingInitial extends AddRatingState {
  @override
  List<Object> get props => [];
}

class AddRatingReviewLoading extends AddRatingState {
  @override
  List<Object> get props => [];
}

class AddRatingReviewSuccess extends AddRatingState {
  final String message;

  const AddRatingReviewSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddRatingReviewError extends AddRatingState {
  final String errorMessage;

  const AddRatingReviewError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
