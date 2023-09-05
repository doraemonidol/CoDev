import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

enum TaskState { todo, inProgress, completed }

class Task {
  final String field;
  final String stage;
  final String course;
  final String chapter;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final IconData icon;
  final int state;

  Task({
    required this.field,
    required this.stage,
    required this.course,
    required this.chapter,
    required this.startTime,
    required this.endTime,
    this.color = Colors.blue,
    this.icon = Icons.check_circle_outline,
    required this.state,
  });
}

class TaskList with ChangeNotifier {
  String userId;
  String token;
  DateTime date;
  List<Task> _tasks;

  TaskList({
    required this.userId,
    required this.token,
    required this.date,
    required List<Task> tasks,
  }) : _tasks = tasks;
}
