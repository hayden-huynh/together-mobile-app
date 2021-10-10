import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// Callback to perform some task(s) when the background messages from
/// Firebase Cloud Messaging arrive
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final now = DateTime.now();
  final sharedPrefs = await SharedPreferences.getInstance();
  await sharedPrefs.reload();

  if (sharedPrefs.getBool("Reminder${now.hour}30")) {
    await LocalNotification.showNotification(
      "Check-in: Missed Questionnaire",
      "Don't forget to complete the ${now.hour}:00 questionnaire!",
    );
  }
  await sharedPrefs.setBool(
      "Reminder${now.hour}30", true); // Reset to true for next reminder
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
  Future<void> _init(BuildContext context) async {
    await SharedPrefs.setUpBools();
    await Firebase.initializeApp();
    await LocalNotification.initializeLocalNotificationPlugin(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseMessaging.onBackgroundMessage(
              _firebaseMessagingBackgroundHandler);

          /**
           * Fetch the user's local timezone. Replace the '/' in the timezone 
           * string to '-' and subscribe to it as a topic to receive reminders
           * following this local timezone
           */
          FlutterNativeTimezone.getLocalTimezone().then((timezone) {
            final localTimezone = timezone.replaceFirst(RegExp(r'/'), "-");
            FirebaseMessaging.instance.subscribeToTopic(localTimezone);
          });

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => AuthProvider(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => QuestionnaireEntryProvider(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => LocationProvider(),
              ),
            ],
            child: Consumer<AuthProvider>(
              builder: (ctx, auth, _) => MaterialApp(
                title: 'Check-in',
                theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    color: Colors.green,
                    centerTitle: true,
                  ),
                  fontFamily: 'NotoSans',
                  canvasColor: Colors.green[50],
                  colorScheme: ColorScheme(
                    primary: Colors.green[400],
                    primaryVariant: Colors.green[400],
                    secondary: Colors.blue,
                    secondaryVariant: Colors.blue,
                    surface: Colors.transparent,
                    background: Colors.transparent,
                    error: Colors.transparent,
                    onPrimary: Colors.white,
                    onSecondary: Colors.white,
                    onSurface: Colors.transparent,
                    onBackground: Colors.transparent,
                    onError: Colors.transparent,
                    brightness: Brightness.light,
                  ),
                  textTheme: TextTheme(
                    headline5: TextStyle(
                      fontSize: 27,
                    ),
                  ),
                  dialogTheme: DialogTheme(
                    backgroundColor: Colors.green[100],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
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
          title: 'Check-In',
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
