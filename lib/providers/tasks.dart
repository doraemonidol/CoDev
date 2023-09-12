import 'dart:convert';
import 'package:codev/providers/auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'field.dart';
import '../helpers/prompt.dart';
import './progress.dart';
import 'package:dart_openai/dart_openai.dart';
import 'dart:io';

enum TaskState { todo, inProgress, completed }

class Task {
  final String field;
  final String stage;
  final String course;
  DateTime startTime;
  DateTime endTime;
  final Color color;
  final IconData icon;
  int state;

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
  DateTime date;
  List<Task> tasks;

  TaskList({
    required this.date,
    required this.tasks,
  });

  // find a task
  Task? findTask(Task task) {
    final index = tasks.indexWhere((element) {
      return element.field == task.field &&
          element.stage == task.stage &&
          element.course == task.course &&
          element.startTime == task.startTime &&
          element.endTime == task.endTime;
    });
    if (index == -1) {
      return null;
    } else {
      return tasks[index];
    }
  }

  // set state of a task and send to firebase
  Future<void> setState(String id, Task task, int state) async {
    final description =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    final descriptionData = description.data();
    final tasklists = descriptionData!['tasklists'];
    final tasklist = tasklists.firstWhere((element) {
      return element['date'] == date;
    }, orElse: () {
      return null;
    });
    if (tasklist == null) {
      throw Exception('No tasklist found');
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
      final index = tasks.indexWhere((element) {
        return element.field == task.field &&
            element.stage == task.stage &&
            element.course == task.course &&
            element.startTime == task.startTime &&
            element.endTime == task.endTime;
      });
      if (index == -1) {
        throw Exception('No task found');
      } else {
        tasks[index] = Task(
          field: task.field,
          stage: task.stage,
          course: task.course,
          startTime: task.startTime,
          endTime: task.endTime,
          color: task.color,
          icon: task.icon,
          state: state,
        );
        await FirebaseFirestore.instance.collection('users').doc(id).update({
          'tasklists': FieldValue.arrayRemove([
            tasklist,
          ])
        });
        await FirebaseFirestore.instance.collection('users').doc(id).update({
          'tasklists': FieldValue.arrayUnion([
            {
              'date': date.toString(),
              'tasks': tasks.map((task) {
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
  }
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
Future<TaskList> fetchTaskList(String id) async {
  final description =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  final descriptionData = description.data();
  final tasklists = descriptionData!['tasklists'];
  final tasklist = tasklists.firstWhere((element) {
    return element['date'] ==
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );
  }, orElse: () {
    return null;
  });
  if (tasklist == null) {
    throw Exception('No tasklist found');
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
    return TaskList(
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      tasks: tasks,
    );
  }
}

Future<List<TaskList>?> fetchScheduledTasks(
    String ID, List<Field> learn) async {
  // turn this field list to json
  final fields = learn.map((field) {
    final courses = [];
    field.stages.forEach((stage) {
      stage.courses.forEach((course) {
        courses.add({"name": course.name});
      });
    });
    return {
      'name': field.name,
      'courses': courses,
    };
  }).toList();
  // json to string
  try {
    // create a list of task in order
    List<Task> tasks_unscheduled = [];
    learn.forEach((field) {
      field.stages.forEach((stage) {
        stage.courses.forEach((course) {
          tasks_unscheduled.add(Task(
            field: field.name,
            stage: stage.name,
            course: course.name,
            startTime: DateTime.now(),
            endTime: DateTime.now(),
            state: TaskState.todo.index,
          ));
        });
      });
    });
    final fields_json = jsonEncode(fields);
    OpenAI.apiKey = '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';
    final response = await OpenAI.instance.chat.create(
      model: 'gpt-3.5-turbo',
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: schedulePrompt(fields_json, tasks_unscheduled.length),
          role: OpenAIChatMessageRole.user,
        ),
      ],
      maxTokens: 2000,
    );
    if (response.choices.isEmpty) {
      throw Exception('No response from OpenAI');
    }
    debugPrint(response.choices.first.message.content);
    /*
Create object LearningProgress from List<Field> learn: 
- the List<LearningField> fields corresponding to List<Field> learn
- in each element in fields, its element name equal to the name of each corresponding element in learn
- in each element in courses, its element name equal to the name of each corresponding element in the same field
- each done in course is false 
*/
    List<LearningField> learningField = learn.map<LearningField>((field) {
      return LearningField(
          name: field.name,
          progress: 0,
          courses: field.stages.map<LearningCourse>((stage) {
            return LearningCourse(name: stage.name, done: false);
          }).toList());
    }).toList();
    final learningProgress = LearningProgress(fields: learningField);
    // update learingProgress to firestore: in the collection users, in the document with ID equal to input ID, update object learningProgress, or create if not exist
    await FirebaseFirestore.instance.collection('users').doc(ID).update({
      'learningProgress': learningProgress.toJson(),
    });

    final result = response.choices.first.message.content;
    // iterate through each line in result, each line is a task
    List<TaskList> schedule = [];
    // get current_date with time = 0:00
    DateTime current_date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    TaskList day_list = TaskList(date: current_date, tasks: []);
    int task_count = 0;
    result.split('\n').forEach((line) {
      if (line != '') {
        if (line == '.') {
          if (day_list.tasks.isNotEmpty) schedule.add(day_list);
          current_date = current_date.add(Duration(days: 1));
          day_list.date = current_date;
          day_list.tasks = [];
        } else if (line.codeUnitAt(0) >= 48 && line.codeUnitAt(0) <= 57) {
          // separate line into index as int, start time, end time as DateTime with date equal current_date, and hour is in the line
          final index = int.parse(line.split(' ')[0]);
          final start_time = DateTime(
            current_date.year,
            current_date.month,
            current_date.day,
            int.parse(line.split(' ')[1].split(':')[0]),
            int.parse(line.split(' ')[1].split(':')[1]),
          );
          final end_time = DateTime(
            current_date.year,
            current_date.month,
            current_date.day,
            int.parse(line.split(' ')[2].split(':')[0]),
            int.parse(line.split(' ')[2].split(':')[1]),
          );
          // find the task in tasks_unscheduled with index equal to index
          final task = tasks_unscheduled[index];
          // set start time and end time of task to start_time and end_time
          task.startTime = start_time;
          task.endTime = end_time;
          // add task to day_list
          day_list.tasks.add(task);
          task_count++;
        }
      }
    });
    if (task_count != tasks_unscheduled.length) {
      throw Exception(
          'Tasks are not fully processed (some tasks are missing)! Expected: ' +
              tasks_unscheduled.length.toString() +
              ', Actual: ' +
              task_count.toString() +
              '.');
    }

    return schedule;
  } catch (e) {
    throw Exception('Invalid response from OpenAI: ' + e.toString());
  }
}
