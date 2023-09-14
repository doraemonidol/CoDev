import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Course with ChangeNotifier {
  final String name;
  final String description;
  final List<Course> prerequisiteCourses;
  final List<String> links = [];
  Course({
    required this.name,
    required this.description,
    required this.prerequisiteCourses,
  });
  Course getCopy() {
    return Course(
      name: name,
      description: description,
      prerequisiteCourses: prerequisiteCourses,
    );
  }
}
