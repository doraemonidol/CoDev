import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'field.dart';
import '../helpers/prompt.dart';

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

class TaskList {
  final DateTime date;
  final List<Task> tasks;

  TaskList({
    required this.date,
    required this.tasks,
  });
}

// add an input tasklist to firestore: in the collection users, in the document with ID equal to input ID, in object tasklists, create object with "date" equal to input date, and "tasks" equal to input tasklist. If there is already an object with "date" equal to input date, update its "tasks" to input tasklist.
Future<void> addTaskList(String id, TaskList taskList) async {
  final description =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  final descriptionData = description.data();
  final tasklists = descriptionData!['tasklists'];
  final tasklist = tasklists.firstWhere((element) {
    return element['date'] == taskList.date;
  }, orElse: () {
    return null;
  });
  if (tasklist == null) {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'tasklists': FieldValue.arrayUnion([
        {
          'date': taskList.date,
          'tasks': taskList.tasks.map((task) {
            return {
              'field': task.field,
              'stage': task.stage,
              'course': task.course,
              'startTime': task.startTime.toString(),
              'endTime': task.endTime.toString(),
              'color': task.color.value,
              'icon': task.icon.codePoint,
              'state': task.state,
            };
          }).toList(),
        }
      ])
    });
  } else {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'tasklists': FieldValue.arrayRemove([
        tasklist,
      ])
    });
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'tasklists': FieldValue.arrayUnion([
        {
          'date': taskList.date,
          'tasks': taskList.tasks.map((task) {
            return {
              'field': task.field,
              'stage': task.stage,
              'course': task.course,
              'startTime': task.startTime.toString(),
              'endTime': task.endTime.toString(),
              'color': task.color.value,
              'icon': task.icon.codePoint,
              'state': task.state,
            };
          }).toList(),
        }
      ])
    });
  }
}

// fetch a TaskList from firestore: in the collection users, in the document with ID equal to input ID, in object tasklists with date equal to current date, find the array object named "tasks"
Future<List<Task>> fetchTaskList(String id) async {
  final description =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  final descriptionData = description.data();
  final tasklists = descriptionData!['tasklists'];
  final tasklist = tasklists.firstWhere((element) {
    return element['date'] == DateTime.now();
  }, orElse: () {
    return null;
  });
  if (tasklist == null) {
    return [];
  } else {
    final tasks = tasklist['tasks'].map<Task>((task) {
      return Task(
        field: task['field'],
        stage: task['stage'],
        course: task['course'],
        startTime: DateTime.parse(task['startTime']),
        endTime: DateTime.parse(task['endTime']),
        color: Color(task['color']),
        icon: IconData(task['icon'], fontFamily: 'MaterialIcons'),
        state: task['state'],
      );
    }).toList();
    return tasks;
  }
}

Future<List<TaskList>?> fetchScheduledTasks(List<Field> learn) async {
  // turn this field list to json
  final fields = learn.map((field) {
    final stages = field.stages.map((stage) {
      final courses = stage.courses.map((course) {
        return {
          'name': course.name,
          'description': course.description,
          'prerequisiteCourses': course.prerequisiteCourses,
        };
      }).toList();
      return {
        'name': stage.name,
        'courses': courses,
      };
    }).toList();
    return {
      'name': field.name,
      'stages': stages,
    };
  }).toList();
  // turn this fields json to string
  final fieldsString = jsonEncode(fields);
  const apiKey = "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";
  const apiUrl = "https://api.openai.com/v1/completions";

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey'
  };

  final body = jsonEncode(
    {
      "model": "text-davinci-003",
      'prompt': schedulePrompt(fieldsString),
      'max_tokens': 7, // Adjust as needed
    },
  );
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['choices'][0]['text'];
      // turn result to json
      final scheduleJson = jsonDecode(result);
      // turn the above json to list of list of task
      final schedule = scheduleJson['tasklists'].map<TaskList>((tasklist) {
        final date = DateTime.parse(tasklist['date']);
        final tasks = tasklist['tasks'].map<Task>((task) {
          return Task(
            field: task['field'],
            stage: task['stage'],
            course: task['course'],
            startTime: DateTime.parse(task['startTime']),
            endTime: DateTime.parse(task['endTime']),
            color: Color(task['color']),
            icon: IconData(task['icon'], fontFamily: 'MaterialIcons'),
            state: task['state'],
          );
        }).toList();
        return {
          'date': date,
          'tasks': tasks,
        };
      }).toList();
      return schedule;
    } else {
      print(
        'Failed to call ChatGPT API: ${response.statusCode} ${response.body}',
      );
      return null;
    }
  } catch (e) {
    print("Error calling ChatGPT API: $e");
    return null;
  }
}
