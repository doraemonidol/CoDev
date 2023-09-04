import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

enum taskState { finished, unfinished, late }

class Task {
  final String field;
  final String stage;
  final String course;
  final String chapter;
  final DateTime startTime;
  final DateTime endTime;
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

  // fetch and set tasklist
  Future<void> fetchAndSetTaskList() async {
    print('fetching tasklist');
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$token';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      // print(response.body);
      if (extractedData == null) {
        return;
      }

      date = DateTime.parse(extractedData['date']);
      _tasks = extractedData['tasks'].map((task) {
        return Task(
          field: task['field'],
          stage: task['stage'],
          course: task['course'],
          chapter: task['chapter'],
          startTime: task['startTime'],
          endTime: task['endTime'],
          state: task['state'],
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTask(Task task) async {
    print('adding task');
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$token';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'tasks': [
            ..._tasks,
            {
              'field': task.field,
              'stage': task.stage,
              'course': task.course,
              'chapter': task.chapter,
              'startTime': task.startTime,
              'endTime': task.endTime,
              'state': task.state,
            }
          ]
        }),
      );

      _tasks.insert(
        0,
        Task(
          field: task.field,
          stage: task.stage,
          course: task.course,
          chapter: task.chapter,
          startTime: task.startTime,
          endTime: task.endTime,
          state: task.state,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
