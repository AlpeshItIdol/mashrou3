part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();
}

class ApplicationInitial extends ApplicationState {
  @override
  List<Object> get props => [];
}

class ApplicationLoading extends ApplicationState {
  @override
  List<Object> get props => [];
}

class APISuccess extends ApplicationState {
  @override
  List<Object> get props => [];
}

class ApplicationError extends ApplicationState {
  final String errorMessage;

  const ApplicationError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
