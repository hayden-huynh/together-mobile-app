import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Together",
          style: TextStyle(
            fontFamily: "Pacifico",
            color: Colors.green,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
