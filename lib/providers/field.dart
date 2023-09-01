import 'course.dart';
import 'package:flutter/material.dart';

class Stage {
  final String name;
  final List<Course> courses;

  Stage({
    required this.name,
    required this.courses,
  });

  Course findByName(String name) {
    return courses.firstWhere((element) => element.name == name);
  }
}

class Field {
  final String name;
  final List<Stage> stages;

  Field({
    required this.name,
    required this.stages,
  });
}

class FieldList {
  List<Field> fields = [];

  Field findByName(String name) {
    return fields.firstWhere((element) => element.name == name);
  }
}
