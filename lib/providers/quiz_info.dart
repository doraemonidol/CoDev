import 'package:codev/providers/quiz.dart';
import 'package:flutter/material.dart';

import 'tasks.dart';

class QuizInfo extends ChangeNotifier {
  int option = 0;

  int indexedButton = 0;

  int totalCorrect = 0;

  int indexQuest = 0;

  late Quiz quiz;

  bool complete = false;

  Task task = Task(
    field: '',
    stage: '',
    course: '',
    description: '',
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    color: Colors.blue,
    icon: Icons.ac_unit,
    state: 0,
  );

  bool disabled = false;

  List<bool> answeredStatus = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void updateResult() {
    if (option - 1 == quiz.quests[indexQuest].answer) {
      if (totalCorrect <= 9) ++totalCorrect;
      indexedButton = 2;
      answeredStatus[indexQuest] = true;
    } else {
      indexedButton = 3;
    }
    disabled = true;
    notifyListeners();
  }

  void enableButton() {
    disabled = false;
  }

  void slideNextQuestion() {
    if (indexQuest == 9) {
      complete = true;
    }

    if (indexQuest < 9 && answeredStatus[indexQuest]) {
      ++indexQuest;
    }

    option = 0;
    indexedButton = 0;
    notifyListeners();
  }

  void onOptionClicked(int index) {
    if (disabled) return;
    option = index;
    indexedButton = 1;
    notifyListeners();
  }

  void setQuiz(Quiz quiz) {
    this.quiz = quiz;
    notifyListeners();
  }

  Question getCurrentQuestion() {
    return quiz.quests[indexQuest];
  }

  void setQuizTopic(Task newTask) {
    debugPrint("...");
    this.task = newTask;
    notifyListeners();
  }
}
