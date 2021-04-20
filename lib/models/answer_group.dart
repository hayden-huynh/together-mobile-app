import 'package:flutter/material.dart';

import 'package:together_app/models/answer.dart';

class AnswerGroup with ChangeNotifier {
  final List<Answer> answerGroup;

  AnswerGroup(this.answerGroup);

  void selectAnswer(int index) {
    answerGroup[index].isSelected = true;
    for (int i = 0; i < answerGroup.length; i++) {
      if (i != index) {
        answerGroup[i].isSelected = false;
      }
    }
    notifyListeners();
  } 
}