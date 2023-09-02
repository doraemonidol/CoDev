import 'package:flutter/material.dart';

class LearningChapter with ChangeNotifier {
  final String name;
  bool done = false;

  LearningChapter({
    required this.name,
    this.done = false,
  });

  void toggleDone() {
    done = !done;
    notifyListeners();
  }
}

class LearningCourse with ChangeNotifier {
  final String name;
  bool done = false;
  List<LearningChapter> chapters = [];

  LearningCourse({
    required this.name,
    this.done = false,
    this.chapters = const [],
  });

  LearningChapter findChapterByName(String name) {
    return chapters.firstWhere((element) => element.name == name);
  }

  void toggleDone() {
    done = !done;
    notifyListeners();
  }
}

class LearningField with ChangeNotifier {
  final String name;
  int progress = 0;
  List<LearningCourse> courses = [];

  LearningField({
    required this.name,
    this.progress = 0,
    this.courses = const [],
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
          'chapters': course.chapters.map((chapter) {
            return {
              'name': chapter.name,
              'done': chapter.done,
            };
          }).toList(),
        };
      }).toList(),
    };
  }
}

class LearningProgress with ChangeNotifier {
  List<LearningField> fields = [];

  LearningProgress({
    this.fields = const [],
  });

  LearningField findFieldByName(String name) {
    return fields.firstWhere((element) => element.name == name);
  }

  void addField(String name) {
    fields.add(
      LearningField(
        name: name,
        courses: [],
      ),
    );
    notifyListeners();
  }

  void toggleChapterDone(String field, String course, String chapter) {
    final fieldIndex = fields.indexWhere((element) => element.name == field);
    final courseIndex = fields[fieldIndex]
        .courses
        .indexWhere((element) => element.name == course);
    final chapterIndex = fields[fieldIndex]
        .courses[courseIndex]
        .chapters
        .indexWhere((element) => element.name == chapter);
    fields[fieldIndex].courses[courseIndex].chapters[chapterIndex].toggleDone();
    notifyListeners();
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
            chapters: course['chapters'].map((chapter) {
              return LearningChapter(
                name: chapter['name'],
                done: chapter['done'],
              );
            }).toList(),
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
}
