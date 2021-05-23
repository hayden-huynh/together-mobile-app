import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/screens/introduction_screen.dart';
import 'package:together_app/models/location_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> _setLocalTimeZone() async {
  tz.initializeTimeZones();
  final String localZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(localZone));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _setLocalTimeZone();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();
  bool flutterLocalNotificationsInitialized = false;

  @override
  void didChangeDependencies() async {
    if (!flutterLocalNotificationsInitialized) {
      FlutterLocalNotificationsPlugin localNotiPlugin =
          FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('mipmap/ic_launcher');
      final IOSInitializationSettings iOSSettings = IOSInitializationSettings(
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
        showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('OK'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.of(context)
                      .pushReplacementNamed(IntroductionScreen.routeName);
                },
              )
            ],
          ),
        );
      });
      flutterLocalNotificationsInitialized = true;
      final InitializationSettings initSettings =
          InitializationSettings(android: androidSettings, iOS: iOSSettings);
      await localNotiPlugin.initialize(initSettings,
          onSelectNotification: (_) async {
        await Navigator.of(context)
            .pushReplacementNamed(IntroductionScreen.routeName);
      });
    }
    super.didChangeDependencies();
  }

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
