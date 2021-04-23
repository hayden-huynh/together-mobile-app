import 'package:flutter/material.dart';

import 'package:together_app/widgets/answer_button.dart';
import 'package:together_app/models/answer.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart'
    show QuestionType;

class AnswersSection extends StatefulWidget {
  final List<Answer> answers;
  final QuestionType type;

  AnswersSection(
    this.answers,
    this.type,
  );

  @override
  _AnswersSectionState createState() => _AnswersSectionState();
}

class _AnswersSectionState extends State<AnswersSection> {
  void selectAnswer(int index) {
    setState(
      () {
        widget.answers[index].isSelected = true;
        for (int i = 0; i < widget.answers.length; i++) {
          if (i != index) {
            widget.answers[i].isSelected = false;
          }
        }
      },
    );
  }

  Widget getAnswerType(QuestionType type) {
    switch (widget.type) {
      case QuestionType.MultipleChoice:
        return ListView.builder(
          itemBuilder: (ctx, i) => AnswerButton(
            widget.answers[i],
            selectAnswer,
            i,
          ),
          itemCount: widget.answers.length,
        );
      case QuestionType.OpenEnded:
        return LayoutBuilder(
          builder: (ctx, constraints) => Container(
            width: constraints.maxWidth * 0.8,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                fontSize: 30,
                height: 3,
              ),
            ),
          ),
        );
      default:
        return Center(
          child: Text('No answer available?'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: getAnswerType(widget.type));
  }
}
