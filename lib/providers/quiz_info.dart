import 'package:codev/providers/quiz.dart';
import 'package:flutter/material.dart';

class QuizInfo extends ChangeNotifier {

  int option = 0;

  int indexedButton = 0;

  int totalCorrect = 0;

  int indexQuest = 0;

  late Quiz quiz;

  bool complete = false;

  String lesson = "";

  String field = "";

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
    notifyListeners();
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

  void onOptionAClicked() {
    option = 1;
    indexedButton = 1;
    notifyListeners();
  }

  void onOptionBClicked() {
    option = 2;
    indexedButton = 1;
    notifyListeners();
  }

  void onOptionCClicked() {
    option = 3;
    indexedButton = 1;
    notifyListeners();
  }

  void onOptionDClicked() {
    option = 4;
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

  void setQuizTopic(String field, String lesson) {
    debugPrint("...");
    this.field = field;
    this.lesson = lesson;
    notifyListeners();
  }

}