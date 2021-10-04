import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/auth_provider.dart';
import 'package:together_app/models/authentication_exception.dart';
import 'package:together_app/models/connection_exception.dart';

import 'package:together_app/utilities/local_notification.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    // Schedule the local notifications at hours 8, 10, 12, 14, 16, 18, 20
    // whenever the AuthScreen is rendered
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
          // This container is the entire background of the screen
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
          // Scrollable container that contains a Column of the app title + logo above
          // and the AuthCard below
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
                  // The app title "Check-In" and the logo arranged
                  // next to each other on a Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          // horizontal: 94.0,
                        ),
                        child: Text(
                          'CHECK-IN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: 'Raleway',
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
                      Container(
                        margin: EdgeInsets.only(
                          left: 5,
                          bottom: 20,
                        ),
                        child: Image.asset(
                          "assets/images/check-in-icon-rounded-corners.png",
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  // The AuthCard widget below the Row of app title + logo
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

/// The AuthCard widget contains the form for users to input their codes and sign in
class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String authenticationCode;
  var _isLoading = false;

  /// Show a dialog whenever there is Connection error or Authentication error
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: TextStyle(
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Validate and save the current authentication code input.
  /// Then attempt to sign the user in
  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(authenticationCode);
    } on ConnectionException catch (err) {
      _showErrorDialog(
        "Connection Error",
        err.message,
      );
    } on AuthenticationException catch (err) {
      _showErrorDialog(
        "Authentication Error",
        err.message,
      );
    } catch (err) {
      // Handles errors of all types
      _showErrorDialog(
        "Something went wrong!",
        "Please try again later.",
      );
    }
    setState(() {
      _isLoading = false;
    });
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
        height: 200,
        // constraints: BoxConstraints(
        //   minHeight: 190,
        // ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  "Please sign in with the Authentication Code provided to you",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 80,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      errorMaxLines: 1,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please provide an Authentication Code";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      authenticationCode = value;
                    },
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text("SIGN IN"),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
