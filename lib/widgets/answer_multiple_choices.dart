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
        // The row of different answer options displayed above the slider
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
        // The slider for users to choose between the different options
        // The answer value chosen is stored into the Answer object passed into this widget,
        // which belongs to the central list of entries "_entries" in QuestionnaireEntryScreen
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
              thumbColor: Theme.of(context).accentColor,
              activeTrackColor: Colors.black.withOpacity(0.6),
              inactiveTrackColor: Colors.black.withOpacity(0.6),
              activeTickMarkColor: Colors.white,
              inactiveTickMarkColor: Colors.white,
            ),
            child: Slider(
              value: _currentSliderValue,
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
