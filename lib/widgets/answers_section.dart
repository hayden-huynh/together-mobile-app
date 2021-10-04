import 'package:flutter/material.dart';

import 'package:together_app/models/questionnaire_entry_provider.dart'
    show QuestionType;
import 'package:together_app/widgets/answer_multiple_choices.dart';
import 'package:together_app/widgets/answer_open_ended.dart';
import 'package:together_app/widgets/answer_multiple_path.dart';
import 'package:together_app/models/answer.dart';

class AnswersSection extends StatefulWidget {
  final QuestionType type;
  final Answer answer;
  final Function goToNextQuestion;
  final Function goToPreviousQuestion;
  final int questionCount;
  final int currentEntryIndex;

  AnswersSection(
    this.type,
    this.answer,
    this.goToNextQuestion,
    this.goToPreviousQuestion,
    this.questionCount,
    this.currentEntryIndex,
  );

  @override
  _AnswersSectionState createState() => _AnswersSectionState();
}

class _AnswersSectionState extends State<AnswersSection> {
  /// Build and render the correct answer widget based on the answer type
  Widget _getAnswerWidget() {
    switch (widget.type) {
      case QuestionType.MultipleChoice:
        return AnswerMultipleChoices(
          Key(widget.currentEntryIndex.toString()),
          widget.answer,
        );
      case QuestionType.OpenEnded:
        return AnswerOpenEnded(
          widget.answer,
        );
      case QuestionType.MultiplePath:
        return AnswerMultiplePath(
          widget.answer,
        );
      default:
        return Center(
          child: Text('No answer available?'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: _getAnswerWidget(),
        ),
      ),
    );
  }
}
