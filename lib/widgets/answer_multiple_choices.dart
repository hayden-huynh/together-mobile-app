import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';

class AnswerMultipleChoices extends StatefulWidget {
  final Answer answer;

  AnswerMultipleChoices(
    this.answer,
  );

  @override
  _AnswerMultipleChoicesState createState() => _AnswerMultipleChoicesState();
}

class _AnswerMultipleChoicesState extends State<AnswerMultipleChoices> {
  @override
  Widget build(BuildContext context) {
    List<String> answerText = widget.answer.answerText as List<String>;
    double _currentSliderValue;
    if (widget.answer.usersAnswer == null) {
      _currentSliderValue = 0;
      widget.answer.usersAnswer = answerText[0];
    } else {
      _currentSliderValue = answerText.indexOf(widget.answer.usersAnswer) * 1.0;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 5.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              answerText.length,
              (idx) => Container(
                width: 53,
                child: Text(
                  '${answerText[idx]}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.red.shade400,
                Colors.green.shade400,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: Theme.of(context).accentColor,
              activeTrackColor: Theme.of(context).accentColor.withOpacity(0.24),
              inactiveTrackColor:
                  Theme.of(context).accentColor.withOpacity(0.24),
              activeTickMarkColor: Colors.amber,
              inactiveTickMarkColor: Colors.amber,
              valueIndicatorColor: Theme.of(context).accentColor,
              valueIndicatorTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            child: Slider(
              value: _currentSliderValue,
              label: answerText[_currentSliderValue.toInt()],
              min: 0,
              max: answerText.length.toDouble() - 1,
              divisions: answerText.length - 1,
              onChanged: (newValue) {
                setState(() {
                  _currentSliderValue = newValue;
                  widget.answer.usersAnswer = answerText[newValue.toInt()];
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
