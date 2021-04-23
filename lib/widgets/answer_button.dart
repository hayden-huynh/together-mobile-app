import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';

class AnswerButton extends StatelessWidget {
  final int answerIndex;
  final Answer answer;
  final Function selectAnswer;

  AnswerButton(
    this.answer,
    this.selectAnswer,
    this.answerIndex,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      // Align wrapping around ElevatedButton will make the button return to its default width
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: LayoutBuilder(
          builder: (ctx, constraints) => SizedBox(
            width: constraints.maxWidth * 0.7,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: answer.isSelected
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
                elevation: 5,
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  '${answer.answerText}',
                  style: TextStyle(fontSize: 20, ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              onPressed: () {
                selectAnswer(answerIndex);
              },
            ),
          ),
        ),
      ),
    );
  }
}
