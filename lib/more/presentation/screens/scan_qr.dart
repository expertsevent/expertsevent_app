import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../controller/more_cubit.dart';
class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  GlobalKey? scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  late final cubit = MoreCubit.get(context);
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldGlobalKey,
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(borderRadius: 10),
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      //Navigator.of(cubit.scaffoldGlobalKey!.currentContext!, rootNavigator: true).pop(scanData);
      Navigator.of(context,rootNavigator: true).pop(scanData);
      controller.dispose();
    });
    controller.resumeCamera();
  }

}