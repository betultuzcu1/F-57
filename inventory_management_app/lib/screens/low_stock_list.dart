import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../service/firebase_service.dart';
import '../widgets/list_item.dart';

class LowStockItemList extends StatefulWidget {
  const LowStockItemList({Key? key}) : super(key: key);

  static const routeName = 'low-stock';

  @override
  State<LowStockItemList> createState() => _LowStockItemListState();
}

class _LowStockItemListState extends State<LowStockItemList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Low stock list'),
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      body: StreamBuilder(
        stream: getLowStockList(),
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
