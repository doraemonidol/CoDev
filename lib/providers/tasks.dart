import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

enum TaskState { todo, inProgress, completed }

class Task {
  final String field;
  final String stage;
  final String course;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final IconData icon;
  final int state;

  Task({
    required this.field,
    required this.stage,
    required this.course,
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

  //fetch and set task list from firebase with userId and token
  Future<void> fetchAndSetTaskList() async {
    final url =
        'https://learning-app-6f5f9-default-rtdb.firebaseio.com/users/$userId/tasks.json?auth=$token';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Task> loadedTasks = [];
      extractedData.forEach((taskId, taskData) {
        loadedTasks.add(Task(
          field: taskData['field'],
          stage: taskData['stage'],
          course: taskData['course'],
          startTime: DateTime.parse(taskData['startTime']),
          endTime: DateTime.parse(taskData['endTime']),
          color: Color(taskData['color']),
          icon: IconData(taskData['icon'], fontFamily: 'MaterialIcons'),
          state: taskData['state'],
        ));
      });
      _tasks = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
