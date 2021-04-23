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
          TextButton.icon(
            onPressed: goToPreviousEntry,
            icon: const Icon(Icons.arrow_back_ios_outlined),
            label: const Text(
              'Previous',
              style: TextStyle(fontSize: 23),
            ),
          ),
        if (currentEntryIndex != entryNum - 1)
          TextButton.icon(
            onPressed: goToNextEntry,
            icon: const Text(
              'Next',
              style: TextStyle(fontSize: 23),
            ),
            label: const Icon(Icons.arrow_forward_ios_outlined),
          ),
      ],
    );
  }
}
