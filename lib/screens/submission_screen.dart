import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/models/auth_provider.dart';
import 'package:together_app/screens/introduction_screen.dart';
import 'package:together_app/utilities/local_database.dart';
import 'package:together_app/utilities/shared_prefs.dart';

class SubmissionScreen extends StatefulWidget {
  static const routeName = "/submission-screen";

  @override
  _SubmissionScreenState createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  var _isLoading = false;

  Future<void> _showAlert(
    String title,
    Color titleColor,
    String content,
  ) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context, listen: false);
    final questionnaireProvider = Provider.of<QuestionnaireEntryProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submission",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_isLoading)
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          else
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
          Container(
            margin: EdgeInsets.only(
              bottom: 15,
              left: 8,
              right: 8,
            ),
            child: Text(
              "Are you sure that you want to submit your current questionnaire responses?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                child: Text(
                  "Go Back",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final locationData = await LocalDatabase.retrieve(
                          "location",
                          "location_data",
                        );

                        try {
                          final url =
                              Uri.parse("https://s4622569-together.uqcloud.net/save-response");
                          final response = await http.post(
                            url,
                            headers: {
                              "Content-Type": "application/json",
                            },
                            body: json.encode({
                              "token": authProvider.token,
                              "userId": authProvider.userId,
                              "entries": questionnaireProvider.entries
                                  .map((e) => {
                                        "question": e.questionText,
                                        "answer":
                                            e.answer.usersAnswer.toString()
                                      })
                                  .toList(),
                              "locations": locationData
                                  .map((loc) => {
                                        "timestamp": loc["timestamp"],
                                        "latitude": loc["latitude"],
                                        "longitude": loc["longitude"],
                                        "address": loc["address"],
                                        "placeName": loc["name"]
                                      })
                                  .toList()
                            }),
                          );

                          if (response.statusCode == 200) {
                            await LocalDatabase.clear(
                              "location",
                              "location_data",
                            );

                            setState(() {
                              _isLoading = false;
                            });

                            SharedPrefs.tickOffFollowUpReminder();

                            await _showAlert(
                              json.decode(response.body)["success"],
                              Colors.green,
                              "Please remember to submit another questionnaire after two hours",
                            );
                            Navigator.of(context).pushReplacementNamed(
                                IntroductionScreen.routeName);
                          } else {
                            await _showAlert(
                              "Error",
                              Colors.red,
                              json.decode(response.body)["error"],
                            );
                            authProvider.logout();
                          }
                        } catch (err) {
                          await _showAlert(
                            "Something went wrong!",
                            Colors.red,
                            "Please log in then try again",
                          );
                          authProvider.logout();
                        }
                      },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
