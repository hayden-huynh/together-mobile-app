import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import 'package:together_app/models/questionnaire_entry_provider.dart'
    show QuestionType;
import 'package:together_app/widgets/answer_multiple_choices.dart';
import 'package:together_app/widgets/answer_open_ended.dart';
import 'package:together_app/widgets/answer_multiple_path.dart';
import 'package:together_app/models/answer.dart';

class AnswersSection extends StatefulWidget {
  final QuestionType type;
  final Answer answer;
  final Function goToNextQuestion;
  final Function goToPreviousQuestion;
  final int questionCount;

  AnswersSection(
    this.type,
    this.answer,
    this.goToNextQuestion,
    this.goToPreviousQuestion,
    this.questionCount,
  );

  @override
  _AnswersSectionState createState() => _AnswersSectionState();
}

class _AnswersSectionState extends State<AnswersSection> {
  Widget _getAnswerWidget() {
    switch (widget.type) {
      case QuestionType.MultipleChoice:
        return AnswerMultipleChoices(
          widget.answer,
        );
      case QuestionType.OpenEnded:
        return AnswerOpenEnded(
          widget.answer,
        );
      case QuestionType.MultiplePath:
        return AnswerMultiplePath(
          widget.answer,
        );
      default:
        return Center(
          child: Text('No answer available?'),
        );
    }
  }

  Widget _checkDeviceOrientation() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return SimpleGestureDetector(
        onHorizontalSwipe: (direction) {
          if (direction == SwipeDirection.left) {
            widget.goToNextQuestion();
          } else if (direction == SwipeDirection.right) {
            widget.goToPreviousQuestion();
          }
        },
        swipeConfig: SimpleSwipeConfig(
          horizontalThreshold: 40,
          swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
        ),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getAnswerWidget(),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: _getAnswerWidget(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _checkDeviceOrientation(),
    );
  }
}
