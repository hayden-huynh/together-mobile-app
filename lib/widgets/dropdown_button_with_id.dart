import 'package:flutter/material.dart';

/// DropdownButtonWithId is a widget basically the same as the normal DropdownButton,
/// except that DropdownButtonWithId widgets are aware of which one they are in the
/// list _dropdownButtonList inside AnswerMultiplePath because of the ids assigned to them
class DropdownButtonWithId extends StatefulWidget {
  final int
      id; // id to identify this widget among the others in _dropdownButtonList
  final Key
      key; // UniqueKey() widget used for Flutter to properly remove this from widget tree later on
  final String initVal; // The value the user has chosen, null if there is none
  final List<String> itemList; // List of answer text options
  final Function
      callback; // Function to handle the behaviors of the button list, written in AnswerMultiplePath

  DropdownButtonWithId(
    this.id,
    this.key,
    this.initVal,
    this.itemList,
    this.callback,
  ) : super(key: key);

  @override
  _DropdownButtonWithIdState createState() => _DropdownButtonWithIdState();
}

class _DropdownButtonWithIdState extends State<DropdownButtonWithId> {
  String _val; // The initial value to set based on what the user has chosen

  @override
  void initState() {
    _val = widget.initVal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(5),
      child: DropdownButton(
        hint: Text('Choose one'), // Hint to show when no option is chosen yet
        elevation: 16,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 25,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        value: _val,
        items: widget.itemList
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(), // Map the list of answer text passed in to a list of DropdownMenuItem
        onChanged: (newValue) {
          setState(() {
            _val = newValue;
          });
          widget.callback(widget.id, newValue);
        },
      ),
    );
  }
}
