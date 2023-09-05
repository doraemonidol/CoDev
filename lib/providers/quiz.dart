import 'package:flutter/material.dart';

class Quiz {
  final String quizID;
  final DateTime createDate;
  final List<dynamic> quests;

  Quiz({
    required this.quizID,
    required this.createDate,
    required this.quests,
  });
}

class Question {
  late String statement; 
  late List<dynamic> options;
  late int answer;

  Question({
    required this.statement,
    required this.options,
    required this.answer,
  });

}