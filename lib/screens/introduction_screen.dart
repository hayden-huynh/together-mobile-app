import 'package:flutter/material.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/widgets/app_drawer.dart';
import 'package:together_app/utilities/location_request_alert.dart';
import 'package:together_app/utilities/local_notification.dart';

class IntroductionScreen extends StatefulWidget {
  static const routeName = '/introduction-screen';

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with WidgetsBindingObserver {
  bool _locationFunctionAlreadySetUp = false;

  @override
  void didChangeDependencies() async {
    if (!_locationFunctionAlreadySetUp) {
      await showLocationAlert(context);

      int hour = 8;
      for (int i = 0; i < 7; i++) {
        await LocalNotification.scheduleNotification(id: i, atHour: hour);
        hour += 2;
      }

      _locationFunctionAlreadySetUp = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Together',
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Pacifico',
              color: Colors.white,
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                'You will be asked a series of questions about what is happening to you right now. We are interested in your ‘raw’ response, so please do not spend too long answering each question.',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.left,
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
  }
}
