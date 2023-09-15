import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './field.dart';
import './course.dart';

class LearningCourse with ChangeNotifier {
  final String name;
  bool done = false;
  int point;

  LearningCourse({
    required this.name,
    this.done = false,
    this.point = 0,
  });

  void toggleDone() {
    done = !done;
    notifyListeners();
  }

  void setDone(bool state) {
    done = state;
    notifyListeners();
  }
}

class LearningField with ChangeNotifier {
  final String name;
  int progress = 0;
  List<LearningCourse> courses;

  LearningField({
    required this.name,
    this.progress = 0,
    required this.courses,
  });

  LearningCourse findCourseByName(String name) {
    return courses.firstWhere((element) => element.name == name);
  }

  void updateProgress() {
    int done = 0;
    courses.forEach((course) {
      if (course.done) done++;
    });
    progress = (done / courses.length * 100).round();
    notifyListeners();
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'progress': progress,
      'courses': courses.map((course) {
        return {
          'name': course.name,
          'done': course.done,
          'point': course.point,
        };
      }).toList(),
    };
  }
}

class LearningProgress with ChangeNotifier {
  List<LearningField> fields = [];

  LearningProgress({
    required this.fields,
  });

  LearningField findFieldByName(String name) {
    return fields.firstWhere((element) => element.name == name);
  }

  void addField(Field field) {
    fields.add(
      LearningField(
        name: field.name,
        courses: field.stages[0].courses
            .map((course) => LearningCourse(
                  name: course.name,
                  point: 0,
                ))
            .toList(),
      ),
    );
    notifyListeners();
  }

  bool isField(LearningField field) {
    return fields.any((element) => element.name == field.name);
  }

  void toggleCourseDone(String field, String course) {
    final fieldIndex = fields.indexWhere((element) => element.name == field);
    final courseIndex = fields[fieldIndex]
        .courses
        .indexWhere((element) => element.name == course);
    fields[fieldIndex].courses[courseIndex].toggleDone();
    notifyListeners();
  }

  //fromjson
  LearningProgress.fromJson(Map<String, dynamic> json) {
    fields = json['fields'].map((field) {
      return LearningField(
        name: field['name'],
        progress: field['progress'],
        courses: field['courses'].map((course) {
          return LearningCourse(
            name: course['name'],
            done: course['done'],
            point: course['point'] ?? 0,
          );
        }).toList(),
      );
    }).toList();
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'fields': fields.map((field) {
        return field.toJson();
      }).toList(),
    };
  }

  // update to firestore: in the collection users, in the document with ID equal to input ID, update object LearningProgress
  Future<void> updateLearningProgress(String ID) async {
    await FirebaseFirestore.instance.collection('users').doc(ID).update({
      'learningProgress': toJson(),
    });
  }
}

// fetch LearningProgress from firestore: in the collection users, in the document with ID equal to input ID, get object LearningProgress
Future<LearningProgress?> fetchLearningProgress(String ID) async {
  final description =
      await FirebaseFirestore.instance.collection('users').doc(ID).get();
  final descriptionData = description.data();
  if (descriptionData!['learningProgress'] == null) return null;
  final learningProgress = descriptionData!['learningProgress'];
  List<LearningField> tmp = [];
  LearningProgress progress = LearningProgress(fields: tmp);
  learningProgress['fields'].forEach((field) {
    List<LearningCourse> tmp1 = [];
    LearningField learningField = LearningField(
      name: field['name'],
      progress: field['progress'],
      courses: tmp1,
    );
    field['courses'].forEach((course) {
      LearningCourse learningCourse = LearningCourse(
        name: course['name'],
        done: course['done'],
        point: course['point'] ?? 0,
      );
      learningField.courses.add(learningCourse);
    });
    progress.fields.add(learningField);
  });
  return progress;
}

