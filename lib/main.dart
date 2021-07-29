import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:together_app/App.dart';
import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/screens/introduction_screen.dart';
import 'package:together_app/screens/splash_screen.dart';
import 'package:together_app/screens/auth_screen.dart';
import 'package:together_app/screens/submission_screen.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/models/location_provider.dart';
import 'package:together_app/models/auth_provider.dart';
import 'package:together_app/utilities/local_notification.dart';
import 'package:together_app/utilities/shared_prefs.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final now = DateTime.now();
  final sharedPrefs = await SharedPreferences.getInstance();
  if (sharedPrefs.getBool("Reminder${now.hour}")) {
    await LocalNotification.showNotification(
      "Together: Missed Questionnaire",
      "Don't forget to complete the ${now.hour-1}:00 questionnaire!",
    );
  }
  SharedPrefs.instance.setBool("Reminder${now.hour}", true);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.setLocalTimeZone();
  await SharedPrefs.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();
  bool _flutterLocalNotificationsInitialized = false;

  @override
  void didChangeDependencies() async {
    if (!_flutterLocalNotificationsInitialized) {
      await LocalNotification.initializeLocalNotificationPlugin(context);
      SharedPrefs.setUpBools();
      _flutterLocalNotificationsInitialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseMessaging.onBackgroundMessage(
              _firebaseMessagingBackgroundHandler);
          FlutterNativeTimezone.getLocalTimezone().then((timezone) {
            final localTimezone = timezone.replaceFirst(RegExp(r'/'), "-");
            FirebaseMessaging.instance.subscribeToTopic(localTimezone);
          });

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => Auth(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => QuestionnaireEntryProvider(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => LocationProvider(),
              ),
            ],
            child: Consumer<Auth>(
              builder: (ctx, auth, _) => MaterialApp(
                navigatorKey: App.materialKey,
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
                home: auth.isAuthenticated()
                    ? IntroductionScreen()
                    : FutureBuilder(
                        future: auth.autoLogin(),
                        builder: (context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen(),
                      ),
                routes: {
                  IntroductionScreen.routeName: (ctx) => IntroductionScreen(),
                  QuestionnaireEntryScreen.routeName: (ctx) =>
                      QuestionnaireEntryScreen(),
                  SubmissionScreen.routeName: (ctx) => SubmissionScreen(),
                },
                debugShowCheckedModeBanner: false,
              ),
            ),
          );
        }
        return MaterialApp(
          title: 'Together',
          theme: ThemeData(
            canvasColor: Colors.green[50],
          ),
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
