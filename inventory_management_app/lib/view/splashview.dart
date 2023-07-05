import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_management_app/view/loginview.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#4f94cd'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset("lib/assets/images/sepet.png",
                            color: Colors.white, width: 80),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "|",
                          style: TextStyle(
                            fontSize: 120,
                            color: HexColor('#f2f2f2'),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          "I",
                          style: GoogleFonts.forum(
                            fontSize: 80,
                            color: HexColor('#f2f2f2'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "InventoTrack",
                      style: GoogleFonts.forum(
                        fontSize: 56,
                        color: HexColor('#f2f2f2'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            // Giriş Yap Card widget'ı
            Card(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlak hale getirir
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10), // InkWell'ın da köşeleri yuvarlak hale getirir
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                },
                child: ListTile(
                  title: Text(
                    'Giriş Yap',
                    style: GoogleFonts.montserrat(
                      color: HexColor('#36648b'),
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // Kayıt Ol Card widget'ı
            Card(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlak hale getirir
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10), // InkWell'ın da köşeleri yuvarlak hale getirir
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                },
                child: ListTile(
                  title: Text(
                    'Kayıt Ol',
                    style: GoogleFonts.montserrat(
                      color: HexColor('#36648b'),
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
