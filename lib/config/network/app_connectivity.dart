import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class AppConnectivity {
  AppConnectivity._internal();

  static final AppConnectivity _instance = AppConnectivity._internal();

  static AppConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  /// Initialise connectivity listeners.
  void initialise() async {
    List<ConnectivityResult> results = await connectivity.checkConnectivity();

    /// Check for connection status.
    _checkForEachNetWorkStatus(results);

    /// Listen for connectivity change.
    connectivity.onConnectivityChanged.listen((result) {
      /// Check for connection status.
      _checkForEachNetWorkStatus(result);
    });
  }

  /// Check for connection status for each request.
  void _checkForEachNetWorkStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      _checkStatus(results
          .firstWhere((element) => element == ConnectivityResult.mobile));
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      _checkStatus(results
          .firstWhere((element) => element == ConnectivityResult.bluetooth));
    } else if (results.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      _checkStatus(
          results.firstWhere((element) => element == ConnectivityResult.wifi));
    } else if (results.contains(ConnectivityResult.none)) {
      // No available network types
      controller.sink.add({ConnectivityResult: false});
    }
  }

  /// Check for network status.
  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
