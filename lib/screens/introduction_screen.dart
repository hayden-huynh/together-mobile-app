import 'package:flutter/material.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/utilities/location_request_alert.dart';
import 'package:together_app/utilities/local_notification.dart';

class IntroductionScreen extends StatefulWidget {
  static const routeName = '/introduction-screen';

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with WidgetsBindingObserver {
  Future<void> _init(BuildContext context) async {
    await showLocationAlert(context);
    // Schedule the local notifications at hours 8, 10, 12, 14, 16, 18, 20
    // whenever the IntroductionScreen is rendered
    int hour = 8;
    for (int i = 0; i < 7; i++) {
      await LocalNotification.scheduleNotification(id: i, atHour: hour);
      hour += 2;
    }
  }

  // Extract the AppBar to avoid code duplication
  final AppBar _appBar = AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'CHECK-IN',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'Raleway',
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 5,
            bottom: 2,
          ),
          child: Image.asset(
            "assets/images/check-in-icon-rounded-corners.png",
            fit: BoxFit.cover,
            width: 33,
            height: 33,
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: _appBar,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'You will be asked a series of questions about what is happening to you right now. We are interested in your ‘raw’ response, so please do not spend too long answering each question.',
                      style: TextStyle(
                        height: 1.5,
                        fontSize:
                            Theme.of(context).textTheme.headline5.fontSize,
                      ),
                      textAlign: TextAlign.justify,
                      softWrap: true,
                    ),
                  ),
                  Align(
                    child: LayoutBuilder(
                      builder: (ctx, constraints) => Container(
                        width: constraints.maxWidth * 0.5,
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            elevation: 5,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pushReplacementNamed(
                                QuestionnaireEntryScreen.routeName);
                          },
                          child: Text(
                            'Start',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: _appBar,
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }
      },
    );
  }
}
