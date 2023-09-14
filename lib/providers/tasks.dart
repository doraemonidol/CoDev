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
import './course.dart';

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

  Task getCopy() {
    return Task(
      field: field,
      stage: stage,
      course: course,
      startTime: startTime,
      endTime: endTime,
      color: color,
      icon: icon,
      state: state,
    );
  }
}

class TaskList with ChangeNotifier {
  DateTime date;
  List<Task> tasks;

  TaskList({
    required this.date,
    required this.tasks,
  });

  TaskList getCopy() {
    return TaskList(
      date: date,
      tasks: tasks.map((task) => task.getCopy()).toList(),
    );
  }

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

// update schedule to firestore: in the collection users, in the document with ID equal to input ID, update object schedule with the input schedule, or create if not exist
Future<void> updateSchedule(String ID, List<TaskList> schedule) async {
  // check if exists schedule
  final description =
      await FirebaseFirestore.instance.collection('users').doc(ID).get();
  final descriptionData = description.data();
  final scheduleData = descriptionData!['schedule'];
  if (scheduleData != null) {
    await FirebaseFirestore.instance.collection('users').doc(ID).update({
      'schedule': FieldValue.delete(),
    });
  }
  await FirebaseFirestore.instance.collection('users').doc(ID).update({
    'schedule': schedule.map((taskList) {
      return {
        'date': taskList.date.toString(),
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
      };
    }).toList(),
  });
  print("added");
}

Future<List<TaskList>?> getScheduledTasks(
    String ID, List<Field> learn, IconData iconData, Color color,
    {int depth = 1}) async {
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
            color: color,
            icon: iconData,
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

    final result = response.choices.first.message.content;
    // iterate through each line in result, each line is a task
    List<TaskList> schedule = [];
    // get current_date with time = 0:00
    DateTime current_date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    DateTime getDateCopy(DateTime x) {
      return DateTime(
        x.year,
        x.month,
        x.day,
      );
    }

    ;
    TaskList day_list = TaskList(date: current_date, tasks: []);
    int task_count = 0;
    result.split('\n').forEach((line) {
      if (line != '') {
        if (line == '.') {
          if (day_list.tasks.isNotEmpty) schedule.add(day_list.getCopy());
          current_date = current_date.add(Duration(days: 1));
          day_list.date = getDateCopy(current_date);
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
          final task = tasks_unscheduled[index].getCopy();
          // set start time and end time of task to start_time and end_time
          task.startTime = start_time;
          task.endTime = end_time;
          // add task to day_list
          day_list.tasks.add(task.getCopy());
          task_count++;
        }
      }
    });
    // if final line is not ".", add day_list to schedule
    if (day_list.tasks.isNotEmpty) schedule.add(day_list.getCopy());
    if (task_count != tasks_unscheduled.length) {
      throw Exception(
          'Tasks are not fully processed (some tasks are missing)! Expected: ' +
              tasks_unscheduled.length.toString() +
              ', Actual: ' +
              task_count.toString() +
              '.');
    }
    // update learningProgress to firestore after receiving response from OpenAI
    LearningProgress? learningProgress = await fetchLearningProgress(ID);
    if (learningProgress == null) {
      List<LearningField> tmp = [];
      learningProgress = LearningProgress(fields: tmp);
    }
    List<LearningField> learningField = [];
    learn.forEach((field) {
      field.stages.forEach((stage) {
        stage.courses.forEach((course) {
          learningField.add(LearningField(
            name: field.name,
            courses: [
              LearningCourse(
                name: course.name,
                done: false,
              )
            ],
          ));
        });
      });
    });
    learningField.forEach(
      (element) {
        if (learningProgress!.isField(element) == false) {
          learningProgress.fields.add(element);
        }
      },
    );
    // check if exists learningProgress
    final description =
        await FirebaseFirestore.instance.collection('users').doc(ID).get();
    final descriptionData = description.data();
    if (descriptionData!['learningProgress'] != null) {
      await FirebaseFirestore.instance.collection('users').doc(ID).update({
        'learningProgress': FieldValue.delete(),
      });
    }
    await FirebaseFirestore.instance.collection('users').doc(ID).set({
      'learningProgress': learningProgress.toJson(),
    });
    // update schedule to firestore after receiving response from OpenAI
    updateSchedule(ID, schedule);
    print("schedule updated for user " + ID);
    return schedule;
  } catch (e) {
    print("error: " +
        e.toString() +
        " depth: " +
        depth.toString() +
        " trying again");
    if (depth <= 10) {
      return getScheduledTasks(ID, learn, iconData, color, depth: depth + 1);
    } else {
      throw Exception('Server error too many times');
    }
  }
}

