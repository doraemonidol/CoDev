import 'course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Stage {
  final String name;
  final List<String> courses;

  Stage({
    required this.name,
    required this.courses,
  });
}

class Field {
  final String name;
  final List<Stage> stages;

  Field({
    required this.name,
    required this.stages,
  });
}

class FieldList with ChangeNotifier {
  List<Field> _fields = [];
  String userId;
  String token;

  FieldList({
    required this.userId,
    required this.token,
    required List<Field> fields,
  }) : _fields = fields;

  Field findByName(String name) {
    return _fields.firstWhere((element) => element.name == name);
  }

  List<Field> get fields {
    return [..._fields];
  }

  // fetch and set
  Future<void> fetchAndSetFieldList() async {
    print('fetching fieldlist');
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$token';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      // print(response.body);
      if (extractedData == null) {
        return;
      }

      _fields = extractedData['fields'].map((field) {
        return Field(
          name: field['name'],
          stages: field['stages'].map((stage) {
            return Stage(
              name: stage['name'],
              courses: stage['courses'].map((course) {
                return Course(
                  name: course['name'],
                  description: course['description'],
                  chapters: course['chapters'].map((chapter) {
                    return Chapter(
                      name: chapter['name'],
                      description: chapter['description'],
                      sources: chapter['sources'],
                      estimateTime: chapter['estimateTime'],
                      prerequisiteChapters: chapter['prerequisiteChapters']
                          .map((prerequisiteChapter) {
                        return findByName(prerequisiteChapter);
                      }).toList(),
                    );
                  }).toList(),
                  prerequisiteCourses: course['prerequisiteCourses']
                      .map((prerequisiteCourse) {
                    return findByName(prerequisiteCourse);
                  }).toList(),
                );
              }).toList(),
            );
          }).toList(),
        );
      }).toList();
    
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}