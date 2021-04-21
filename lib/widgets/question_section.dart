import 'package:flutter/material.dart';

class QuestionSection extends StatelessWidget {
  final String questionText;

  QuestionSection(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(
        questionText,
        style: Theme.of(context).textTheme.headline5,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
    );
  }
}
