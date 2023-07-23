import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_management_app/screens/user_setting.dart';

import '../widgets/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _email = '';
  String _userName = '';
  String _phoneNumber = '';
  String _password = '';

  Future getUserData() async {
    final userId = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId!.uid)
        .snapshots()
        .forEach((userData) {
          if(mounted) {
            setState(() {
              _email = userData.data()!['email'].toString();
              _userName = userData.data()!['userName'].toString();
              _phoneNumber = userData.data()!['phoneNumber'].toString();
              _password = userData.data()!['password'].toString();
            });
          }
    });
  }
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        title: const Text(
          'Setting',
          style: TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            heightFactor: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .27,
                color: Colors.lightBlue.shade900,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                children: [
                                  Text(
                                    _userName,
                                    style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        color: LightColor.whiteBlue),
                                  ),
                                  const Text(
                                    'Admin',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  child: Icon(
                                    FontAwesomeIcons.userLarge,
                                    size: 45,
                                  ),
                                  radius: 30,
                                  foregroundColor: LightColor.lightGrey,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Signed in: $_email',
                                style: GoogleFonts.mulish(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: LightColor.whiteBlue),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Registered phone number: $_phoneNumber',
                                style: GoogleFonts.mulish(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: LightColor.whiteBlue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          ListTile(
            title: const Text(
              'User Setting',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return UserSetting(
                  email: _email,
                  userName: _userName,
                  phoneNumber: _phoneNumber,
                  password: _password,
                );
              }));
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text(
              'Sign out',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87,
              ),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}
