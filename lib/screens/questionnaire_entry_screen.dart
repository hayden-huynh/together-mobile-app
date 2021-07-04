import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/widgets/question_section.dart';
import 'package:together_app/widgets/answers_section.dart';
import 'package:together_app/widgets/questionnaire_entry_navigator.dart';
import 'package:together_app/widgets/app_drawer.dart';
import 'package:together_app/models/auth_provider.dart';

class QuestionnaireEntryScreen extends StatefulWidget {
  static const routeName = '/questionnaire-entry-screen';

  @override
  _QuestionnaireEntryScreenState createState() =>
      _QuestionnaireEntryScreenState();
}

class _QuestionnaireEntryScreenState extends State<QuestionnaireEntryScreen>
    with WidgetsBindingObserver {
  var _isInit = true;
  var _entries;
  var _currentEntryIndex;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _currentEntryIndex = 0;
      _entries = Provider.of<QuestionnaireEntryProvider>(
        context,
        listen: false,
      ).entries;
      _entries.shuffle();
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
    final _mediaQuery = MediaQuery.of(context);

    final _appBar = AppBar(
      title: Text(
        'Questionnaire',
        style: TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Scaffold(
      appBar: _appBar,
      drawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: _mediaQuery.size.height -
                _mediaQuery.padding.top -
                _mediaQuery.padding.bottom -
                _appBar.preferredSize.height,
            child: Column(
              children: [
                QuestionSection(_entries[_currentEntryIndex].questionText,
                    _currentEntryIndex),
                AnswersSection(
                  _entries[_currentEntryIndex].type,
                  _entries[_currentEntryIndex].answer,
                  _goToNextEntry,
                  _goToPreviousEntry,
                  _entries.length,
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
      ),
    );
  }
}
