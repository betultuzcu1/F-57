import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key? key,
    required this.isLoading,
    required this.submitProductInfo,
  }) : super(key: key);

  final bool isLoading;

  final void Function(
    String productBarcode,
    String productName,
    String productDescription,
    String productQuantity,
    String productPrice,
    String productLocation,
    String productImageUrl,
    String productQrCode,
    BuildContext ctx,
  ) submitProductInfo;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _barcodeResultController =
      TextEditingController();

  var _productBarcode = '';
  var _productName = '';
  var _productDescription = '';
  var _productQuantity = '';
  var _productPrice = '';
  var _productLocation = '';
  final TextEditingController _productImageUrl = TextEditingController();
  final _productImageUrlFocusNode = FocusNode();
  final TextEditingController _productQrCode = TextEditingController();

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void initState() {
    _productImageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void submitProductInfo() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitProductInfo(
        _productBarcode.trim(),
        _productName.trim(),
        _productDescription.trim(),
        _productQuantity.trim(),
        _productPrice.trim(),
        _productLocation.trim(),
        _productImageUrl.text.trim(),
        _productQrCode.text.trim(),
        context,
      );
    }
  }

  @override
  void dispose() {
    _barcodeResultController.dispose();
    _productImageUrlFocusNode.dispose();
    _productImageUrl.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_productImageUrlFocusNode.hasFocus) {
      if ((!_productImageUrl.text.startsWith('http') &&
              !_productImageUrl.text.startsWith('https')) ||
          (!_productImageUrl.text.endsWith('.png') &&
              !_productImageUrl.text.endsWith('.jpg') &&
              !_productImageUrl.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: QrImageView(
                data: _productQrCode.text,
                size: 150,
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _productQrCode,
                key: const ValueKey('QRCode'),
                cursorColor: Theme.of(context).colorScheme.primary,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Qr-code generator',
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.qr_code),
                        onPressed: () {
                          setState(() {
                            _productQrCode.text = getRandomString(15);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.done),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Qr-Code field shouldn\'t be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productQrCode.text = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                key: const ValueKey('barcode'),
                cursorColor: Theme.of(context).colorScheme.primary,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Barcode',
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.document_scanner_rounded),
                      onPressed: () {
                        setState(() {
                          productBarcodeScanner();
                        });
                      }),
                ),
                controller: _barcodeResultController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Quantity field shouldn\'t be empty.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productBarcode = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                key: const ValueKey('productName'),
                cursorColor: Theme.of(context).colorScheme.primary,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Product name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Product name field shouldn\'t be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productName = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                key: const ValueKey('description'),
                cursorColor: Theme.of(context).colorScheme.primary,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Product description field shouldn\'t be empty.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productDescription = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                key: const ValueKey('location'),
                cursorColor: Theme.of(context).colorScheme.primary,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Location',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Product location field shouldn\'t be empty.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productLocation = value!;
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(
                    top: 8,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: _productImageUrl.text.isEmpty
                      ? const Text('Enter a URL')
                      : FittedBox(
                          child: Image.network(
                            _productImageUrl.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: TextFormField(
                      controller: _productImageUrl,
                      key: const ValueKey('image'),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.primary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Image Url (Optional)',
                      ),
                      focusNode: _productImageUrlFocusNode,
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return null;
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _productImageUrl.text = value!;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    key: const ValueKey('quantity'),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Quantity',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Quantity field shouldn\'t be empty or set at 0.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productQuantity = value!;
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    key: const ValueKey('price'),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Price',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Price field shouldn\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productPrice = value!;
                    },
                  ),
                ),
              ],
            ),
            if (widget.isLoading) const CircularProgressIndicator(),
            if (!widget.isLoading)
              Padding(
                padding: const EdgeInsets.all(15),
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
                    onPressed: submitProductInfo,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future productBarcodeScanner() async {
    try {
      String productBarcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (!mounted) return;

      setState(() {
        _barcodeResultController.text = productBarcodeResult;
        // ignore: avoid_print
        print(productBarcodeResult);
      });
    } on PlatformException {
      _barcodeResultController.text = 'Failed to get platform version.';
    }
  }
}
