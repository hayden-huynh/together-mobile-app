import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/answer.dart';
import 'package:together_app/widgets/answer_button.dart';

class AnswersSection extends StatelessWidget {
  final List<Answer> answers;

  AnswersSection(this.answers);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: answers[i],
          child: AnswerButton(answers, i),
        ),
        itemCount: answers.length,
      ),
    );
  }
}
