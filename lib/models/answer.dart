import 'package:flutter/foundation.dart';

class Answer with ChangeNotifier {
  final String answerText;
  bool isSelected;

  Answer({
    this.answerText,
    this.isSelected = false,
  });

  void selectAnswer(List<Answer> answersGroup, int answerIndex) {
    isSelected = true;
    for (int i = 0; i < answersGroup.length; i++) {
      if (i != answerIndex) {
        answersGroup[i].isSelected = false;
      }
    }
    notifyListeners();
  }
}
