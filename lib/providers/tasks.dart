import 'package:flutter/material.dart';

enum taskState { finished, unfinished, late }

class Task {
  final String field;
  final String stage;
  final String course;
  final String chapter;
  final int startTime;
  final int endTime;
  final int state;

  Task({
    required this.field,
    required this.stage,
    required this.course,
    required this.chapter,
    required this.startTime,
    required this.endTime,
    required this.state,
  });
}

class TaskList {
  final DateTime date;
  final List<Task> tasks;

  TaskList({
    required this.date,
    required this.tasks,
  });
}
