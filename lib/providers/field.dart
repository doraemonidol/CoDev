import 'course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stage {
  final String name;
  final List<Course> courses;

  Stage({
    required this.name,
    required this.courses,
  });
  Stage getCopy() {
    return Stage(
      name: name,
      courses: courses.map((course) => course.getCopy()).toList(),
    );
  }
}

class Field {
  final String name;
  final List<Stage> stages;

  Field({
    required this.name,
    required this.stages,
  });
  Field getCopy() {
    return Field(
      name: name,
      stages: stages.map((stage) => stage.getCopy()).toList(),
    );
  }
}

// fetch the field from firestore: in the collection Roadmap, in the document with ID dflfL6TOgEzFGzoQUI9n, an array object named "fields", find in it the object has "name" equal to input name
Future<Field> fetchField(String name) async {
  final description = await FirebaseFirestore.instance
      .collection('Roadmap')
      .doc('dflfL6TOgEzFGzoQUI9n')
      .get();
  final descriptionData = description.data();
  final fields = descriptionData!['fields'];
  final field = fields.firstWhere((element) => element['name'] == name);
  final stages = field['stages'];
  final stageList = stages.map<Stage>((stage) {
    final courses = stage['courses'];
    final courseList = courses.map<Course>((course) {
      return Course(
        name: course['name'],
        description: course['description'],
        prerequisiteCourses: [],
      );
    }).toList();
    return Stage(
      name: stage['name'],
      courses: courseList,
    );
  }).toList();
  return Field(
    name: field['name'],
    stages: stageList,
  );
}

// fetch the whole field list from firestore: in the collection Roadmap, in the document with ID dflfL6TOgEzFGzoQUI9n, an array object named "fields"
Future<List<Field>> fetchFieldList() async {
  final description = await FirebaseFirestore.instance
      .collection('Roadmap')
      .doc('dflfL6TOgEzFGzoQUI9n')
      .get();
  final descriptionData = description.data();
  final fields = descriptionData!['fields'];
  final fieldList = fields.map<Field>((field) {
    final stages = field['stages'];
    final stageList = stages.map<Stage>((stage) {
      final courses = stage['courses'];
      final courseList = courses.map<Course>((course) {
        return Course(
          name: course['name'],
          description: course['description'],
          prerequisiteCourses: [],
        );
      }).toList();
      return Stage(
        name: stage['name'],
        courses: courseList,
      );
    }).toList();
    return Field(
      name: field['name'],
      stages: stageList,
    );
  }).toList();
  return fieldList;
}
