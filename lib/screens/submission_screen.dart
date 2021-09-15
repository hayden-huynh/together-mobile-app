import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/models/auth_provider.dart';
import 'package:together_app/screens/introduction_screen.dart';
import 'package:together_app/utilities/local_database.dart';
import 'package:together_app/utilities/shared_prefs.dart';
import 'package:together_app/utilities/check_internet_connection.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final questionnaireProvider = Provider.of<QuestionnaireEntryProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submission",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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

                        // Timestamp to be saved if there is no Internet connection; otherwise, to be uploaded to the server database immediately
                        final currentTimestamp = DateTime.now().toString();

                        // Check Internet connection here
                        // If no connection, save current response and return to intro
                        if (!(await isConnectedToInternet())) {
                          // Transform current list of QuestionnaireEntry to a Map<String, String>. Example: {"Q0": "answer1", "Q2", "answer2", ...}
                          final data = Map.fromIterable(
                            questionnaireProvider.entries,
                            key: (e) {
                              final i =
                                  questionnaireProvider.entries.indexOf(e);
                              return "Q$i";
                            },
                            value: (e) {
                              return e.answer.usersAnswer is Map<int, String>
                                  ? e.answer.usersAnswer.values
                                      .toList()
                                      .join(",")
                                  : e.answer.usersAnswer.toString();
                            },
                          );
                          // Add the current timestamp to the map data above
                          data.addAll({"timestamp": currentTimestamp});

                          await LocalDatabase.insert(
                            "questionnaire",
                            "responses",
                            data,
                          );
                          await _showAlert(
                            "No Internet Connection",
                            Colors.red,
                            "Your current response will be saved and re-submitted in the next time you take the questionnaire",
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            IntroductionScreen.routeName,
                            (_) => false,
                          );
                          return;
                        }

                        // Retrieve location data stored locally
                        final locationData = await LocalDatabase.retrieve(
                          "location",
                          "location_data",
                        );
                        // Retrieve unsubmitted responses stored locally
                        final prevResponses = await LocalDatabase.retrieve(
                          "questionnaire",
                          "responses",
                        );

                        /**
                         * List of all pairs of responses and corresponding timestamps i.e. past
                         * saved responses plus the currently being-submitted response
                         * 
                         * [ // List of all responses
                         *   { // 1st pair of timestamp and response
                         *     "timestamp": ...,
                         *     "entries": [ // 1st response
                         *       {
                         *         question:...
                         *         answer:...
                         *       },
                         *       ...
                         *     ],
                         *   },
                         *   { // 2nd pair of timestamp and response
                         *     "timestamp": ...
                         *     "entries": [ // 2nd response
                         *       {
                         *         question:...
                         *         answer:...
                         *       },
                         *       ...
                         *     ]
                         *   }
                         * ]
                         */
                        List<Map<String, dynamic>> allResponses = [];

                        // Add all previously saved responses into the list of all responses
                        prevResponses.forEach((res) {
                          // The Map to hold pair of timestamp and response
                          Map<String, dynamic> responseAndTimestamp = {};
                          // The list of all Qx & answer pairs + timestamp key & value
                          final keyValuePairList = res.entries.toList();

                          // Transform the first 8 Qx & answer pairs to list of format:
                          // [{question:..., answer:...}, {question:..., answer:...}, ...]
                          final responseAsList = keyValuePairList
                              .sublist(0, 8)
                              .map((item) => {
                                    "question": questionnaireProvider
                                        .entries[int.parse(item.key[1])]
                                        .questionText,
                                    "answer": item.value,
                                  })
                              .toList();

                          // Extract timestamp value and assign into the Map package
                          responseAndTimestamp["timestamp"] =
                              keyValuePairList[8].value;
                          responseAndTimestamp["entries"] = responseAsList;

                          // Add pair of timestamp and response (a list) into the list of all pairs
                          allResponses.add(responseAndTimestamp);
                        });

                        // Add the current response being submitted to the list of all responses
                        // entries is just a list of all 8 QuestionnaireEntry
                        final currentResponseAsList =
                            questionnaireProvider.entries
                                .map((e) => {
                                      "question": e.questionText,
                                      "answer": e.answer.usersAnswer
                                              is Map<int, String>
                                          ? e.answer.usersAnswer.values
                                              .toList()
                                              .join(",")
                                          : e.answer.usersAnswer.toString()
                                    })
                                .toList();
                        allResponses.add({
                          "timestamp": currentTimestamp,
                          "entries": currentResponseAsList,
                        });

                        try {
                          final url =
                              Uri.parse("http://10.0.2.2:3000/save-response");
                          final response = await http.post(
                            url,
                            headers: {
                              "Content-Type": "application/json",
                              "Authorization": "Bearer ${authProvider.token}"
                            },
                            body: json.encode({
                              "userId": authProvider.userId,
                              "responses": allResponses,
                              "locations": locationData
                                  .map((loc) => {
                                        "timestamp": loc["timestamp"],
                                        "latitude": loc["latitude"],
                                        "longitude": loc["longitude"],
                                      })
                                  .toList()
                            }),
                          );

                          if (response.statusCode == 200) {
                            await LocalDatabase.clear(
                              "location",
                              "location_data",
                            );
                            await LocalDatabase.clear(
                              "questionnaire",
                              "responses",
                            );

                            setState(() {
                              _isLoading = false;
                            });

                            await SharedPrefs.tickOffFollowUpReminder();

                            await _showAlert(
                              json.decode(response.body)["success"],
                              Colors.green,
                              "Please remember to submit another questionnaire after two hours",
                            );
                          } else {
                            await _showAlert(
                              "Error",
                              Colors.red,
                              json.decode(response.body)["error"],
                            );
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            IntroductionScreen.routeName,
                            (_) => false,
                          );
                        } catch (err) {
                          await _showAlert(
                            "Something went wrong!",
                            Colors.red,
                            "Please try again later.",
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            IntroductionScreen.routeName,
                            (_) => false,
                          );
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
