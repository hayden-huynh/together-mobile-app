import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/model/questionnaire_entry_provider.dart';

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
          appBarTheme: AppBarTheme(color: Colors.green[700]),
          canvasColor: Colors.green[50],
          primarySwatch: Colors.green,
          accentColor: Colors.blue,
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
