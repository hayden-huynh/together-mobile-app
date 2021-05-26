import 'package:flutter/material.dart';

class DropdownButtonWithId extends StatefulWidget {
  final int id;
  final Key key;
  final String initVal;
  final List<String> itemList;
  final Function callback;

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
  String _val;

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
        hint: Text('Choose one'),
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
            .toList(),
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
