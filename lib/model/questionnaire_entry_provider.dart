import 'package:flutter/material.dart';

import 'package:together_app/model/answer.dart';

class QuestionnaireEntry {
  final String questionText;
  final List<Answer> answers;

  QuestionnaireEntry(
    this.questionText,
    this.answers,
  );
}

class QuestionnaireEntryProvider with ChangeNotifier {
  List<QuestionnaireEntry> _entries = [
    QuestionnaireEntry(
      'Question 1',
      [
        Answer(answerText: 'A'),
        Answer(answerText: 'B'),
        Answer(answerText: 'C'),
        Answer(answerText: 'D'),
      ],
    ),
    QuestionnaireEntry(
      'Question 2',
      [
        Answer(answerText: 'D'),
        Answer(answerText: 'E'),
        Answer(answerText: 'F'),
        Answer(answerText: 'G'),
      ],
    ),
    QuestionnaireEntry(
      'Question 3',
      [
        Answer(answerText: 'H'),
        Answer(answerText: 'I'),
        Answer(answerText: 'J'),
        Answer(answerText: 'K'),
      ],
    ),
    QuestionnaireEntry(
      'Question 4',
      [
        Answer(answerText: 'L'),
        Answer(answerText: 'M'),
        Answer(answerText: 'N'),
        Answer(answerText: 'O'),
      ],
    ),
    QuestionnaireEntry(
      'Question 5',
      [
        Answer(answerText: 'P'),
        Answer(answerText: 'Q'),
        Answer(answerText: 'R'),
        Answer(answerText: 'S'),
      ],
    ),
  ];

  List<QuestionnaireEntry> get entries {
    return [..._entries];
  }
}
