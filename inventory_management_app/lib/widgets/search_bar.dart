import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/screens/product_details_screen.dart';

class ProductSearchPage extends SearchDelegate<String> {
  final userId = FirebaseAuth.instance.currentUser;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  } // IconButton

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(userId!.uid)
          .collection('user_product_list')
          .snapshots()
          .asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> data) =>
                  data['productName']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .isEmpty) {
            return const Center(
              child: Text('No search query found'),
            );
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> data) =>
                        data['productName']
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map(
                  (QueryDocumentSnapshot<Object?> data) {
                    final String productName = data.get('productName');
                    final String productBarcode = data['productBarcode'];
                    final String productQuantity = data['productQuantity'];

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                      productDetailIndex: data,
                                    )));
                      },
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          productName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      subtitle: Text(
                        productBarcode,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Text(
                        productQuantity,
                      ),
                    );
                  },
                ),
              ],
            );
          }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text("Search anything here"));
  }
}
