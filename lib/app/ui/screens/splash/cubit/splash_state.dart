part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => ["SplashInitial"];
}

class SplashLoading extends SplashState {
  @override
  List<Object> get props => ["SplashInitial"];
}

class APISuccess extends SplashState {
  @override
  List<Object> get props => [""];
}

 class SplashError extends SplashState {
  final String errorMessage;

  const SplashError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class InitialiseComplete extends SplashState {
  @override
  List<Object> get props => ["InitialiseComplete"];
}
