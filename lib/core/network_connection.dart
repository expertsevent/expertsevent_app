import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkInfo {
  static final _controller = StreamController<bool>.broadcast();

  static Stream<bool> get stream => _controller.stream;

  static void initialize() async {
    // Emit initial internet status
    bool initialStatus = await InternetConnectionChecker.instance.hasConnection;
    _controller.add(initialStatus);
    print('NetworkInfo initialized: $initialStatus');

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) async {
      bool hasInternet = await InternetConnectionChecker.instance.hasConnection;
      _controller.add(hasInternet);
      print('NetworkInfo changed: $hasInternet');
    });
  }
}
