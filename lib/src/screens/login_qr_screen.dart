import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class LoginQrScreen extends StatefulWidget {
  const LoginQrScreen({super.key});

  @override
  State<LoginQrScreen> createState() => _LoginQrScreenState();
}

class _LoginQrScreenState extends State<LoginQrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: QRView(
        formatsAllowed: const [
          BarcodeFormat.qrcode,
        ],
        overlay: QrScannerOverlayShape(
          borderColor: theme.colorScheme.primaryContainer,
          borderWidth: 15,
          borderRadius: 10,
        ),
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final code = scanData.code;
      if (code != null && code.isNotEmpty) {
        final uri = Uri.tryParse(code);
        if (uri != null && uri.isScheme('nc')) {
          Navigator.of(context).pop(uri);
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
