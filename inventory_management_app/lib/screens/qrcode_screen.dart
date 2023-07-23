import 'package:flutter/material.dart';

import '../widgets/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatelessWidget {
  const QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QRCodeScanner(),
    );
  }
}
