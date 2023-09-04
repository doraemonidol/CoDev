import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Course with ChangeNotifier {
  final String name;
  final String description;
  final List<Course> prerequisiteCourses;

  Course({
    required this.name,
    required this.description,
    required this.prerequisiteCourses,
  });
}

class CourseList with ChangeNotifier {
  List<Course> courses;

  CourseList({
    required this.courses,
  });

  Course findByName(String name) {
    return courses.firstWhere((c) => c.name == name);
  }

  // fetch and set
  Future<void> fetchAndSetCourseList() async {
    print('fetching courselist');
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/courses.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      // print(response.body);
      if (extractedData == null) {
        return;
      }

      courses = extractedData.map((course) {
        return Course(
          name: course['name'],
          description: course['description'],
          prerequisiteCourses:
              course['prerequisiteCourses'].map((prerequisiteCourse) {
            return findByName(prerequisiteCourse);
          }).toList(),
        );
      }).toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
