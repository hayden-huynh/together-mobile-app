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
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
    );
  }
}
