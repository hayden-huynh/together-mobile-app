import 'package:flutter/foundation.dart';

import 'package:together_app/models/answer.dart';
import 'package:together_app/models/answer_group.dart';

class QuestionnaireEntry {
  final String questionText;
  final AnswerGroup answers;

  QuestionnaireEntry(
    this.questionText,
    this.answers,
  );
}

class QuestionnaireEntryProvider with ChangeNotifier {
  List<QuestionnaireEntry> _entries = [
    QuestionnaireEntry(
      'Question 1',
      AnswerGroup([
        Answer(answerText: 'A'),
        Answer(answerText: 'B'),
        Answer(answerText: 'C'),
        Answer(answerText: 'D'),
      ]),
    ),
    QuestionnaireEntry(
      'Question 2',
      AnswerGroup([
        Answer(answerText: 'D'),
        Answer(answerText: 'E'),
        Answer(answerText: 'F'),
        Answer(answerText: 'G'),
      ]),
    ),
    QuestionnaireEntry(
      'Question 3',
      AnswerGroup([
        Answer(answerText: 'H'),
        Answer(answerText: 'I'),
        Answer(answerText: 'J'),
        Answer(answerText: 'K'),
      ]),
    ),
    QuestionnaireEntry(
      'Question 4',
      AnswerGroup([
        Answer(answerText: 'L'),
        Answer(answerText: 'M'),
        Answer(answerText: 'N'),
        Answer(answerText: 'O'),
      ]),
    ),
    QuestionnaireEntry(
      'Question 5',
      AnswerGroup([
        Answer(answerText: 'P'),
        Answer(answerText: 'Q'),
        Answer(answerText: 'R'),
        Answer(answerText: 'S'),
      ]),
    ),
  ];

  List<QuestionnaireEntry> get entries {
    return [..._entries];
  }
}
