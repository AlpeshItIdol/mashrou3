part of 'personal_information_cubit.dart';

sealed class PersonalInformationState extends Equatable {
  const PersonalInformationState();
}

final class PersonalInformationInitial extends PersonalInformationState {
  @override
  List<Object> get props => [];
}

final class PersonalInformationLoading extends PersonalInformationState {
  @override
  List<Object> get props => [];
}

final class UserDetailsLoadedForPersonalInformation extends PersonalInformationState {
  @override
  List<Object> get props => [];
}

final class UpdatedUserDetailsLoading extends PersonalInformationState {
  @override
  List<Object> get props => [];
}

final class UpdatedUserDetailsLoaded extends PersonalInformationState {
  @override
  List<Object> get props => [];
}

final class PersonalInformationCountryFetchSuccess extends PersonalInformationState {
  @override
  List<Object> get props => [];
}

final class APISuccess extends PersonalInformationState {
  @override
  List<Object> get props => [];
}

final class ImageDataLoaded extends PersonalInformationState {
  @override
  List<Object> get props => [];
}

final class PersonalInformationError extends PersonalInformationState {
  final String errorMessage;

  const PersonalInformationError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class CompleteProfileSuccess extends PersonalInformationState {
  final VerifyResponseModel model;

  const CompleteProfileSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class DeleteProfileSuccess extends PersonalInformationState {
  final String successMessage;

  const DeleteProfileSuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}
