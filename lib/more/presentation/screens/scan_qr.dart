import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  StreamSubscription<Barcode>? _scanSubscription;
  bool _scanHandled = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    } else if (Platform.isIOS) {
      _controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    _releaseCamera();
    super.dispose();
  }

  void _releaseCamera() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    _controller?.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(borderRadius: 10),
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    _controller = qrController;
    _scanSubscription = qrController.scannedDataStream.listen((scanData) {
      if (_scanHandled || !mounted) return;
      _scanHandled = true;
      _releaseCamera();
      Navigator.of(context, rootNavigator: true).pop(scanData);
    });
    qrController.resumeCamera();
  }
}
