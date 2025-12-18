part of 'register_step3_cubit.dart';

abstract class RegisterStep3State extends Equatable {
  const RegisterStep3State();
}

class RegisterStep3Initial extends RegisterStep3State {
  @override
  List<Object> get props => [];
}

class RegisterStep3Loading extends RegisterStep3State {
  @override
  List<Object> get props => [];
}

class RegisterStep3Success extends RegisterStep3State {
  final VerifyResponseModel model;

  const RegisterStep3Success({required this.model});

  @override
  List<Object> get props => [model];
}

class SelectedRoleUpdate extends RegisterStep3State {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends RegisterStep3State {
  @override
  List<Object> get props => [];
}

class ResendOtpSuccess extends RegisterStep3State {
  final ResendOtpResponseModel resendOtpResponse;

  const ResendOtpSuccess(this.resendOtpResponse);

  @override
  List<Object> get props => [resendOtpResponse];
}

class RegisterStep3Error extends RegisterStep3State {
  final String errorMessage;

  const RegisterStep3Error(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
