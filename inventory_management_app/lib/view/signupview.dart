import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:inventory_management_app/view/widgets/buttom.dart';
import 'package:inventory_management_app/view/widgets/text_form.dart';

class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                      width: 60,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "|",
                      style: TextStyle(
                        fontSize: 100,
                        color: HexColor('#f2f2f2'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "I",
                      style: GoogleFonts.forum(
                        fontSize: 70,
                        color: HexColor('#f2f2f2'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "InventoTrack",
                  style: GoogleFonts.forum(
                    color: HexColor('#f2f2f2'),
                    fontSize: 50,
                  ),
                ),
                SizedBox(height: 20),
                TextForm(
                  controller: nameController,
                  text: 'Name',
                  obscure: false,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 15),
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
                SizedBox(height: 15),
                TextForm(
                  controller: confirmPasswordController,
                  text: 'Confirm Password',
                  obscure: true,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 20),
                SignupButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
