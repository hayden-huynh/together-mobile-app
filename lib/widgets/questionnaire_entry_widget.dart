import 'package:flutter/material.dart';

import 'package:together_app/widgets/question_section.dart';
import 'package:together_app/widgets/answers_section.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/widgets/questionnaire_entry_navigator.dart';

class QuestionnaireEntryWidget extends StatefulWidget {
  final List<QuestionnaireEntry> entries;

  QuestionnaireEntryWidget(this.entries);

  @override
  _QuestionnaireEntryWidgetState createState() =>
      _QuestionnaireEntryWidgetState();
}

class _QuestionnaireEntryWidgetState extends State<QuestionnaireEntryWidget> {
  var _currentEntryIndex = 0;

  void goToNextEntry() {
    setState(() {
      _currentEntryIndex++;
    });
  }

  void goToPreviousEntry() {
    setState(() {
      _currentEntryIndex--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuestionSection(widget.entries[_currentEntryIndex].questionText),
        AnswersSection(widget.entries[_currentEntryIndex].answers),
        QuestionnaireEntryNavigator(
          _currentEntryIndex,
          goToPreviousEntry,
          goToNextEntry,
          widget.entries.length,
        ),
      ],
    );
  }
}
