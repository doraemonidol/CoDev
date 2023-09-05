import 'package:flutter/material.dart';

class Quiz {
  final String quizID;
  final DateTime createDate;
  final List<Question> quests;

  Quiz({
    required this.quizID,
    required this.createDate,
    required this.quests,
  });
}

class Question {
  final String questID;
  final String statement; 
  final List<String?> options;
  final int answer;

  Question({
    required this.questID,
    required this.statement,
    required this.options,
    required this.answer,
  });

}