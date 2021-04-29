import 'package:flutter/material.dart';

import 'package:together_app/widgets/answer_button.dart';
import 'package:together_app/models/answer.dart';

class AnswerMultipleChoices extends StatelessWidget {
  final List<Answer> answers;
  final Function selectAnswer;
  final int answerCount;

  AnswerMultipleChoices(
    this.answers,
    this.selectAnswer,
    this.answerCount,
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) => AnswerButton(
        answers[i],
        selectAnswer,
        i,
      ),
      itemCount: answers.length,
    );
  }
}
