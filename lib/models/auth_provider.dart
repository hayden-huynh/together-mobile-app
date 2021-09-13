import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:together_app/models/authentication_exception.dart';
import 'package:together_app/models/connection_exception.dart';
import 'package:together_app/utilities/local_timezone.dart';
import 'package:together_app/utilities/check_internet_connection.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryTime;

  Future<void> login(String authenticationCode) async {
    // Check for Internet connection
    if (!(await isConnectedToInternet())) {
      throw ConnectionException(
        "An Internet connection is required to perform this action",
      );
    }

    try {
      // Make POST Request
      final url = Uri.parse("https://s4622569-together.uqcloud.net/login");
      final timezone = await FlutterNativeTimezone.getLocalTimezone();
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "code": authenticationCode,
          "timezone": timezone,
        }),
      );

      // Extract response data and handle error
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      if (responseBody["error"] != null) {
        throw AuthenticationException(responseBody["error"]);
      }
      _token = responseBody["token"];
      _userId = responseBody["userId"];
      _expiryTime = DateTime.now().add(
        Duration(seconds: responseBody["expiryTime"]),
      );

      // Add user's timezone to database
      await registerTimezone(_token);

      notifyListeners();

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
  }

  // Future<void> logout() async {
  //   _token = null;
  //   _userId = null;
  //   _expiryTime = null;
  //   notifyListeners();
  //   final sharedPrefs = await SharedPreferences.getInstance();
  //   sharedPrefs.remove("loginData");
  //   Navigator.of(App.materialKey.currentContext).pop();
  //   Navigator.of(App.materialKey.currentContext).pushNamed("/");
  // }

  bool isAuthenticated() {
    if (_token != null && _expiryTime != null) {
      if (_expiryTime.isAfter(DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  String get userId {
    return _userId;
  }

  String get token {
    return _token;
  }
}
