import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/screens/introduction_screen.dart';
import 'package:together_app/models/location_provider.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
