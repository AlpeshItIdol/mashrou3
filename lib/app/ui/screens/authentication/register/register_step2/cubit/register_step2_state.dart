part of 'register_step2_cubit.dart';

abstract class RegisterStep2State extends Equatable {
  const RegisterStep2State();
}

class RegisterStep2Initial extends RegisterStep2State {
  @override
  List<Object> get props => [];
}

class ClearValueState extends RegisterStep2State {
  @override
  List<Object> get props => [];
}

class ClearValueStateInit extends RegisterStep2State {
  @override
  List<Object> get props => [];
}

class RegisterStep2Loading extends RegisterStep2State {
  @override
  List<Object> get props => [];
}

class RegisterStep2Success extends RegisterStep2State {
  final SignUpResponseModel model;

  const RegisterStep2Success({required this.model});

  @override
  List<Object> get props => [model];
}

class CountryUpdateInit extends RegisterStep2State {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends RegisterStep2State {
  @override
  List<Object> get props => [];
}

class RegisterStep2Error extends RegisterStep2State {
  final String errorMessage;

  const RegisterStep2Error(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}



class APISuccess extends RegisterStep2State {
  @override
  List<Object> get props => [];
}
