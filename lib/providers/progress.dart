import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './field.dart';
import './course.dart';

class LearningCourse with ChangeNotifier {
  final String name;
  bool done = false;

  LearningCourse({
    required this.name,
    this.done = false,
  });

  void toggleDone() {
    done = !done;
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
            .map((course) => LearningCourse(name: course.name))
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
          return LearningCourse(name: course['name'], done: course['done']);
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
      );
      learningField.courses.add(learningCourse);
    });
    progress.fields.add(learningField);
  });
  return progress;
}
