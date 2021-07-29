/// Inspired by the auth_screen.dart file from section 10 - Sending Http Requests in the course
/// Flutter & Dart - The Complete Guide [2021 Edition] by instructor Maximillian Schwarzmuller

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/auth_provider.dart';
import 'package:together_app/models/authentication_exception.dart';

import 'package:together_app/utilities/local_notification.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    () async {
      int hour = 8;
      for (int i = 0; i < 7; i++) {
        await LocalNotification.scheduleNotification(id: i, atHour: hour);
        hour += 2;
      }
    }();

    final _mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.green,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: _mediaQuery.size.height -
                  _mediaQuery.padding.top -
                  _mediaQuery.padding.bottom,
              width: _mediaQuery.size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 94.0,
                    ),
                    child: Text(
                      'Together',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.normal,
                        shadows: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                  ),
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Signup;
  bool _rememberMe = false;
  Map<String, String> _credentials = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String title, List<String> message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: message.map((e) => Text("\u2022 $e")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _credentials["email"],
          _credentials["password"],
          _rememberMe,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _credentials["email"],
          _credentials["password"],
        );
      }
    } on AuthenticationException catch (err) {
      _showErrorDialog(
        "Authentication Error",
        err.message,
      );
    } catch (err) {
      // Handles errors of all types
      _showErrorDialog(
        "An error occured",
        ["Something went wrong!"],
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 300,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 300,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.green,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (_authMode == AuthMode.Login) {
                      return null;
                    }
                    if (value.isEmpty) {
                      return "Email address is missing";
                    }
                    final re = RegExp(
                      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                      caseSensitive: true,
                    );
                    if (!re.hasMatch(value)) {
                      return 'Email address is invalid';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _credentials['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.green,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    errorMaxLines: 2,
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (_authMode == AuthMode.Login) {
                      return null;
                    }
                    if (value.isEmpty) {
                      return 'Password is missing';
                    }
                    if (value.length < 6) {
                      return "Password length must be at least 6 characters";
                    }
                    final re = RegExp(
                        r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d#?!@$%^&*-]{6,}$');
                    if (!re.hasMatch(value)) {
                      return "Password must contain at least one number and one uppercase character";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _credentials['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        color: Colors.green,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(
                      _authMode == AuthMode.Login ? 'LOG IN' : 'SIGN UP',
                    ),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                if (_authMode == AuthMode.Login)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              activeColor: Colors.green,
                              value: _rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  _rememberMe = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Remember me")
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _authMode == AuthMode.Signup
                      ? [
                          Text("Already have an account?"),
                          TextButton(
                            child: Text("Log In"),
                            onPressed: _switchAuthMode,
                            style: TextButton.styleFrom(primary: Colors.green),
                          )
                        ]
                      : [
                          Text("Not having an account yet?"),
                          TextButton(
                            child: Text("Sign Up"),
                            onPressed: _switchAuthMode,
                            style: TextButton.styleFrom(primary: Colors.green),
                          )
                        ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
