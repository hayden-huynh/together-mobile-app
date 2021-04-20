import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/answer.dart';

class AnswerButton extends StatelessWidget {
  // final List<Answer> answersGroup;
  // final Answer answer;
  
  final int answerIndex;
  final Answer answer;
  final Function selectAnswer;

  AnswerButton(this.answer, this.selectAnswer, this.answerIndex);

  @override
  Widget build(BuildContext context) {
    // final answer = Provider.of<Answer>(context);

    return Align(
      // Align wrapping around ElevatedButton will make the button return to its default width
      child: Container(
        margin: EdgeInsets.all(10),
        child: SizedBox(
          width: 280,
          height: 50,
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
            child: Text('${answer.answerText}'),
            onPressed: () {
              selectAnswer(answerIndex);
            },
          ),
        ),
      ),
    );
  }
}
