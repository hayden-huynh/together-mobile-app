import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/screens/introduction_screen.dart';
import 'package:together_app/models/location_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => QuestionnaireEntryProvider(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => LocationProvider(),
              ),
            ],
            child: MaterialApp(
              title: 'Together',
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  color: Colors.green,
                  centerTitle: true,
                ),
                fontFamily: 'NotoSans',
                canvasColor: Colors.green[50],
                primaryColor: Colors.green[400],
                accentColor: Colors.blue,
                textTheme: TextTheme(
                  headline5: TextStyle(
                    fontSize: 27,
                  ),
                ),
              ),
              home: IntroductionScreen(),
              routes: {
                IntroductionScreen.routeName: (ctx) => IntroductionScreen(),
                QuestionnaireEntryScreen.routeName: (ctx) =>
                    QuestionnaireEntryScreen(),
              },
              debugShowCheckedModeBanner: false,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
