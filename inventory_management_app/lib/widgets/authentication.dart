import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.isLoading,
    required this.submitUserInfo,
  }) : super(key: key);

  final bool isLoading;

  final void Function(
    String email,
    String userName,
    String password,
    String phoneNumber,
    bool isLogin,
    BuildContext ctx,
  ) submitUserInfo;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _userPhoneNumber = '';

  void _submitUserInfo() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitUserInfo(
        _userEmail.trim(), //accept whitespace
        _userPassword.trim(),
        _userName.trim(),
        _userPhoneNumber.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaData = MediaQuery.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: deviceSize.height),
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: mediaData.size.width * 0.85,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Invento',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 30,
                  fontFamily: 'Lato',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Track',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              margin: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            key: const ValueKey('email'),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.blue.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.blue.shade900),
                              ),
                              labelText: 'E-mail address',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                              hintText: 'Enter your mail address',
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              var emailPattern =
                                  r"^([a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$)";
                              var result = RegExp(emailPattern);
                              if (value!.isEmpty) {
                                return 'Please enter a e-mail address';
                              }
                              if (!result.hasMatch(value.trim())) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userEmail = value!;
                            },
                          ),
                        ),
                        if (!_isLogin)
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              key: const ValueKey('username'),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.people,
                                  color: Colors.blue.shade700,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade900),
                                ),
                                labelText: 'Full name',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                                hintText: 'Enter your full name',
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userName = value!;
                              },
                            ),
                          ),
                        if (!_isLogin)
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              key: const ValueKey('phonenumber'),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone_rounded,
                                  color: Colors.blue.shade700,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade900),
                                ),
                                labelText: 'Phone number',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                                hintText: 'Enter your phone number',
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a phone number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userPhoneNumber = value!;
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            key: const ValueKey('password'),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.password_rounded,
                                color: Colors.blue.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.blue.shade900),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                              hintText: 'Enter your password',
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Must have at least 6 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPassword = value!;
                            },
                          ),
                        ),
                        if (widget.isLoading) const CircularProgressIndicator(),
                        if (!widget.isLoading)
                          ElevatedButton(
                            child: Text(_isLogin ? 'Login' : 'Signup'),
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
                            onPressed: _submitUserInfo,
                          ),
                        if (!widget.isLoading)
                          TextButton(
                            child: Text(
                              _isLogin
                                  ? 'Create new account'
                                  : 'I already have an account',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
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
