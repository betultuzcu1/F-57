import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_management_app/screens/low_stock_list.dart';
import 'package:inventory_management_app/widgets/search_bar.dart';
import '../screens/out_of_stock_list.dart';
import '../widgets/list_item.dart';
import '../screens/product_add_screen.dart';
import '../service/firebase_service.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  static const routeName = 'product-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 120,
        title: const Text(
          'All Product',
          style: TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        child: const Text('Out of Stock Items'),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          primary: Colors.lightBlue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(OutOfStockItemList.routeName);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        child: const Text('Low Stock Items'),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          primary: Colors.lightBlue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(LowStockItemList.routeName);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.lightBlue.shade900,
                size: 30,
              ),
              onPressed: () {
                showSearch(context: context, delegate: ProductSearchPage());
              }),
          IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.lightBlue.shade900,
              size: 30,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Short Item',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Largest no. of stock'),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Lowest no. of stock'),
                          onTap: () {},
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: getFirebaseDateStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null ) {
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _refreshProducts(),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      ListItem(document: snapshot.data!.docs[index]),
                ),
              );
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        height: 72,
        width: 72,
        child: FloatingActionButton(
          backgroundColor: Colors.lightBlue.shade900,
          child: const Icon(
            Icons.add,
            size: 36,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(ProductAddScreen.routeName);
          },
        ),
      ),
    );
  }

  Future<void> _refreshProducts() async {
     getFirebaseDateStream();
  }
}
