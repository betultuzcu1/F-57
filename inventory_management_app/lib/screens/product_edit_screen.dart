import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/firebase_service.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    required this.getProduct,
    Key? key,
  }) : super(key: key);

  final DocumentSnapshot getProduct;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _isLoading = false;
  final _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();

  var productBarcode = TextEditingController();
  var productName = TextEditingController();
  var productDescription = TextEditingController();
  var productQuantity = TextEditingController();
  var productPrice = TextEditingController();
  var productLocation = TextEditingController();

  @override
  void initState() {
    productBarcode =
        TextEditingController(text: widget.getProduct['productBarcode']);
    productName = TextEditingController(text: widget.getProduct['productName']);
    productDescription =
        TextEditingController(text: widget.getProduct['productDescription']);
    productQuantity =
        TextEditingController(text: widget.getProduct['productQuantity']);
    productPrice =
        TextEditingController(text: widget.getProduct['productPrice']);
    productLocation = TextEditingController(text: widget.getProduct['productLocation']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 9),
                        child: Text(
                          'Barcode',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.745,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 55, top: 15, bottom: 8),
                          child: TextFormField(
                            controller: productBarcode,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Input item barcode',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: productBarcode.clear,
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_nameFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productBarcode.text = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 9),
                        child: Text(
                          'Item name',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.69,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 40, top: 15, bottom: 8),
                          child: TextFormField(
                            controller: productName,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Input item name',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: productName.clear,
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _nameFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_quantityFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productName.text = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 9),
                        child: Text(
                          'Description',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.675,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 34, top: 15, bottom: 8),
                          child: TextFormField(
                            controller: productDescription,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Input item description',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: productDescription.clear,
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                            focusNode: _descriptionFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productDescription.text = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 9),
                        child: Text(
                          'Price',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.82,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 90, top: 15, bottom: 8),
                          child: TextFormField(
                            controller: productPrice,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Input price',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: productPrice.clear,
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_locationFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productPrice.text = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 9),
                        child: Text(
                          'Location',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.73,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 55, top: 15, bottom: 8),
                          child: TextFormField(
                            controller: productLocation,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Item location',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: productLocation.clear,
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _locationFocusNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productLocation.text = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isLoading) const CircularProgressIndicator(),
                  if (!_isLoading)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                                child: const Text('SAVE'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  primary: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  updateItem(
                                    productBarcode.text,
                                    productName.text,
                                    productPrice.text,
                                    productDescription.text,
                                    widget.getProduct,
                                  );
                                } //saveEditProduct,
                                ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
