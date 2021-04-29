import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';

class AnswerOpenEnded extends StatefulWidget {
  final Function inputAnswer;
  final Answer answer;

  AnswerOpenEnded(
    this.inputAnswer,
    this.answer,
  );

  @override
  _AnswerOpenEndedState createState() => _AnswerOpenEndedState();
}

class _AnswerOpenEndedState extends State<AnswerOpenEnded> {
  final _answerTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _answerTextController.text = widget.answer.answerText;

    return LayoutBuilder(
      builder: (ctx, constraints) => Container(
        width: constraints.maxWidth * 0.8,
        child: TextField(
          controller: _answerTextController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 10,
            ),
            border: const OutlineInputBorder(),
          ),
          style: TextStyle(
            fontSize: 20,
          ),
          onSubmitted: (_) {
            widget.inputAnswer(_answerTextController.text);
          },
        ),
      ),
    );
  }
}
