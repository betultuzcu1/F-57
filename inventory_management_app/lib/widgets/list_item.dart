import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/product_details_screen.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.document,
  }) : super(key: key);

  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            document['productName'] ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        subtitle: Text(
          document['productBarcode'] ?? '',
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        leading: Image.network(
          document['productImageUrl'] == '' ? 'https://media.tarkett-image.com/large/TH_24567080_24594080_24596080_24601080_24563080_24565080_24588080_001.jpg': document['productImageUrl'],
          fit: BoxFit.cover,
        ),
        trailing: Text(
          document['productQuantity'] ?? '',
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProductDetails(
              productDetailIndex: document,
            );
          }));
        },
      ),
    );
  }
}