// fetch scheduled tasks from firestore: in the collection users, in the document with ID equal to input ID, find object schedule, return it
Future<List<TaskList>?> fetchScheduled(String ID) async {
  final description =
      await FirebaseFirestore.instance.collection('users').doc(ID).get();
  final descriptionData = description.data();
  final schedule = descriptionData!['schedule'];
  if (schedule == null) {
    throw Exception('No schedule found');
  } else {
    final tasklists = schedule.map<TaskList>((tasklist) {
      final tasks = tasklist['tasks'].map<Task>((task) {
        return Task(
          field: task['field'],
          stage: task['stage'],
          course: task['course'],
          startTime: DateTime.parse(task['startTime']),
          endTime: DateTime.parse(task['endTime']),
          color: Color(task['color']),
          icon: IconData(task['icon'], fontFamily: 'CupertinoIcons'),
          state: task['state'],
        );
      }).toList();
      return TaskList(
        date: DateTime.parse(tasklist['date']),
        tasks: tasks,
      );
    }).toList();
    return tasklists;
  }
}

// input a schedule and a task name, push it to the next date of the schedule, that is in the tasklist with date equal to the next date, add the task to the end of the tasklist with start time equal to the end time of the last task in the tasklist, and end time equal to the start time plus 2 hours
Future<void> pushTask(
    String ID, List<TaskList> schedule, String task_name) async {
  // get current_date with time = 0:00
  DateTime current_date = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  // get next_date with time = 0:00
  DateTime next_date = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  next_date = next_date.add(Duration(days: 1));
  // find tasklist with date equal to next_date
  final tasklist = schedule.firstWhere((element) {
    return element.date == next_date;
  }, orElse: () {
    // if not found, create new tasklist with date equal to next_date
    TaskList tasklist = TaskList(date: next_date, tasks: []);
    schedule.add(tasklist);
    return tasklist;
  });
  // if tasklist is empty, the start_time is of the next_date with hour equal to 10:00
  DateTime start_time = DateTime(
    next_date.year,
    next_date.month,
    next_date.day,
    10,
  );
  // if tasklist is not empty, the start_time is of the last task in the tasklist with hour equal to the end_time of the last task
  if (tasklist.tasks.isNotEmpty) {
    start_time = tasklist.tasks.last.endTime;
  }
  DateTime end_time = start_time.add(Duration(hours: 2));
  // get field, stage, course of new task
  String field = '';
  String stage = '';
  String course = '';
  schedule.forEach((taskList) {
    taskList.tasks.forEach((task) {
      if (task.course == task_name) {
        field = task.field;
        stage = task.stage;
        course = task.course;
      }
    });
  });
  // create new task
  final new_task = Task(
    field: field,
    stage: stage,
    course: course,
    startTime: start_time,
    endTime: end_time,
    state: TaskState.todo.index,
  );
  // add new task to tasklist
  tasklist.tasks.add(new_task);
  // update schedule to firestore
  await updateSchedule(ID, schedule);
}

Future<List<TaskList>?> addFieldToSchedule(
    String ID, Field field, IconData iconData, Color color) async {
  try {
    final schedule = await fetchScheduled(ID);
    // create a list of field, iterate throught each task in schedule, if the field of the task is not in the list, add it to the list, then add that course to the field
    List<Field> fields = [];
    fields.add(field);
    schedule!.forEach((taskList) {
      taskList.tasks.forEach((task) {
        final exist_field =
            fields.firstWhere((element) => task.field == element.name);
        if (exist_field == null) {
          fields.add(Field(name: task.field, stages: []));
        }
        final exist_stage = fields
            .firstWhere((element) => task.field == element.name)
            .stages
            .firstWhere((element) => task.stage == element.name);
        if (exist_stage == null) {
          fields
              .firstWhere((element) => task.field == element.name)
              .stages
              .add(Stage(name: task.stage, courses: []));
        }
        fields
            .firstWhere((element) => task.field == element.name)
            .stages
            .firstWhere((element) => task.stage == element.name)
            .courses
            .add(Course(
              name: task.course,
              description: '',
              prerequisiteCourses: [],
            ));
      });
    });
    return await getScheduledTasks(ID, fields, iconData, color);
  } catch (e) {
    print(e);
  }
}
