import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';
import 'package:together_app/models/dropdown_button_with_id.dart';

class AnswerMultiplePath extends StatefulWidget {
  final Answer answer;

  AnswerMultiplePath(this.answer);

  @override
  _AnswerMultiplePathState createState() => _AnswerMultiplePathState();
}

class _AnswerMultiplePathState extends State<AnswerMultiplePath> {
  int _counter = 0;
  List<Widget> _dropdownButtonList = [];
  bool addedArrows = false;

  void _callback(int id, String newValue) {
    widget.answer.usersAnswer[id] = newValue;
    setState(() {
      for (int i = 0; i < _dropdownButtonList.length; i++) {
        if (_dropdownButtonList[i] is Icon) {
          _dropdownButtonList.removeAt(i);
        }
      }

      for (int i = _counter; i > id; i--) {
        _counter--;
        _dropdownButtonList.removeAt(i);
        widget.answer.usersAnswer.remove(i);
      }

      var itemList = widget.answer.answerText[widget.answer.usersAnswer[0]];
      for (int i = 1; i < _counter + 1; i++) {
        itemList = itemList[widget.answer.usersAnswer[i]];
      }
      if (itemList != null) {
        _counter++;
        _dropdownButtonList.add(DropdownButtonWithId(
          _counter,
          UniqueKey(),
          null,
          itemList.keys.toList(),
          _callback,
        ));
      }

      for (int i = 1; i <= _counter + 1; i += 2) {
        _dropdownButtonList.insert(
          i,
          Icon(
            Icons.arrow_downward_rounded,
            color: Theme.of(context).primaryColor,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    if (widget.answer.usersAnswer.length == 0) {
      List<String> itemList = widget.answer.answerText.keys.toList();
      _dropdownButtonList.add(DropdownButtonWithId(
        _counter,
        UniqueKey(),
        null,
        itemList,
        _callback,
      ));
    } else {
      var itemList = widget.answer.answerText;
      for (int i = 0; i < widget.answer.usersAnswer.length; i++) {
        if (itemList != null) {
          _dropdownButtonList.add(DropdownButtonWithId(
            _counter,
            UniqueKey(),
            widget.answer.usersAnswer[i],
            itemList.keys.toList(),
            _callback,
          ));

          itemList = itemList[widget.answer.usersAnswer[i]];
          if (itemList != null) {
            _counter++;
          }
        }
      }
      if (itemList != null) {
        _dropdownButtonList.add(DropdownButtonWithId(
          _counter,
          UniqueKey(),
          null,
          itemList.keys.toList(),
          _callback,
        ));
      }
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!addedArrows && widget.answer.usersAnswer.length != 0) {
      for (int i = 1; i <= _counter + 1; i += 2) {
        _dropdownButtonList.insert(
          i,
          Icon(
            Icons.arrow_downward_rounded,
            color: Theme.of(context).primaryColor,
          ),
        );
      }
      addedArrows = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _dropdownButtonList,
    );
  }
}
