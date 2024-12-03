// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkConnectivityService {
  final StreamController<bool> _connectivityStreamController =
      StreamController<bool>();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isDialogShowing = false;

  NetworkConnectivityService() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
    _checkConnectivity();
  }

  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  void dispose() {
    _connectivitySubscription.cancel();
    _connectivityStreamController.close();
  }

  Future<void> _checkConnectivity() async {
    List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResults);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final isConnected = !results.contains(ConnectivityResult.none);

    if (!isConnected && !_isDialogShowing) {
      _showNoConnectionDialog();
    } else if (isConnected && _isDialogShowing) {
      Get.back();
      _isDialogShowing = false;
    }

    _connectivityStreamController.add(isConnected);
  }

  void _showNoConnectionDialog() {
    _isDialogShowing = true;
    Get.defaultDialog(
      title: "No Internet Connection",
      titlePadding: const EdgeInsets.symmetric(horizontal: 10)
          .copyWith(top: 20, bottom: 10),
      content: const Center(
          child: Text(
        "Please check your internet connection and try again.",
      )),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      actions: <Widget>[
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Get.back();
            _isDialogShowing = false;
          },
        ),
      ],
    ).then((value) {
      _isDialogShowing = false;
    });
  }

  static Future<bool> checkInternetConnection() async {
    List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();
    return !connectivityResults.contains(ConnectivityResult.none);
  }
}
