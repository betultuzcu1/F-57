import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../service/firebase_service.dart';
import '../widgets/list_item.dart';

class OutOfStockItemList extends StatefulWidget {
  const OutOfStockItemList({Key? key}) : super(key: key);

  static const routeName = 'out-of-stock';

  @override
  State<OutOfStockItemList> createState() => _OutOfStockItemListState();
}

class _OutOfStockItemListState extends State<OutOfStockItemList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Out off stock list'),
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      body: StreamBuilder(
        stream: getOutOfStockList(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListItem(document: snapshot.data!.docs[index]);
                },
              );
            }
          }
        },
      ),
    );
  }
}
