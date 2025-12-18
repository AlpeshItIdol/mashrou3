part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final LoginResponseModel loginResponse;

  const LoginSuccess({required this.loginResponse});
  @override
  List<Object> get props => [loginResponse];
}

class CountryUpdateInit extends LoginState {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class APISuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginError extends LoginState {
  String errorMessage;

  LoginError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
