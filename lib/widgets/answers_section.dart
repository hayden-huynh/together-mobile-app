import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/answer_group.dart';
import 'package:together_app/widgets/answer_button.dart';

class AnswersSection extends StatelessWidget {
  // final List<Answer> answers;

  // AnswersSection(this.answers);

  @override
  Widget build(BuildContext context) {
    final answers = Provider.of<AnswerGroup>(context);

    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, i) => AnswerButton(
          answers.answerGroup[i],
          answers.selectAnswer,
          i,
        ),
        itemCount: answers.answerGroup.length,
      ),
    );
  }
}
