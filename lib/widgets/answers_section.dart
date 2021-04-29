import 'package:flutter/material.dart';

import 'package:together_app/models/questionnaire_entry_provider.dart'
    show QuestionType;
import 'package:together_app/widgets/answer_multiple_choices.dart';
import 'package:together_app/widgets/answer_open_ended.dart';

class AnswersSection extends StatefulWidget {
  final dynamic answers;
  final QuestionType type;

  AnswersSection(
    this.answers,
    this.type,
  );

  @override
  _AnswersSectionState createState() => _AnswersSectionState();
}

class _AnswersSectionState extends State<AnswersSection> {
  void _selectAnswer(int index) {
    setState(() {
      widget.answers[index].isSelected = true;
      for (int i = 0; i < widget.answers.length; i++) {
        if (i != index) {
          widget.answers[i].isSelected = false;
        }
      }
    });
  }

  void _inputAnswer(String answerText) {
    if (answerText == null) {
      return;
    }
    widget.answers.answerText = answerText;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: () {
        switch (widget.type) {
          case QuestionType.MultipleChoice:
            return AnswerMultipleChoices(
              widget.answers,
              _selectAnswer,
            );
          case QuestionType.OpenEnded:
            return AnswerOpenEnded(
              _inputAnswer,
              widget.answers,
            );
          default:
            return Center(
              child: Text('No answer available?'),
            );
        }
      }(),
    );
  }
}
