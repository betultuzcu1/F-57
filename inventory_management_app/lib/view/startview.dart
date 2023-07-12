import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:inventory_management_app/view/splashview.dart';

class StartView extends StatelessWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () {
        Get.off(SplashView());
      },
    );

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
          ],
        ),
      ),
    );
  }
}
