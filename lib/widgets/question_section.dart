import 'package:flutter/material.dart';

class QuestionSection extends StatelessWidget {
  final String questionText;
  final int questionIndex;

  QuestionSection(
    this.questionText,
    this.questionIndex,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            'Q: ${questionIndex + 1}/8',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            questionText,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
    );
  }
}
