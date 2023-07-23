import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_management_app/screens/product_history.dart';
import 'package:inventory_management_app/screens/low_stock_list.dart';
import 'package:inventory_management_app/screens/out_of_stock_list.dart';
import 'package:inventory_management_app/screens/home_screen.dart';
import 'package:inventory_management_app/screens/product_details_screen.dart';

import 'package:inventory_management_app/screens/products_screen.dart';
import 'package:inventory_management_app/widgets/chart.dart';

import './screens/authentication_screen.dart';
import './widgets/bottom_navigation_bar.dart';
import './screens/loading_screen.dart';
import './screens/product_add_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initializationFirebase =
        Firebase.initializeApp();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initializationFirebase,
      builder: (context, appSnapShot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WAREHOUSEBOX',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.blue.shade700,
              secondary: Colors.blue.shade700,
            ),
            fontFamily: 'Roboto',
            textTheme: const TextTheme(
              headline6: TextStyle(
                fontSize: 24.0,
              ),
              bodyText2: TextStyle(fontSize: 24),
            ),
          ),
          home: appSnapShot.connectionState != ConnectionState.done
              ? const LoadingScreen()
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  initialData: FirebaseAuth.instance.currentUser,
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const LoadingScreen();
                    }
                    //render your application if aut
                    if (userSnapshot.hasData) {
                      return const NavigationBarScreen();
                    }
                    //user is no signed in
                    return const AuthScreen();
                  },
                ),
          routes: {
            ProductAddScreen.routeName: (context) => const ProductAddScreen(),
            ProductsScreen.routeName: (context) => const ProductsScreen(),
            OutOfStockItemList.routeName: (context) =>
                const OutOfStockItemList(),
            LowStockItemList.routeName: (context) => const LowStockItemList(),
            ProductHistory.routeName: (context) => const ProductHistory(),
          },
        );
      },
    );
  }
}
