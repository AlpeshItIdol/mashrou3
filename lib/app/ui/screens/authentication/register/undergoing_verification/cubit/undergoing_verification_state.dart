part of 'undergoing_verification_cubit.dart';

abstract class UndergoingVerificationState extends Equatable {
  const UndergoingVerificationState();
}

class UndergoingVerificationInitial extends UndergoingVerificationState {
  @override
  List<Object> get props => [];
}

class UndergoingVerificationLoading extends UndergoingVerificationState {
  @override
  List<Object> get props => [];
}

class UndergoingVerificationSuccess extends UndergoingVerificationState {
  @override
  List<Object> get props => [];
}

class CountryUpdateInit extends UndergoingVerificationState {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends UndergoingVerificationState {
  @override
  List<Object> get props => [];
}

class APISuccess extends UndergoingVerificationState {
  @override
  List<Object> get props => [];
}

class UndergoingVerificationError extends UndergoingVerificationState {
  String errorMessage;

  UndergoingVerificationError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
