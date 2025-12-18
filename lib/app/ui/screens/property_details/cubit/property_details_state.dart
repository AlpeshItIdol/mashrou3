part of 'property_details_cubit.dart';

sealed class PropertyDetailsState extends Equatable {
  const PropertyDetailsState();
}

final class PropertyDetailsInitial extends PropertyDetailsState {
  @override
  List<Object> get props => [];
}

final class PropertyViewCountSuccess extends PropertyDetailsState {
  @override
  List<Object> get props => [];
}

final class PropertyDetailsLoading extends PropertyDetailsState {
  @override
  List<Object> get props => [];
}

final class PropertyDetailsAPILoading extends PropertyDetailsState {
  @override
  List<Object> get props => [];
}

final class PropertyDetailsLoaded extends PropertyDetailsState {
  @override
  List<Object> get props => [];
}

class PropertyDetailsSuccess extends PropertyDetailsState {
  final PropertyDetailData model;

  const PropertyDetailsSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class OffersListSuccess extends PropertyDetailsState {
  final OffersListForPropertyResponseModel model;

  const OffersListSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class PropertyDetailsFailure extends PropertyDetailsState {
  final String errorMessage;

  const PropertyDetailsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PropertyDetailsError extends PropertyDetailsState {
  final String errorMessage;

  const PropertyDetailsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AddedToFavoriteForPropertyDetail extends PropertyDetailsState {
  final String successMessage;

  const AddedToFavoriteForPropertyDetail(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}
