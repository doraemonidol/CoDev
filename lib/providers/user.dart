import 'package:cloud_firestore/cloud_firestore.dart';

import 'progress.dart';
import 'tasks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

class User with ChangeNotifier {
  String phone;
  String email;
  String name;
  String location;
  String imageUrl;
  String educationLevel;
  int point;

  User({
    this.phone = 'Unknown',
    this.email = 'Unknown',
    this.name = 'Unknown',
    this.location = 'Unknown',
    this.imageUrl =
        'https://upload.wikimedia.org/wikipedia/vi/b/b1/1989Deluxe.jpeg',
    this.educationLevel = 'Unknown',
    this.point = 0,
  }) {}
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

  // add this user data to firebase, in collection users, in document with ID equal to input ID
  Future<void> addUser(String ID) async {
    await FirebaseFirestore.instance.collection('users').doc(ID).set({
      'phone': phone,
      'email': email,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'educationLevel': educationLevel,
      'point': point,
      'tasklists': [],
      'learningProgress': LearningProgress().toJson(),
    });
  }

  // update this user data to firebase, in collection users, in document with ID equal to input ID
  Future<void> updateUser(String ID) async {
    await FirebaseFirestore.instance.collection('users').doc(ID).update({
      'phone': phone,
      'email': email,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'educationLevel': educationLevel,
      'point': point,
    });
  }
}

// fetch user object from firebase: in collection users, in document with ID equal to input ID
Future<User> fetchUser(String ID) async {
  final description =
      await FirebaseFirestore.instance.collection('users').doc(ID).get();
  final descriptionData = description.data();
  return User()
    ..phone = descriptionData!['phone']
    ..email = descriptionData['email']
    ..name = descriptionData['name']
    ..location = descriptionData['location']
    ..imageUrl = descriptionData['imageUrl']
    ..educationLevel = descriptionData['educationLevel']
    ..point = descriptionData['point'];
}
