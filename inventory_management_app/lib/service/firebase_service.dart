import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Stream<QuerySnapshot> getFirebaseDateStream() {
  final userId = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('products')
      .doc(userId!.uid)
      .collection('user_product_list')
      .snapshots();
}

Future<void> deleteProduct(String docId) async {
  CollectionReference product =
      FirebaseFirestore.instance.collection('products');
  final userId = FirebaseAuth.instance.currentUser;
  return await product
      .doc(userId!.uid)
      .collection('user_product_list')
      .doc(docId)
      .delete();
}

Future<DocumentSnapshot> getDataWithQrCode(String? qrData) async {
  print(qrData);
  final userId = FirebaseAuth.instance.currentUser;
  return await FirebaseFirestore.instance
      .collection('products')
      .doc(userId!.uid)
      .collection('user_product_list')
      .doc(qrData)
      .get();
}

Stream<QuerySnapshot> getOutOfStockList() {
  String outOfStock = '0';
  final userId = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('products')
      .doc(userId!.uid)
      .collection('user_product_list')
      .where('productQuantity', isEqualTo: outOfStock)
      .snapshots();
}

Stream<QuerySnapshot> getLowStockList() {
  String lowStock = '10';
  String outOfStock = '0';
  final userId = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('products')
      .doc(userId!.uid)
      .collection('user_product_list')
      .where(
        'productQuantity',
        isLessThanOrEqualTo: lowStock,
        isGreaterThan: outOfStock,
      )
      .snapshots();
}

Future<QuerySnapshot> getTodayDateTotalItem() async {
  final userId = FirebaseAuth.instance.currentUser;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  DateTime todayDate = DateTime.now();
  return await FirebaseFirestore.instance
      .collection('products')
      .doc(userId!.uid)
      .collection('user_product_list')
      .where(
        'dateTime',
        isGreaterThanOrEqualTo: dateFormat.format(todayDate),
      )
      .get();
}

Future<QuerySnapshot> getYesterdayDateTotalItem() async {
  final userId = FirebaseAuth.instance.currentUser;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  DateTime todayDate = DateTime.now();
  DateTime yesterdayDate = todayDate.subtract(const Duration(days: 1));
  return await FirebaseFirestore.instance
      .collection('products')
      .doc(userId!.uid)
      .collection('user_product_list')
      .where(
        'dateTime',
        isLessThanOrEqualTo: dateFormat.format(yesterdayDate),
      )
      .get();
}

Future<void> updateItem(
  String getProductBarcode,
  String getProductName,
  String getProductPrice,
  String getProductDescription,
  final DocumentSnapshot getDataProduct,
) async {
  final userId = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
      .collection('products')
      .doc(userId!.uid)
      .collection('user_product_list')
      .doc(getDataProduct['productQrCode'])
      .update(
    {
      'productBarcode': getProductBarcode,
      'qrData': getProductBarcode,
      'productName': getProductName,
      'productDescription': getProductDescription,
      'productPrice': getProductPrice,
    },
  );
}

Future<void> updateUserInfo(
  String email,
  String userName,
  String phoneNumber,
  String password,
) async {
  final userId = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance.collection('users').doc(userId!.uid).update(
    {
      'email': email,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'password': password,
    },
  );
}

void changePassword(String password) async {
  User? user = FirebaseAuth.instance.currentUser;
  String? email = user?.email;

  //Create field for user to input old password

  //pass the password here
  String password = "password";
  String newPassword = "password";

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password,
    );

    user?.updatePassword(newPassword).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}
