import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/screens/questionnaire_entry_screen.dart';
import 'package:together_app/models/location_provider.dart';
import 'package:together_app/utilities/location_request_alert.dart';

class IntroductionScreen extends StatefulWidget {
  static const routeName = '/introduction-screen';

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  bool _locationFunctionAlreadySetUp = false;

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
        title: Text(
          'Together',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'Pacifico',
            color: Colors.white,
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
            Container(
              margin: const EdgeInsets.all(20),
              child: Consumer<LocationProvider>(
                builder: (_, locationProvider, __) =>
                    locationProvider.location == null
                        ? Text(
                            'Nothing',
                            textAlign: TextAlign.center,
                            softWrap: true,
                          )
                        : Text(
                            'Addr: ${locationProvider.locationAddress} - Name: ${locationProvider.locationName}',
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
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
                    onPressed: () {
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
