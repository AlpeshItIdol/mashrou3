part of 'otp_verification_cubit.dart';

abstract class OtpVerificationState extends Equatable {
  const OtpVerificationState();
}

class OtpVerificationInitial extends OtpVerificationState {
  @override
  List<Object> get props => [];
}

class OtpVerificationLoading extends OtpVerificationState {
  @override
  List<Object> get props => [];
}

class OtpVerificationSuccess extends OtpVerificationState {
  final VerifyResponseModel model;

  const OtpVerificationSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class CountryUpdateInit extends OtpVerificationState {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends OtpVerificationState {
  @override
  List<Object> get props => [];
}

class ResendOtpSuccess extends OtpVerificationState {
  final ResendOtpResponseModel resendOtpResponse;

  const ResendOtpSuccess(this.resendOtpResponse);

  @override
  List<Object> get props => [resendOtpResponse];
}

class OtpVerificationError extends OtpVerificationState {
  final String errorMessage;

  const OtpVerificationError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
