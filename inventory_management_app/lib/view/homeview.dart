import 'package:flutter/material.dart';
import 'package:inventory_management_app/view/widgets/bottom_nav_bar.dart';

class WarehouseHomeScreen extends StatelessWidget {
  const WarehouseHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('warehouse'),
      ),
      bottomNavigationBar: NavigationBarScreen(),
    );
  }
}
