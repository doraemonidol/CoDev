import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          chapters: course['chapters'].map((chapter) {
            return Chapter(
              name: chapter['name'],
              description: chapter['description'],
              sources: chapter['sources'],
              estimateTime: chapter['estimateTime'],
              prerequisiteChapters:
                  chapter['prerequisiteChapters'].map((prerequisiteChapter) {
                return findByName(prerequisiteChapter);
              }).toList(),
            );
          }).toList(),
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
