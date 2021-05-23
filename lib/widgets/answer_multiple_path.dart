import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';

class AnswerMultiplePath extends StatefulWidget {
  final Answer answer;

  AnswerMultiplePath(this.answer);

  @override
  _AnswerMultiplePathState createState() => _AnswerMultiplePathState();
}

class _AnswerMultiplePathState extends State<AnswerMultiplePath> {
  String _firstVal;
  String _secondVal;
  String _thirdVal;

  @override
  void initState() {
    _firstVal = widget.answer.usersAnswer[0] ?? 'Choose one';
    _secondVal = widget.answer.usersAnswer[1] ?? 'Choose one';
    _thirdVal = widget.answer.usersAnswer[2] ?? 'Choose one';
    super.initState();
  }

  void _firstValHandler(String newValue, int idx) {
    _firstVal = newValue;
    _secondVal = 'Choose one';
    widget.answer.usersAnswer.remove(1);
    _thirdVal = 'Choose one';
    widget.answer.usersAnswer.remove(2);
  }

  void _secondValHandler(String newValue, int idx) {
    _secondVal = newValue;
    _thirdVal = 'Choose one';
    widget.answer.usersAnswer.remove(2);
  }

  void _thirdValHandler(String newValue, int idx) {
    _thirdVal = newValue;
  }

  Widget _generateDropdownButton(
    String val,
    List<String> itemList,
    int idx,
    Function onChangedHandler,
  ) {
    return DropdownButton(
      elevation: 16,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 20,
      value: val,
      items: itemList
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (newValue) {
        setState(() {
          onChangedHandler(newValue, idx);
          widget.answer.usersAnswer[idx] = newValue;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _generateDropdownButton(
            _firstVal,
            [
              'Choose one',
              'At university',
              'At work',
              'At home',
              'Other',
            ],
            0,
            _firstValHandler),
        if (_firstVal == 'At university')
          _generateDropdownButton(
              _secondVal,
              [
                'Choose one',
                'In a lecture',
                'In a tutorial',
                'In the library',
                'On campus',
              ],
              1,
              _secondValHandler),
        if (_firstVal == 'At work')
          _generateDropdownButton(
              _secondVal,
              [
                'Choose one',
                'With friends',
                'With family',
                'With colleagues',
                'Alone',
              ],
              1,
              _secondValHandler),
        if (_firstVal == 'At home')
          _generateDropdownButton(
              _secondVal,
              [
                'Choose one',
                'With friends',
                'With family',
                'Online Studying',
                'Alone',
              ],
              1,
              _secondValHandler),
        if (_firstVal == 'Other')
          _generateDropdownButton(
              _secondVal,
              [
                'Choose one',
                'With friends',
                'With family',
                'With strangers',
                'Alone',
              ],
              1,
              _secondValHandler),
        if (_secondVal == 'In a lecture' || _secondVal == 'In a tutorial')
          _generateDropdownButton(
              _thirdVal,
              [
                'Choose one',
                'With peers',
                'With friends',
              ],
              2,
              _thirdValHandler),
        if (_secondVal == 'In the library' || _secondVal == 'On campus')
          _generateDropdownButton(
              _thirdVal,
              [
                'Choose one',
                'With peers',
                'With friends',
                'Alone',
              ],
              2,
              _thirdValHandler)
      ],
    );
  }
}
