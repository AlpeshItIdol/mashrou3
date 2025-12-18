part of 'connectivity_cubit.dart';

sealed class ConnectivityState extends Equatable {
  const ConnectivityState();
}

final class ConnectivityInitial extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityUnknown extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityNone extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityWifi extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityMobile extends ConnectivityState {
  @override
  List<Object> get props => [];
}
