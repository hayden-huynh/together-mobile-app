import 'package:flutter/foundation.dart';

import 'package:together_app/models/answer.dart';

enum QuestionType {
  MultipleChoice,
  OpenEnded,
  MultiplePath,
}

class QuestionnaireEntry {
  final String questionText;
  final QuestionType type;
  final Answer answer;

  QuestionnaireEntry(
    this.questionText,
    this.type,
    this.answer,
  );
}

class QuestionnaireEntryProvider with ChangeNotifier {
  List<QuestionnaireEntry> _entries = [
    QuestionnaireEntry(
      'I feel good right now?',
      QuestionType.MultipleChoice,
      Answer(answerText: [
        'Strong Disagree',
        'Disagree',
        'Neither Agree nor Disagree',
        'Agree',
        'Strongly Agree',
      ]),
    ),
    QuestionnaireEntry(
      'How connected do you feel to other people in general right now?',
      QuestionType.MultipleChoice,
      Answer(answerText: [
        'Not At All Connected',
        'A Little Connected',
        'Prefer Not To Say',
        'Connected',
        'Very Connected',
      ]),
    ),
    QuestionnaireEntry(
      'Do you feel lonely right now?',
      QuestionType.MultipleChoice,
      Answer(answerText: [
        'Very lonely',
        'Lonely',
        'Prefer Not To Say',
        'A Little Lonely',
        'Not At All Lonely',
      ]),
    ),
    QuestionnaireEntry(
      'How would you rate your learning capacity right now?',
      QuestionType.MultipleChoice,
      Answer(answerText: [
        'Poor',
        'Not Great',
        'Prefer Not To Say',
        'OK',
        'Really Good',
      ]),
    ),
    QuestionnaireEntry(
      'Assuming there are some people nearby, how connected do you feel to those people right now?',
      QuestionType.MultipleChoice,
      Answer(answerText: [
        'Not At All Connected',
        'A Little Connected',
        'Prefer Not To Say',
        'N/A',
        'Connected',
        'Very Connected',
      ]),
    ),
    QuestionnaireEntry(
      'Right now, how many people are currently within a 5m radius of you?',
      QuestionType.OpenEnded,
      Answer(),
    ),
    QuestionnaireEntry(
      'Where are you right now?',
      QuestionType.MultiplePath,
      Answer(
        answerText: {
          'At university': {
            'In a lecture': {
              'With friends': null,
              'With peers': null,
            },
            'In a tutorial': {
              'With friends': null,
              'With peers': null,
            },
            'In the library': {
              'With friends': null,
              'With peers': null,
              'Alone': null,
            },
            'On campus': {
              'With friends': null,
              'With peers': null,
              'Alone': null,
            },
          },
          'At work': {
            'With friends': null,
            'With family': null,
            'With colleagues': null,
            'Alone': null,
          },
          'At home': {
            'With friends': null,
            'With family': null,
            'Online Studying': null,
            'Alone': null,
          },
          'Other': {
            'With friends': null,
            'With family': null,
            'With strangers': null,
            'Alone': null,
          }
        },
        usersAnswer: <int, String>{},
      ),
    )
  ];

  List<QuestionnaireEntry> get entries {
    return [..._entries];
  }
}
