import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/product_edit_screen.dart';
import 'package:inventory_management_app/service/firebase_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/utils.dart';

enum PopUpMenu {
  delete,
  edit,
  download,
}

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.productDetailIndex,
  }) : super(key: key);

  static const routeName = 'detail-product';
  final DocumentSnapshot productDetailIndex;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int totalQuantityStockIn = 0;
  int totalQuantityStockOut = 0;
  int totalStockIn = 0;
  int totalStockOut = 0;

  final stockIn = TextEditingController();
  final stockOut = TextEditingController();

  GlobalKey? globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser;
    final accessCurrentDoc = FirebaseFirestore.instance
        .collection('products')
        .doc(userId!.uid)
        .collection('user_product_list')
        .doc(widget.productDetailIndex['productQrCode']);

    DateFormat dateFormatDoc = DateFormat("dd-MM-yyyy HH:mm:ss");
    DateTime dateTimeDoc = DateTime.now();

    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    DateTime dateTime = DateTime.now();

    final historyStockIn = FirebaseFirestore.instance
        .collection('history')
        .doc(userId.uid)
        .collection('history_stock_in')
        .doc(dateFormatDoc.format(dateTimeDoc));

    final historyStockOut = FirebaseFirestore.instance
        .collection('history')
        .doc(userId.uid)
        .collection('history_stock_out')
        .doc(dateFormatDoc.format(dateTimeDoc));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade900,
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(context),
        ),
        title: const Text('Details'),
        actions: [
          PopupMenuButton(
            onSelected: (PopUpMenu selectedValue) async {
              setState(
                () {
                  if (selectedValue == PopUpMenu.delete) {
                    deleteProduct(widget.productDetailIndex['productBarcode']);
                    Navigator.of(context).pop();
                  }
                  if (selectedValue == PopUpMenu.edit) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(
                            getProduct: widget.productDetailIndex),
                      ),
                    );
                  }
                  if (selectedValue == PopUpMenu.download) {
                    saveQrCode(globalKey);
                  }
                },
              );
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
                value: PopUpMenu.edit,
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
                value: PopUpMenu.delete,
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Download Qr-Code'),
                ),
                value: PopUpMenu.download,
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: RepaintBoundary(
                    key: globalKey,
                    child: QrImageView(
                      data: widget.productDetailIndex['productQrCode'],
                      size: 180,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      '${widget.productDetailIndex['productBarcode']}',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    leading: const Text(
                      'Barcode',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      '${widget.productDetailIndex['productName']}',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    leading: const Text(
                      'Item name',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      '${widget.productDetailIndex['productDescription']}',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    leading: const Text(
                      'Description',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      '${widget.productDetailIndex['productQuantity']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                          backgroundColor: Colors.lightBlue.shade900),
                      textAlign: TextAlign.end,
                    ),
                    leading: const Text(
                      'Quantity',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      '${widget.productDetailIndex['productPrice']}',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    leading: const Text(
                      'Price',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      '${widget.productDetailIndex['productLocation']}',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    leading: const Text(
                      'Location',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: Card(
                    color: Colors.blue.shade100,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            DateFormat('d, EEEE').format(DateTime.now()),
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Stock In'),
                                Text('${widget.productDetailIndex['stockIn']}'),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Stock Out'),
                                Text(
                                    '${widget.productDetailIndex['stockOut']}'),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              leading: Text(
                '${widget.productDetailIndex['productQuantity']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.white,
                  backgroundColor: Colors.lightBlue.shade900,
                ),
                textAlign: TextAlign.start,
              ),
              title: const Text(
                'Total Quantity',
                style: TextStyle(fontSize: 18),
              ),
              trailing: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  child: const Text('Stock In/Out'),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    primary: Colors.lightBlue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.21,
                          child: GestureDetector(
                            onTap: () {},
                            behavior: HitTestBehavior.opaque,
                            child: ListView(
                              children: [
                                const Divider(),
                                ListTile(
                                  title: const Text('Stock in'),
                                  onTap: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          title: const Text(
                                            'Stock in quantity',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(
                                                    'Current Stock: ${widget.productDetailIndex['productQuantity']}',
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: stockIn,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.blue.shade700),
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Enter the quantity to be changed.';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    stockIn.text = value!;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                totalQuantityStockIn = int.parse(
                                                        widget.productDetailIndex[
                                                            'productQuantity']) +
                                                    int.parse(stockIn.text);
                                                totalStockIn +=
                                                    int.parse(stockIn.text);
                                                setState(
                                                  () {
                                                    accessCurrentDoc.update(
                                                      {
                                                        'productQuantity':
                                                            totalQuantityStockIn
                                                                .toString(),
                                                        'stockIn': int.parse(widget
                                                                .productDetailIndex[
                                                                    'stockIn']
                                                                .toString()) +
                                                            totalStockIn,
                                                      },
                                                    ).then((value) =>
                                                        historyStockIn.set(
                                                          {
                                                            'dateTime':
                                                                dateFormat.format(
                                                                    dateTime),
                                                            'productName': widget
                                                                    .productDetailIndex[
                                                                'productName'],
                                                            'productQuantity': widget
                                                                    .productDetailIndex[
                                                                'productQuantity'],
                                                            'stockIn':
                                                                stockIn.text,
                                                          },
                                                        ));
                                                  },
                                                );
                                              },
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  title: const Text('Stock out'),
                                  onTap: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          title: const Text(
                                            'Stock out quantity',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  'Current Stock: ${widget.productDetailIndex['productQuantity']}',
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              TextFormField(
                                                controller: stockOut,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.blue.shade700),
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter the quantity to be changed.';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  stockOut.text = value!;
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                totalQuantityStockOut = int.parse(
                                                        widget.productDetailIndex[
                                                            'productQuantity']) -
                                                    int.parse(stockOut.text);
                                                totalStockOut +=
                                                    int.parse(stockOut.text);
                                                setState(
                                                  () {
                                                    accessCurrentDoc.update(
                                                      {
                                                        'productQuantity':
                                                            totalQuantityStockOut
                                                                .toString(),
                                                        'stockOut': int.parse(widget
                                                                .productDetailIndex[
                                                                    'stockOut']
                                                                .toString()) +
                                                            totalStockOut,
                                                      },
                                                    ).then((value) =>
                                                        historyStockOut.set(
                                                          {
                                                            'dateTime':
                                                                dateFormat.format(
                                                                    dateTime),
                                                            'productName': widget
                                                                    .productDetailIndex[
                                                                'productName'],
                                                            'productQuantity': widget
                                                                    .productDetailIndex[
                                                                'productQuantity'],
                                                            'stockOut':
                                                                stockOut.text,
                                                          },
                                                        ));
                                                  },
                                                );
                                              },
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
