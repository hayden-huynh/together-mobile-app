import 'package:flutter/material.dart';

import 'package:together_app/screens/submission_screen.dart';

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
        // If currentEntryIndex is 0 i.e. the first question, do not
        // render the Previous button on the left
        if (currentEntryIndex != 0)
          TextButton.icon(
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.secondary,
              ),
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Colors.blue[200].withOpacity(0.3),
              ),
            ),
            key: UniqueKey(),
            onPressed: goToPreviousEntry,
            icon: const Icon(Icons.arrow_back_ios_outlined),
            label: const Text(
              'Previous',
              style: TextStyle(fontSize: 23),
            ),
          ),
        // If currentEntryIndex is the index of the last question,
        // render a Submit instead of a Next button on the right
        if (currentEntryIndex == entryNum - 1)
          TextButton.icon(
            key: UniqueKey(),
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Colors.green[200].withOpacity(0.3),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                SubmissionScreen.routeName,
              );
            },
            icon: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            label: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.green,
            ),
          )
        // Otherwise, if not at the last question, render the Next button
        // on the right as normal
        else
          TextButton.icon(
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.secondary,
              ),
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Colors.blue[200].withOpacity(0.3),
              ),
            ),
            key: UniqueKey(),
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
