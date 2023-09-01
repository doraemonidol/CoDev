import 'package:flutter/material.dart';

class Chapter {
  final String name;
  final String description;
  final List<String> sources;
  final int estimateTime;
  final List<Chapter> prerequisiteChapters;

  Chapter({
    required this.name,
    required this.description,
    required this.sources,
    required this.estimateTime,
    required this.prerequisiteChapters,
  });
}

class Course with ChangeNotifier {
  final String name;
  final String description;
  final List<Chapter> chapters;
  final List<Course> prerequisiteCourses;

  Course({
    required this.name,
    required this.description,
    required this.chapters,
    required this.prerequisiteCourses,
  });

  Chapter findByName(String name) {
    return chapters.firstWhere((element) => element.name == name);
  }
}

class CourseList with ChangeNotifier {
  final List<Course> courses;

  CourseList({
    required this.courses,
  });

  Course findByName(String name) {
    return courses.firstWhere((c) => c.name == name);
  }
}
