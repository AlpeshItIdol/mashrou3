part of 'register_step1_cubit.dart';

abstract class RegisterStep1State extends Equatable {
  const RegisterStep1State();
}

class RegisterStep1Initial extends RegisterStep1State {
  @override
  List<Object> get props => [];
}

class RegisterStep1Loading extends RegisterStep1State {
  @override
  List<Object> get props => [];
}

class RegisterStep1Success extends RegisterStep1State {
  @override
  List<Object> get props => [];
}

class CountryUpdateInit extends RegisterStep1State {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends RegisterStep1State {
  @override
  List<Object> get props => [];
}

class RegisterStep1Error extends RegisterStep1State {
  final String errorMessage;

  const RegisterStep1Error(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
