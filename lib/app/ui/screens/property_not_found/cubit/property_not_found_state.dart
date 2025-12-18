part of 'property_not_found_cubit.dart';

abstract class PropertyNotFoundState extends Equatable {
  const PropertyNotFoundState();
}

class PropertyNotFoundInitial extends PropertyNotFoundState {
  @override
  List<Object> get props => [];
}

class PropertyNotFoundLoading extends PropertyNotFoundState {
  @override
  List<Object> get props => [];
}

class PropertyNotFoundSuccess extends PropertyNotFoundState {
  @override
  List<Object> get props => [];
}

class CountryUpdateInit extends PropertyNotFoundState {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends PropertyNotFoundState {
  @override
  List<Object> get props => [];
}

class APISuccess extends PropertyNotFoundState {
  @override
  List<Object> get props => [];
}

class PropertyNotFoundError extends PropertyNotFoundState {
  String errorMessage;

  PropertyNotFoundError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
