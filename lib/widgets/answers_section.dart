import 'package:flutter/material.dart';

import 'package:together_app/widgets/answer_button.dart';
import 'package:together_app/models/answer.dart';

class AnswersSection extends StatefulWidget {
  final List<Answer> answers;

  AnswersSection(this.answers);

  @override
  _AnswersSectionState createState() => _AnswersSectionState();
}

class _AnswersSectionState extends State<AnswersSection> {
  void selectAnswer(int index) {
    setState(() {
      widget.answers[index].isSelected = true;
      for (int i = 0; i < widget.answers.length; i++) {
        if (i != index) {
          widget.answers[i].isSelected = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, i) => AnswerButton(
          widget.answers[i],
          selectAnswer,
          i,
        ),
        itemCount: widget.answers.length,
      ),
    );
  }
}
