import 'package:flutter/foundation.dart';

import 'package:together_app/models/answer.dart';

enum QuestionType {
  MultipleChoice,
  OpenEnded,
}

class QuestionnaireEntry {
  final String questionText;
  final QuestionType type;
  final dynamic answers;

  QuestionnaireEntry(
    this.questionText,
    this.type,
    this.answers,
  );
}

class QuestionnaireEntryProvider with ChangeNotifier {
  List<QuestionnaireEntry> _entries = [
    QuestionnaireEntry(
      'I feel good right now?',
      QuestionType.MultipleChoice,
      [
        Answer(answerText: 'Strong Disagree'),
        Answer(answerText: 'Disagree'),
        Answer(answerText: 'Neither Agree nor Disagree'),
        Answer(answerText: 'Agree'),
        Answer(answerText: 'Strongly Agree'),
      ],
    ),
    QuestionnaireEntry(
      'How connected do you feel to other people in general right now?',
      QuestionType.MultipleChoice,
      [
        Answer(answerText: 'Not At All Connected'),
        Answer(answerText: 'A Little Connected'),
        Answer(answerText: 'Connected'),
        Answer(answerText: 'Very Connected'),
        Answer(answerText: 'Prefer Not To Say'),
      ],
    ),
    QuestionnaireEntry(
      'Do you feel lonely right now?',
      QuestionType.MultipleChoice,
      [
        Answer(answerText: 'Very lonely'),
        Answer(answerText: 'Lonely'),
        Answer(answerText: 'A Little Lonely'),
        Answer(answerText: 'Not At All Lonely'),
        Answer(answerText: 'Prefer Not To Say'),
      ],
    ),
    QuestionnaireEntry(
      'How would you rate your learning capacity right now?',
      QuestionType.MultipleChoice,
      [
        Answer(answerText: 'Poor'),
        Answer(answerText: 'Not Great'),
        Answer(answerText: 'OK'),
        Answer(answerText: 'Really Good'),
        Answer(answerText: 'Prefer Not To Say'),
      ],
    ),
    QuestionnaireEntry(
      'Assuming there are some people nearby, how connected do you feel to those people right now?',
      QuestionType.MultipleChoice,
      [
        Answer(answerText: 'Not At All Connected'),
        Answer(answerText: 'A Little Connected'),
        Answer(answerText: 'Connected'),
        Answer(answerText: 'Very Connected'),
        Answer(answerText: 'Prefer Not To Say'),
        Answer(answerText: 'N/A'),
      ],
    ),
    QuestionnaireEntry(
      'Right now, how many people are currently within a 5m radius of you?',
      QuestionType.OpenEnded,
      Answer(),
    )
  ];

  List<QuestionnaireEntry> get entries {
    return [..._entries];
  }
}
