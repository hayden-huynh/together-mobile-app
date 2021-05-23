import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/utilities/location_request_alert.dart';

FlutterLocalNotificationsPlugin localNotiPlugin =
    FlutterLocalNotificationsPlugin();

class IntroductionScreen extends StatefulWidget {
  static const routeName = '/introduction-screen';

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  bool _locationFunctionAlreadySetUp = false;

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await localNotiPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
    // await localNotiPlugin.periodicallyShow(
    //   0,
    //   'Title',
    //   'Hello world, this is Together',
    //   RepeatInterval.everyMinute,
    //   platformChannelSpecifics,
    //   androidAllowWhileIdle: true,
    // );
  }

  @override
  void didChangeDependencies() async {
    if (!_locationFunctionAlreadySetUp) {
      await showLocationAlert(context);
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
                      // await _showNotification();
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