// fetch LearningProgress from firestore: in the collection users, in the document with ID equal to input ID, get object LearningProgress to update done of a LearningCourse
Future<int> fetchLearningProgressToToggleCourseDone(
    String ID, String field, String course) async {
  final description =
      await FirebaseFirestore.instance.collection('users').doc(ID).get();
  final descriptionData = description.data();
  if (descriptionData!['learningProgress'] == null) return -1;
  final learningProgress = descriptionData!['learningProgress'];
  List<LearningField> tmp = [];
  LearningProgress progress = LearningProgress(fields: tmp);
  learningProgress['fields'].forEach((field) {
    List<LearningCourse> tmp1 = [];
    LearningField learningField = LearningField(
      name: field['name'],
      progress: field['progress'],
      courses: tmp1,
    );
    field['courses'].forEach((course) {
      LearningCourse learningCourse = LearningCourse(
        name: course['name'],
        done: course['done'],
        point: course['point'] ?? 0,
      );
      learningField.courses.add(learningCourse);
    });
    progress.fields.add(learningField);
  });
  final fieldIndex =
      progress.fields.indexWhere((element) => element.name == field);
  final courseIndex = progress.fields[fieldIndex].courses
      .indexWhere((element) => element.name == course);
  progress.fields[fieldIndex].courses[courseIndex].setDone(true);
  progress.fields[fieldIndex].updateProgress();
  progress.fields[fieldIndex].courses[courseIndex].point = 10;
  await FirebaseFirestore.instance.collection('users').doc(ID).update({
    'learningProgress': progress.toJson(),
  });
  return progress.fields[fieldIndex].progress;
}

// fetch LearningProgress from firestore: in the collection users, in the document with ID equal to input ID, get object LearningProgress to update point of a LearningCourse
Future<int> fetchLearningProgressToSetPoint(
    String ID, String field, String course, int point) async {
  print(point);
  final description =
      await FirebaseFirestore.instance.collection('users').doc(ID).get();
  final descriptionData = description.data();
  if (descriptionData!['learningProgress'] == null) return -1;
  final learningProgress = descriptionData!['learningProgress'];
  List<LearningField> tmp = [];
  LearningProgress progress = LearningProgress(fields: tmp);
  learningProgress['fields'].forEach((field) {
    List<LearningCourse> tmp1 = [];
    LearningField learningField = LearningField(
      name: field['name'],
      progress: field['progress'],
      courses: tmp1,
    );
    field['courses'].forEach((course) {
      LearningCourse learningCourse = LearningCourse(
        name: course['name'],
        done: course['done'],
        point: course['point'] ?? 0,
      );
      learningField.courses.add(learningCourse);
    });
    progress.fields.add(learningField);
  });
  final fieldIndex =
      progress.fields.indexWhere((element) => element.name == field);
  final courseIndex = progress.fields[fieldIndex].courses
      .indexWhere((element) => element.name == course);
  print(fieldIndex);
  print(courseIndex);
  progress.fields[fieldIndex].courses[courseIndex].point =
      max(point, progress.fields[fieldIndex].courses[courseIndex].point);
  await FirebaseFirestore.instance.collection('users').doc(ID).update({
    'learningProgress': progress.toJson(),
  });
  return progress.fields[fieldIndex].courses[courseIndex].point;
}

// fetch LearningProgress from firestore: in the collection users, in the document with ID equal to input ID, to get point of a LearningCourse
Future<int> fetchLearningProgressToGetPoint(
    String ID, String field, String course) async {
  final description =
      await FirebaseFirestore.instance.collection('users').doc(ID).get();
  final descriptionData = description.data();
  if (descriptionData!['learningProgress'] == null) return -1;
  final learningProgress = descriptionData!['learningProgress'];
  List<LearningField> tmp = [];
  LearningProgress progress = LearningProgress(fields: tmp);
  learningProgress['fields'].forEach((field) {
    List<LearningCourse> tmp1 = [];
    LearningField learningField = LearningField(
      name: field['name'],
      progress: field['progress'],
      courses: tmp1,
    );
    field['courses'].forEach((course) {
      LearningCourse learningCourse = LearningCourse(
        name: course['name'],
        done: course['done'],
        point: course['point'] ?? 0,
      );
      learningField.courses.add(learningCourse);
    });
    progress.fields.add(learningField);
  });
  final fieldIndex =
      progress.fields.indexWhere((element) => element.name == field);
  final courseIndex = progress.fields[fieldIndex].courses
      .indexWhere((element) => element.name == course);
  print(fieldIndex);
  print(courseIndex);
  return progress.fields[fieldIndex].courses[courseIndex].point;
}
