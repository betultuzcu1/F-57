import 'package:flutter/material.dart';
import 'package:inventory_management_app/view/widgets/qr_code.dart';

class WarehouseQRCodeScannerScreen extends StatelessWidget {
  const WarehouseQRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QRCodeScanner(),
    );
  }
}
