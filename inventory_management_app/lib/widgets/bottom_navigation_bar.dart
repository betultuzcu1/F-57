import 'package:flutter/material.dart';
import 'package:inventory_management_app/screens/product_history.dart';
import 'package:inventory_management_app/widgets/color.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../screens/product_add_screen.dart';
import '../screens/qrcode_screen.dart';
import '../screens/home_screen.dart';
import '../screens/products_screen.dart';
import '../screens/settings_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  List<Widget> _navigationBarScreens() {
    return [
      const HomeScreen(),
      const ProductsScreen(),
      const QRCodeScannerScreen(),
      const SettingsScreen(),
    ];
  }

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ('Home'),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white60,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          routes: {
            ProductHistory.routeName: (context) => const ProductHistory(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.warehouse_rounded),
        title: ('Product'),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white60,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          routes: {
            ProductAddScreen.routeName: (context) => const ProductAddScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.qr_code_rounded),
        title: ('QR-Code'),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white60,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: ('Setting'),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white60,
      ),
    ];
  }
  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _navigationBarScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.lightBlue.shade900,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: false,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}
