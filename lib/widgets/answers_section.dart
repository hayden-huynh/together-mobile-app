import 'package:flutter/material.dart';

import 'package:together_app/model/answer.dart';

class AnswersSection extends StatelessWidget {
  final List<Answer> answers;

  AnswersSection(this.answers);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, i) => ElevatedButton(
          child: Text('${answers[i].answerText}'),
          onPressed: () {},
        ),
        itemCount: answers.length,
      ),
    );
  }
}
