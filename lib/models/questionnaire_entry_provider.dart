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
      'Where are you right now?',
      QuestionType.MultiplePath,
      Answer(
        answerText: {
          'At university': {
            'Studying': {
              "Face-to-face": {
                "A lecture": {
                  "With friends": null,
                  "With strangers": null,
                },
                "A tutorial": {
                  "With friends": null,
                  "With strangers": null,
                },
                "Library": {
                  "With friends": null,
                  "With strangers": null,
                  "Alone": null
                }
              },
              "Online": {
                "A lecture": {
                  "With friends": null,
                  "With strangers": null,
                  "Alone": null,
                },
                "A tutorial": {
                  "With friends": null,
                  "With strangers": null,
                  "Alone": null,
                },
                "Other self-directed study": {
                  "With friends": null,
                  "With strangers": null,
                  "Alone": null,
                },
              }
            },
            'Socialising': null,
            'Relaxing': {
              'With friends': null,
              'With strangers': null,
              'Alone': null,
            },
            'Exercising': {
              'With friends': null,
              'With strangers': null,
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
            'Alone': null,
          },
          "Out and about": {
            "Travelling": {
              "With friends": null,
              "With strangers": null,
              "Alone": null,
            },
            "Eating": {
              "With friends": null,
              "With strangers": null,
              "Alone": null,
            },
            "Exercising": {
              "With friends": null,
              "With strangers": null,
              "Alone": null,
            },
            "Relaxing": {
              "With friends": null,
              "With strangers": null,
              "Alone": null,
            },
            "Socialising": {
              "With friends": null,
              "With family": null,
            }
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
    ),
    QuestionnaireEntry(
      'How many people are with you right now?',
      QuestionType.OpenEnded,
      Answer(usersAnswer: null),
    ),
    QuestionnaireEntry(
      'How would you rate your sense of connection to the people around you right now?',
      QuestionType.MultipleChoice,
      Answer(
        answerText: [
          'Terrible',
          'Not Good',
          'Average',
          'Good',
          'Amazing',
        ],
        usersAnswer: null,
      ),
    ),
    QuestionnaireEntry(
      'How would you rate your physical health right now?',
      QuestionType.MultipleChoice,
      Answer(
        answerText: [
          'Terrible',
          'Not Good',
          'Average',
          'Good',
          'Amazing',
        ],
        usersAnswer: null,
      ),
    ),
    QuestionnaireEntry(
      'How would you rate your mental health right now?',
      QuestionType.MultipleChoice,
      Answer(
        answerText: [
          'Terrible',
          'Not Good',
          'Average',
          'Good',
          'Amazing',
        ],
        usersAnswer: null,
      ),
    ),
    QuestionnaireEntry(
      'How would you rate your learning capacity right now?',
      QuestionType.MultipleChoice,
      Answer(
        answerText: [
          'Terrible',
          'Not Good',
          'Average',
          'Good',
          'Amazing',
        ],
        usersAnswer: null,
      ),
    ),
    QuestionnaireEntry(
      'How would you rate your sense of identification with The University of Queensland right now?',
      QuestionType.MultipleChoice,
      Answer(
        answerText: [
          'Terrible',
          'Not Good',
          'Average',
          'Good',
          'Amazing',
        ],
        usersAnswer: null,
      ),
    ),
    QuestionnaireEntry(
      'How would you rate your feeling on being in control right now?',
      QuestionType.MultipleChoice,
      Answer(
        answerText: [
          'Terrible',
          'Not Good',
          'Average',
          'Good',
          'Amazing',
        ],
        usersAnswer: null,
      ),
    ),
  ];

  bool _multiplePathCompletedAnswer = false;

  List<QuestionnaireEntry> get entries {
    return _entries;
  }

  bool get multiplePathCompletedAnswer => _multiplePathCompletedAnswer;

  set setMultiplePathCompletedAnswer(bool isCompleted) {
    _multiplePathCompletedAnswer = isCompleted;
  }
}
