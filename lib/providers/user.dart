import 'package:cloud_firestore/cloud_firestore.dart';

import 'progress.dart';
import 'tasks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

class User with ChangeNotifier {
  String authToken;
  String userId;
  String phone;
  String email;
  String name;
  String location;
  String imageUrl;
  String educationLevel;
  int point;
  TaskList? taskList;
  LearningProgress? learningProgress;

  User({
    this.authToken = '',
    this.userId = '',
    this.phone = 'Unknown',
    this.email = 'Unknown',
    this.name = 'Unknown',
    this.location = 'Unknown',
    this.imageUrl =
        'https://upload.wikimedia.org/wikipedia/vi/b/b1/1989Deluxe.jpeg',
    this.educationLevel = 'Unknown',
    this.point = 0,
  }) {
    if (authToken == '') return;
    fetchAndSetUser();
    //print(userId);
  }
  User copy(
          {String? imagePath,
          String? name,
          String? email,
          String? phone,
          String? location,
          String? educationLevel}) =>
      User(
        imageUrl: imagePath ?? this.imageUrl,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        location: location ?? this.location,
        educationLevel: educationLevel ?? this.educationLevel,
      );

  Map<String, dynamic> toJson() => {
        'imagePath': imageUrl,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'educationLevel': educationLevel,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        imageUrl: json['imagePath'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        location: json['location'],
        educationLevel: json['educationLevel'],
      );

  get token {
    return authToken;
  }

  Future<void> fetchAndSetUser([context]) async {
    print('fetching user');
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      // print(response.body);
      if (extractedData == null) {
        return;
      }

      email = extractedData['email'];
      phone = extractedData['phoneNumber'];
      name = extractedData['name'];
      location = extractedData['location'];
      imageUrl = extractedData['imageUrl'];
      educationLevel = extractedData['educationLevel'];
      point = extractedData['point'];

      learningProgress = LearningProgress.fromJson(extractedData['progress']);

      if (context != null) {
        taskList = Provider.of<TaskList>(context, listen: false);
        // await taskList!.fetchAndSetTaskList();
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addUser(String email, String uid, String token) async {
    print('adding user');
    userId = uid;
    authToken = token;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'phoneNumber': phone,
        'name': name,
        'location': location,
        'imageUrl': imageUrl,
        'educationLevel': educationLevel,
        'point': point,
      });

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateUserInfo({
    String? newEmail,
    String? newPhoneNumber,
    String? newName,
    String? newAddress,
    String? newImageUrl,
    String? newEducationLevel,
  }) async {
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';

    newEmail = newEmail == null ? email : newEmail;
    newPhoneNumber = newPhoneNumber == null ? phone : newPhoneNumber;
    newName = newName == null ? name : newName;
    newAddress = newAddress == null ? location : newAddress;
    newImageUrl = newImageUrl == null ? imageUrl : newImageUrl;
    newEducationLevel =
        newEducationLevel == null ? educationLevel : newEducationLevel;

    await http.patch(
      Uri.parse(url),
      body: json.encode({
        'email': newEmail,
        'phoneNumber': newPhoneNumber,
        'name': newName,
        'location': newAddress,
        'imageUrl': newImageUrl,
        'educationLevel': newEducationLevel
      }),
    );
    email = newEmail;
    phone = newPhoneNumber;
    name = newName;
    location = newAddress;
    imageUrl = newImageUrl;
    notifyListeners();
  }

  // toggle chapter done
  Future<void> updateProgress({
    fieldName = '',
    courseName = '',
    chapterName = '',
  }) async {
    learningProgress?.toggleChapterDone(fieldName, courseName, chapterName);
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId/progress/$fieldName.json?auth=$authToken';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(
          {
            'courses': {
              '$courseName': {
                'chapters': {
                  '$chapterName': {
                    'done': true,
                  }
                },
                'done': learningProgress
                    ?.findFieldByName(fieldName)
                    .findCourseByName(courseName)
                    .done,
              }
            },
            'progress': learningProgress?.findFieldByName(fieldName).progress,
          },
        ),
      );
      print(response.body);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // add new field to learning progress
  Future<void> addField(String fieldName) async {
    learningProgress?.addField(fieldName);
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId/progress/$fieldName.json?auth=$authToken';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: learningProgress?.findFieldByName(fieldName).toJson(),
      );

      print(response.body);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
