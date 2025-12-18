part of 'owner_property_details_cubit.dart';

sealed class OwnerPropertyDetailsState extends Equatable {
  const OwnerPropertyDetailsState();
}

final class OwnerPropertyDetailsInitial extends OwnerPropertyDetailsState {
  @override
  List<Object> get props => [];
}



final class OwnerPropertyDetailsLoading extends OwnerPropertyDetailsState {
  @override
  List<Object> get props => [];
}

final class OwnerPropertyDetailsLoaded extends OwnerPropertyDetailsState {
  @override
  List<Object> get props => [];
}

final class OwnerNotValidForProperty extends OwnerPropertyDetailsState {
  @override
  List<Object> get props => [];
}

class OwnerPropertyDetailsSuccess extends OwnerPropertyDetailsState {
  final PropertyDetailData model;

  const OwnerPropertyDetailsSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class OwnerPropertyDetailsFailure extends OwnerPropertyDetailsState {
  final String errorMessage;

  const OwnerPropertyDetailsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class OwnerPropertyDetailsError extends OwnerPropertyDetailsState {
  final String errorMessage;

  const OwnerPropertyDetailsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class SoldOutPropertySuccess extends OwnerPropertyDetailsState {
  final String successMessage;

  const SoldOutPropertySuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class DeletePropertySuccess extends OwnerPropertyDetailsState {
  final String successMessage;

  const DeletePropertySuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

