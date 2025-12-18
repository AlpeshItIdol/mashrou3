import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityCubit() : super(ConnectivityUnknown()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .asyncExpand((connectivityList) => Stream.fromIterable(connectivityList))
        .listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(ConnectivityResult connectivity) {
    if (connectivity == ConnectivityResult.none) {
      emit(ConnectivityNone());
    } else if (connectivity == ConnectivityResult.wifi) {
      emit(ConnectivityWifi());
    } else if (connectivity == ConnectivityResult.mobile) {
      emit(ConnectivityMobile());
    } else {
      emit(ConnectivityNone());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
