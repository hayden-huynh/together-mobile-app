import 'package:flutter/material.dart';

class QuestionnaireEntryNavigator extends StatelessWidget {
  final int currentEntryIndex;
  final Function goToPreviousEntry;
  final Function goToNextEntry;
  final int entryNum;

  QuestionnaireEntryNavigator(
    this.currentEntryIndex,
    this.goToPreviousEntry,
    this.goToNextEntry,
    this.entryNum,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: currentEntryIndex == 0
          ? MainAxisAlignment.end
          : MainAxisAlignment.spaceBetween,
      children: [
        if (currentEntryIndex != 0)
          InkWell(
            onTap: goToPreviousEntry,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (currentEntryIndex != entryNum - 1)
          InkWell(
            onTap: goToNextEntry,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
