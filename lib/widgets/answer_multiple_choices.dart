import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';
import 'package:together_app/widgets/text_with_id.dart';

class AnswerMultipleChoices extends StatefulWidget {
  final Answer answer;
  final Key key;

  AnswerMultipleChoices(
    this.key,
    this.answer,
  );

  @override
  _AnswerMultipleChoicesState createState() => _AnswerMultipleChoicesState();
}

class _AnswerMultipleChoicesState extends State<AnswerMultipleChoices> {
  bool _answerChosen;
  bool _isChoosing;
  List<String> _answerText;
  double _currentSliderValue;

  @override
  void initState() {
    _answerChosen = widget.answer.usersAnswer == null ? false : true;
    _isChoosing = false;
    _answerText = widget.answer.answerText as List<String>;
    if (widget.answer.usersAnswer == null) {
      _currentSliderValue = 2;
    } else {
      _currentSliderValue =
          _answerText.indexOf(widget.answer.usersAnswer) * 1.0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: "Please move the"),
              TextSpan(
                text: " slider",
                style: TextStyle(
                  color: _answerChosen ? Colors.transparent : Colors.blue,
                ),
              ),
              TextSpan(text: " to indicate your answer"),
            ]),
            style: TextStyle(
              fontSize: 15,
              color: _answerChosen ? Colors.transparent : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        // The row of different answer options displayed above the slider
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 5.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _answerText.length,
              (idx) => Container(
                  width: _isChoosing ? 80 : 53,
                  child: TextWithId(
                    idx,
                    _currentSliderValue.toInt(),
                    '${_answerText[idx]}',
                    _answerChosen,
                    _isChoosing,
                    UniqueKey(),
                  )
                  // Text(
                  //   '${_answerText[idx]}',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.bold,
                  //     color: _answerChosen ? Colors.black : Colors.grey,
                  //   ),
                  //   softWrap: true,
                  //   textAlign: TextAlign.center,
                  // ),
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
              thumbColor: Theme.of(context).colorScheme.secondary,
              activeTrackColor: _answerChosen
                  ? Colors.black.withOpacity(0.6)
                  : Colors.grey.withOpacity(0.6),
              inactiveTrackColor: _answerChosen
                  ? Colors.black.withOpacity(0.6)
                  : Colors.grey.withOpacity(0.6),
              activeTickMarkColor: Colors.white,
              inactiveTickMarkColor: Colors.white,
            ),
            child: Slider(
              value: _currentSliderValue,
              min: 0,
              max: _answerText.length.toDouble() - 1,
              divisions: _answerText.length - 1,
              onChanged: (newValue) {
                setState(() {
                  _answerChosen = true;
                  _currentSliderValue = newValue;
                  widget.answer.usersAnswer = _answerText[newValue.toInt()];
                });
              },
              onChangeStart: (newValue) {
                setState(() {
                  _answerChosen = true;
                  _isChoosing = true;
                  widget.answer.usersAnswer = _answerText[newValue.toInt()];
                });
              },
              onChangeEnd: (newValue) {
                setState(() {
                  _isChoosing = false;
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
