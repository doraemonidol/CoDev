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
        'https://firebasestorage.googleapis.com/v0/b/codev-cs.appspot.com/o/images%2FRZRiM3quwTfeDa24vmsuejRJMpK2?alt=media&token=ee459a0e-5244-47f4-8f05-decc115fe1bd',
    this.educationLevel = 'Unknown',
    this.point = 0,
  }) {}

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'name': name,
        'email': email,
        'phoneNumber': phone,
        'location': location,
        'educationLevel': educationLevel,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        imageUrl: json['imageUrl'],
        name: json['name'],
        email: json['email'],
        phone: json['phoneNumber'],
        location: json['location'],
        educationLevel: json['educationLevel'].toString(),
      );

  // add this user data to firebase, in collection users, in document with ID equal to input ID
  Future<void> addUser(String ID, String _email) async {
    await FirebaseFirestore.instance.collection('users').doc(ID).set({
      'phoneNumber': phone,
      'email': _email,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'educationLevel': educationLevel,
      'point': point,
      'tasklists': [],
    });
  }

  // update this user data to firebase, in collection users, in document with ID equal to input ID
  Future<void> updateUser(String ID) async {
    print('updateUser $ID');
    print('updateUser $phone');
    await FirebaseFirestore.instance.collection('users').doc(ID).update({
      'phoneNumber': phone,
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
    ..phone = descriptionData!['phoneNumber']
    ..email = descriptionData['email']
    ..name = descriptionData['name']
    ..location = descriptionData['location']
    ..imageUrl = descriptionData['imageUrl']
    ..educationLevel = descriptionData['educationLevel']
    ..point = descriptionData['point'];
}
