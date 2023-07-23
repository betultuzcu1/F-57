import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../widgets/add_product.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({Key? key}) : super(key: key);

  static const routeName = 'add-product';

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  var _isLoading = false;

  void _submitProductInfo(
    String productBarcode,
    String productName,
    String productDescription,
    String productQuantity,
    String productPrice,
    String productLocation,
    String productImageUrl,
    String productQrCode,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final userId = FirebaseAuth.instance.currentUser;

      DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      DateTime dateTime = DateTime.now();

      DateFormat dateFormatDoc = DateFormat("dd-MM-yyyy HH:mm:ss");
      DateTime dateTimeDoc = DateTime.now();

      await FirebaseFirestore.instance
          .collection('products')
          .doc(userId!.uid)
          .collection('user_product_list')
          .doc(productQrCode)
          .set(
        {
          'dateTime': dateFormat.format(dateTime),
          'creator': userId.uid,
          'productBarcode': productBarcode,
          'productQrCode': productQrCode,
          'productName': productName,
          'productDescription': productDescription,
          'productPrice': productPrice,
          'productLocation': productLocation,
          'productImageUrl': productImageUrl,
          'productQuantity': productQuantity,
          'stockIn': '0',
          'stockOut': '0',
        },
      ).then(
        (value) async => await FirebaseFirestore.instance
            .collection('history')
            .doc(userId.uid)
            .collection('history_product')
            .doc(dateFormatDoc.format(dateTimeDoc))
            .set(
          {
            'dateTime': dateFormat.format(dateTime),
            'productName': productName,
            'productQuantity': productQuantity,
          },
        ),
      );
    } on FirebaseAuthException catch (error) {
      String message =
          'An error occurred, please check your product information!';

      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: AddProduct(
        isLoading: _isLoading,
        submitProductInfo: _submitProductInfo,
      ),
    );
  }
}
