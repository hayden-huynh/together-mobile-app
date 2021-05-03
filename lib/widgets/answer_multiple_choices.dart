import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';

class AnswerMultipleChoices extends StatefulWidget {
  final List<Answer> answers;
  final Function selectAnswer;

  AnswerMultipleChoices(
    this.answers,
    this.selectAnswer,
  );

  @override
  _AnswerMultipleChoicesState createState() => _AnswerMultipleChoicesState();
}

class _AnswerMultipleChoicesState extends State<AnswerMultipleChoices> {
  @override
  Widget build(BuildContext context) {
    int index = widget.answers.indexWhere((ans) => ans.isSelected);
    double _currentSliderValue = index == -1 ? 0 : index * 1.0;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.answers.length,
              (idx) => Text(
                '${idx + 1} - ${widget.answers[idx].answerText}',
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                widget.answers.length,
                (index) => Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbColor: Theme.of(context).primaryColor,
              activeTrackColor:
                  Theme.of(context).primaryColor.withOpacity(0.24),
              inactiveTrackColor:
                  Theme.of(context).primaryColor.withOpacity(0.24),
              activeTickMarkColor: Theme.of(context).primaryColor,
              inactiveTickMarkColor: Theme.of(context).primaryColor,
            ),
            child: Slider.adaptive(
              value: _currentSliderValue,
              min: 0,
              max: widget.answers.length.toDouble() - 1,
              divisions: widget.answers.length - 1,
              onChanged: (newValue) {
                setState(() {
                  _currentSliderValue = newValue;
                  widget.selectAnswer(newValue.toInt());
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
