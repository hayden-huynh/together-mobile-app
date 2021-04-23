import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';

void main() {
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
            headline6: TextStyle(
              fontSize: 30,
            ),
            headline5: TextStyle(
              fontSize: 23,
            ),
          ),
        ),
        home: QuestionnaireEntryScreen(),
        routes: {
          QuestionnaireEntryScreen.routeName: (ctx) =>
              QuestionnaireEntryScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
