import 'package:flutter/material.dart';

import 'package:together_app/widgets/question_section.dart';
import 'package:together_app/widgets/answers_section.dart';
import 'package:together_app/widgets/questionnaire_entry_navigator.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';

class QuestionnaireEntryWidget extends StatefulWidget {
  final List<QuestionnaireEntry> entries;
  final appBarHeight;
  final paddingTop;
  final paddingBottom;

  QuestionnaireEntryWidget(
    this.entries,
    this.appBarHeight,
    this.paddingTop,
    this.paddingBottom,
  );

  @override
  _QuestionnaireEntryWidgetState createState() =>
      _QuestionnaireEntryWidgetState();
}

class _QuestionnaireEntryWidgetState extends State<QuestionnaireEntryWidget> {
  var _currentEntryIndex = 0;

  void _goToNextEntry() {
    setState(() {
      if (_currentEntryIndex < widget.entries.length - 1) {
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

    return SingleChildScrollView(
      child: Container(
        height: _mediaQuery.size.height -
            widget.paddingTop -
            widget.paddingBottom -
            widget.appBarHeight,
        child: Column(
          children: [
            QuestionSection(widget.entries[_currentEntryIndex].questionText,
                _currentEntryIndex),
            AnswersSection(
              widget.entries[_currentEntryIndex].type,
              widget.entries[_currentEntryIndex].answer,
              _goToNextEntry,
              _goToPreviousEntry,
              widget.entries.length,
            ),
            QuestionnaireEntryNavigator(
              _currentEntryIndex,
              _goToPreviousEntry,
              _goToNextEntry,
              widget.entries.length,
            ),
          ],
        ),
      ),
    );
  }
}
