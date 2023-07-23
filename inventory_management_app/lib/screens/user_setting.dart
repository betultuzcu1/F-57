import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_management_app/service/firebase_service.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({
    Key? key,
    required this.email,
    required this.userName,
    required this.phoneNumber,
    required this.password,
  }) : super(key: key);
  final String email;
  final String userName;
  final String phoneNumber;
  final String password;

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  final _isLoading = false;
  final _form = GlobalKey<FormState>();
  final _userNameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  var _email = TextEditingController();
  var _userName = TextEditingController();
  var _phoneNumber = TextEditingController();
  var _password = TextEditingController();

  bool _obscureText = true;

  @override
  void initState() {
    _email = TextEditingController(text: widget.email);
    _userName = TextEditingController(text: widget.userName);
    _phoneNumber = TextEditingController(text: widget.phoneNumber);
    _password = TextEditingController(text: widget.password);
    super.initState();
  }

  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    final cred =
        EmailAuthProvider.credential(email: email!, password: widget.password);

    try {
      user?.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPassword).then((_) {
          print("Successfully changed password");
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  void changeEmail(String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;
    final cred =
    EmailAuthProvider.credential(email: widget.email, password: widget.password);

    try {
      user?.reauthenticateWithCredential(cred).then((value) {
        user.updateEmail(newEmail).then((_) {
          print("Successfully changed email");
        }).catchError((error) {
          print("Email can't be changed" + error.toString());
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-email') {
        print('Wrong email provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit user info'),
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
                          'Email',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 55, top: 15, bottom: 8),
                          child: TextFormField(
                            controller: _email,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'email',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: _email.clear,
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_userNameFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email.text = value!;
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
                          'User name',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.69,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 40, top: 15, bottom: 8),
                          child: TextFormField(
                            controller: _userName,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'User name',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: _userName.clear,
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _userNameFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_phoneNumberFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a user name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userName.text = value!;
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
                          'Phone number',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 34, top: 15, bottom: 8),
                          child: TextFormField(
                            controller: _phoneNumber,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: _phoneNumber.clear,
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                            focusNode: _phoneNumberFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a phone number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phoneNumber.text = value!;
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
                          'Password',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 90, top: 15, bottom: 8),
                          child: TextFormField(
                            obscureText: _obscureText,
                            controller: _password,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                  icon: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: _togglePasswordStatus),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            focusNode: _passwordFocusNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password.text = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
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
                                updateUserInfo(
                                  _email.text,
                                  _userName.text,
                                  _phoneNumber.text,
                                  _password.text,
                                );
                                changePassword(_password.text);
                                changeEmail(_email.text);
                              },
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
