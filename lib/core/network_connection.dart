import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkInfo {
  static final _controller = StreamController<bool>.broadcast();

  static Stream<bool> get stream => _controller.stream;

  static void initialize() {
    Connectivity().onConnectivityChanged.listen((result) async {
      // check actual internet (not just wifi/mobile)
      bool hasInternet = await InternetConnectionChecker.instance.hasConnection;
      _controller.add(hasInternet);
    });
  }
}
