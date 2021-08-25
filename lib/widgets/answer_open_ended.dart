import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';

class AnswerOpenEnded extends StatefulWidget {
  final Answer answer;

  AnswerOpenEnded(
    this.answer,
  );

  @override
  _AnswerOpenEndedState createState() => _AnswerOpenEndedState();
}

class _AnswerOpenEndedState extends State<AnswerOpenEnded> {
  final _answerTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _answerTextController.text = widget.answer.usersAnswer;
    _answerTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: _answerTextController.text.length),
    );

    return LayoutBuilder(
      builder: (ctx, constraints) => Container(
        width: constraints.maxWidth * 0.8,
        child: TextField(
          controller: _answerTextController,
          textAlign: TextAlign.center,
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
            fontSize: 25,
          ),
          keyboardType: TextInputType.number,
          onSubmitted: (_) {
            if (_answerTextController.text == null) {
              return;
            }
            widget.answer.usersAnswer = _answerTextController.text;
          },
        ),
      ),
    );
  }
}
