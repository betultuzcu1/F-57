import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:inventory_management_app/view/signupview.dart';
import 'package:inventory_management_app/view/splashview.dart';
import 'package:inventory_management_app/view/widgets/buttom.dart';
import 'package:inventory_management_app/view/widgets/text_form.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#4682b4'),
        title: Text(
          'Back',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      ),
      backgroundColor: HexColor('#4f94cd'),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "lib/assets/images/sepet.png",
                      color: Colors.white,
                      width: 80,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "|",
                      style: TextStyle(
                        fontSize: 120,
                        color: HexColor('#f2f2f2'),
                      ),
                    ),
                    SizedBox(width: 40),
                    Text(
                      "I",
                      style: GoogleFonts.forum(
                        fontSize: 80,
                        color: HexColor('#f2f2f2'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "InventoTrack",
                  style: GoogleFonts.forum(
                    color: HexColor('#f2f2f2'),
                    fontSize: 60,
                  ),
                ),
                SizedBox(height: 30),
                TextForm(
                  controller: emailController,
                  text: 'Email',
                  obscure: false,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                TextForm(
                  controller: passwordController,
                  text: 'Password',
                  obscure: true,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 20),
                MyButton(),
                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,

        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Dont't have an account? ",
              style: GoogleFonts.montserrat(

                fontSize: 18,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupView()),
                );
              },
              child:  Text(
                "Sign up ",
                style: GoogleFonts.montserrat(
                  color: HexColor('#f2f2f2'),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
