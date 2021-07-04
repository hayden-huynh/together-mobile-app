import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:together_app/models/authentication_exception.dart';
import 'package:together_app/App.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryTime;
  Timer _logoutTimer;

  Future<void> _authenticate(
    String email,
    String password,
    String endpoint, [
    bool rememberMe = false,
  ]) async {
    try {
      // Make POST Request
      final url = Uri.parse("http://10.0.2.2:3000$endpoint");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "email": email,
          "password": password,
          "rememberMe": rememberMe
        }),
      );

      // Extract response data and handle errors
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      if (responseBody["errors"] != null) {
        List<String> message = [];
        if (responseBody["errors"]["email"] != null &&
            responseBody["errors"]["password"] != null) {
          if (responseBody["errors"]["email"] != "") {
            message.add(responseBody["errors"]["email"]);
          }
          if (responseBody["errors"]["password"] != "") {
            message.add(responseBody["errors"]["password"]);
          }
        } else {
          message.add(responseBody["errors"]["message"]);
        }
        throw AuthenticationException(message);
      }
      _token = responseBody["token"];
      _userId = responseBody["userId"];
      _expiryTime = DateTime.now().add(
        Duration(seconds: responseBody["expiryTime"]),
      );
      notifyListeners();

      // Set up auto logout timer
      _autoLogout();

      // Save login data into device storage
      final sharedPrefs = await SharedPreferences.getInstance();
      final loginData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryTime": _expiryTime.toIso8601String()
      });
      sharedPrefs.setString("loginData", loginData);
    } catch (err) {
      throw err;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "/signup");
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    return _authenticate(email, password, "/login", rememberMe);
  }

  Future<void> autoLogin() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (!sharedPrefs.containsKey("loginData")) {
      return;
    }
    final loginData =
        json.decode(sharedPrefs.getString("loginData")) as Map<String, dynamic>;
    final expiryTime = DateTime.parse(loginData["expiryTime"]);
    if (expiryTime.isBefore(DateTime.now())) {
      return;
    }
    _token = loginData["token"];
    _userId = loginData["userId"];
    _expiryTime = expiryTime;
    notifyListeners();
    _autoLogout();
  }

  Future<void> logout() async {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    _token = null;
    _userId = null;
    _expiryTime = null;
    notifyListeners();
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove("loginData");
    Navigator.of(App.materialKey.currentContext).pop();
    Navigator.of(App.materialKey.currentContext).pushNamed("/");
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    final session = _expiryTime.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: session), () async {
      // await showDialog(
      //   context: App.materialKey.currentContext,
      //   builder: (ctx) => AlertDialog(
      //     title: Text("Session Expired", style: TextStyle(color: Colors.red)),
      //     content: Text("Please log in again."),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(ctx).pop();
      //         },
      //         child: Text("OK"),
      //       )
      //     ],
      //   ),
      // );
      // await logoutAndClearData();
      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.remove("loginData");
    });
  }

  bool isAuthenticated() {
    if (_token != null && _expiryTime != null) {
      if (_expiryTime.isAfter(DateTime.now())) {
        return true;
      }
    }
    return false;
  }
}
