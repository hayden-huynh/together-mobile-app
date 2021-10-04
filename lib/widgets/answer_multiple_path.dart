import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';
import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/widgets/dropdown_button_with_id.dart';

class AnswerMultiplePath extends StatefulWidget {
  final Answer answer;

  AnswerMultiplePath(this.answer);

  @override
  AnswerMultiplePathState createState() => AnswerMultiplePathState();
}

class AnswerMultiplePathState extends State<AnswerMultiplePath> {
  // _counter is used to track the assignment of ids to dropdown buttons
  // At any point after initialization, _counter always equals the id of the last dropdown button in the list
  // and the integer key of the last answer in answer.usersAnswer
  int _counter = 0;
  List<Widget> _dropdownButtonList = [];
  bool _addedArrows = false;

  /// _callback is called whenever the user chooses a new option in any of the dropdown buttons
  void _callback(int id, String newValue,
      QuestionnaireEntryProvider questionnaireProvider) {
    // In the answer.usersAnswer map, set the key same as id to the newValue chosen
    widget.answer.usersAnswer[id] = newValue;
    setState(() {
      // Loop through _dropdownButtonList and remove all arrow icons
      for (int i = 0; i < _dropdownButtonList.length; i++) {
        if (_dropdownButtonList[i] is Icon) {
          _dropdownButtonList.removeAt(i);
        }
      }

      // After removing all arrow icons from the list, _counter is now the same as the index of the
      // last dropdown button in the list. Remove all buttons starting from the last to and include the one
      // right below the button with current id because when the option of a button changes, all options
      // below it need to be chosen again
      for (int i = _counter; i > id; i--) {
        _counter--; // Decrement _counter to eventually the same as the id of the current button
        _dropdownButtonList.removeAt(i); // Remove the buttons from the list
        widget.answer.usersAnswer.remove(i); // Remove the chosen answers
      }

      // itemList is set to the second layer answer text map. From here, traverse deeper into the layers
      // of answer text map until the map corresponding with the button immediately below this current button
      // is reached.
      // Button id 0 <=> option list = answer.answerText.keys (keys of top layer map)
      // Button id 1 <=> option list = answer.answerText[answer.usersAnswer[0]].keys
      // Button id 2 <=> option list = answer.answerText[answer.usersAnswer[1]].keys
      // ... Button id _counter + 1 <=> option list = answer.answerText[answer.usersAnswer[_counter]].keys
      // We are trying to extract the list of map keys which are options for the button of id _counter + 1,
      // hence we have to traverse until answer.usersAnswer[_counter]
      var itemList = widget.answer.answerText[widget.answer.usersAnswer[0]];
      for (int i = 1; i < _counter + 1; i++) {
        itemList = itemList[widget.answer.usersAnswer[i]];
      }
      // If the final itemList is not null i.e. there exist options to choose, increment _counter by 1
      // and add a new dropdown button to the list corresponding to itemList
      if (itemList != null) {
        _counter++;
        _dropdownButtonList.add(DropdownButtonWithId(
          _counter,
          UniqueKey(),
          null,
          itemList.keys.toList(),
          _callback,
        ));
        questionnaireProvider.setMultiplePathCompletedAnswer = false;
      } else {
        questionnaireProvider.setMultiplePathCompletedAnswer = true;
      }

      // Reinsert all arrow icons. Arrow icons intertwine with dropdown buttons.
      // In _dropdownButtonList, they occupy odd indices 1, 3, 5, etc. The last arrow index
      // cannot exceed the index of the final button in the list where arrows are fully added,
      // which is equal to _counter * 2
      for (int i = 1; i < _counter * 2; i += 2) {
        _dropdownButtonList.insert(
          i,
          Icon(
            Icons.arrow_downward_rounded,
            color: Theme.of(context).primaryColor,
            key: UniqueKey(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    // If the user has not answered anything yet, add to _dropdownButtonList the first
    // DropdownButtonWithId taking all the keys of the first-layer (top-layer) map inside
    // the Answer object passed into this widget as its options
    if (widget.answer.usersAnswer.length == 0) {
      // Extract the list of keys of the first-layer map inside answer.answerText
      List<String> itemList = widget.answer.answerText.keys.toList();
      // Create the very first dropdown button
      _dropdownButtonList.add(DropdownButtonWithId(
        _counter, // _counter starts at 0
        UniqueKey(), // is set so that this dropdown button can be properly removed from widget tree later on
        null, // no initial answer chosen
        itemList, // list of options same as itemList
        _callback,
      ));
    }
    // Otherwise, if the user has answered some or all parts, add to _dropdownButtonList the number of DropdownButtonWithId widgets same as answer.usersAnswer.length
    else {
      // itemList is the first-layer map of answer text options
      var itemList = widget.answer.answerText;
      for (int i = 0; i < widget.answer.usersAnswer.length; i++) {
        if (itemList != null) {
          _dropdownButtonList.add(DropdownButtonWithId(
            _counter, // _counter starts at 0, is set as ids for dropdown buttons
            UniqueKey(), // is set so that this dropdown button can be properly removed from widget tree later on
            widget.answer.usersAnswer[
                i], // set initial value to what the user has chosen
            itemList.keys
                .toList(), // list of options same as keys of current answer text map
            _callback,
          ));

          // Move to the next layer, which results in the next deeper answer text map
          itemList = itemList[widget.answer.usersAnswer[i]];
          // If this next map is not null i.e. there needs a next dropdown button to hold the option
          // keys of this map, increment _counter by one to use its value as id for that next button
          if (itemList != null) {
            _counter++;
          }
        }
      }
      // Sometimes, the current answer.usersAnswer.length may be smaller than the number of answer
      // text map layers. If so, check the current itemList, and if it is not null i.e there are more
      // options to choose, add one more empty dropdown button at the end to prompt the user to keep answering
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
    // This section is executed after initState() and before build()
    // If answer.usersAnswer.length is not 0 i.e. there are already multiple buttons in the list
    // and not just one, and no arrows have been added yet, insert the arrow icons so that they occupy odd
    // indices 1, 3, 5, etc. The last arrow index cannot exceed the index of the final button in the list
    // where arrows are fully added, which is equal to _counter * 2
    if (!_addedArrows && widget.answer.usersAnswer.length != 0) {
      for (int i = 1; i <= _counter * 2; i += 2) {
        _dropdownButtonList.insert(
          i,
          Icon(
            Icons.arrow_downward_rounded,
            color: Theme.of(context).primaryColor,
            key: UniqueKey(),
          ),
        );
      }
      _addedArrows = true;
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
