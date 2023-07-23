import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_management_app/view/homeview.dart';
import 'package:inventory_management_app/view/product.dart';
import 'package:inventory_management_app/view/qr_code_scanner.dart';
import 'package:inventory_management_app/view/setting.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  late List<Map<String, dynamic>> _navigationBarScreens;

  int _selectedScreenIndex = 0;

  @override
  void initState() {
    _navigationBarScreens = [
      {
        'screen': const WarehouseHomeScreen(),
      },
      {
        'screen': const WarehouseProductsScreen(),
      },
      {
        'screen': const WarehouseQRCodeScannerScreen(),
      },
      {
        'screen': const WarehouseSettingsScreen(),
      },
    ];
    super.initState();
  }

  void _selectNavigationBar(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            text: 'WAREHOUSE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'BOX',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            iconSize: 32,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 2,
            child: IconButton(
              iconSize: 26,
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ),
        ),
      ),
      body: _navigationBarScreens[_selectedScreenIndex]['screen'],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          onTap: _selectNavigationBar,
          backgroundColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.white60,
          selectedItemColor: Colors.white,
          currentIndex: _selectedScreenIndex,
          selectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          showUnselectedLabels: true,
          unselectedFontSize: 14,
          iconSize: 32,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: 'Home',
              icon: const Icon(Icons.home_rounded),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: 'Products',
              icon: const Icon(Icons.warehouse_rounded),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: 'QR-Code',
              icon: const Icon(Icons.qr_code_scanner_rounded),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: 'Settings',
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
