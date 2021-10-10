import 'package:flutter/material.dart';

class TextWithId extends StatelessWidget {
  final int id;
  final int currentChoiceIndex;
  final String text;
  final bool answerChosen;
  final bool isChoosing;
  final Key key;

  TextWithId(
    this.id,
    this.currentChoiceIndex,
    this.text,
    this.answerChosen,
    this.isChoosing,
    this.key,
  );

  bool _isChosen() {
    return id == currentChoiceIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isChoosing ? (_isChosen() ? 50 : 20) : 30,
      child: Text(
        text,
        style: TextStyle(
          fontSize: isChoosing ? (_isChosen() ? 18 : 10) : 12,
          fontWeight: FontWeight.bold,
          color: answerChosen
              ? (_isChosen() ? Colors.green[600] : Colors.black)
              : Colors.grey,
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }
}
