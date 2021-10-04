import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/widgets/question_section.dart';
import 'package:together_app/widgets/answers_section.dart';
import 'package:together_app/widgets/questionnaire_entry_navigator.dart';

class QuestionnaireEntryScreen extends StatefulWidget {
  static const routeName = '/questionnaire-entry-screen';

  @override
  _QuestionnaireEntryScreenState createState() =>
      _QuestionnaireEntryScreenState();
}

class _QuestionnaireEntryScreenState extends State<QuestionnaireEntryScreen>
    with WidgetsBindingObserver {
  bool _isInit = true;
  List<QuestionnaireEntry> _entries;
  int _currentEntryIndex;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _currentEntryIndex = 0;
      _entries = Provider.of<QuestionnaireEntryProvider>(
        context,
        listen: false,
      ).entries;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _goToNextEntry() {
    setState(() {
      if (_currentEntryIndex < _entries.length - 1) {
        _currentEntryIndex++;
      }
    });
  }

  void _goToPreviousEntry() {
    setState(() {
      if (_currentEntryIndex > 0) {
        _currentEntryIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: SimpleGestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalSwipe: (direction) {
            if (direction == SwipeDirection.left) {
              _goToNextEntry();
            } else if (direction == SwipeDirection.right) {
              _goToPreviousEntry();
            }
          },
          swipeConfig: SimpleSwipeConfig(
            horizontalThreshold: 40,
            swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
          ),
          child: Column(
            children: [
              QuestionSection(
                _entries[_currentEntryIndex].questionText,
                _currentEntryIndex,
              ),
              AnswersSection(
                _entries[_currentEntryIndex].type,
                _entries[_currentEntryIndex].answer,
                _goToNextEntry,
                _goToPreviousEntry,
                _entries.length,
                _currentEntryIndex,
              ),
              QuestionnaireEntryNavigator(
                _currentEntryIndex,
                _goToPreviousEntry,
                _goToNextEntry,
                _entries.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
