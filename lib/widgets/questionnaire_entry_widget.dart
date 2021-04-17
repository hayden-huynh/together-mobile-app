import 'package:flutter/material.dart';

import 'package:together_app/widgets/question_section.dart';
import 'package:together_app/widgets/answers_section.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';

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
        Row(
          mainAxisAlignment: _currentEntryIndex == 0
              ? MainAxisAlignment.end
              : MainAxisAlignment.spaceBetween,
          children: [
            if (_currentEntryIndex != 0)
              IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: goToPreviousEntry,
              ),
            if (_currentEntryIndex != widget.entries.length - 1)
              IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.arrow_forward_ios_outlined),
                onPressed: goToNextEntry,
              ),
          ],
        )
      ],
    );
  }
}
