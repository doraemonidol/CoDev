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
  int timeZone;
  int point;

  User({
    this.authToken = '',
    this.userId = '',
    this.phone = 'Unknown',
    this.email = 'Unknown',
    this.name = 'Unknown',
    this.location = 'Unknown',
    this.imageUrl =
        'https://upload.wikimedia.org/wikipedia/vi/b/b1/1989Deluxe.jpeg',
    this.timeZone = 0,
    this.point = 0,
  }) {
    if (authToken == '') return;
    fetchAndSetUser();
    //print(userId);
  }

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
      print(response.body);
      if (extractedData == null) {
        return;
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addUser(String email) async {
    print('adding user');
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({}),
      );

      print(response.body);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateUser({
    String? newEmail,
    String? newPhoneNumber,
    String? newName,
    String? newAddress,
    String? newImageUrl,
  }) async {
    final url =
        'https://codev-cs-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';

    newEmail = newEmail == null ? email : newEmail;
    newPhoneNumber = newPhoneNumber == null ? phone : newPhoneNumber;
    newName = newName == null ? name : newName;
    newAddress = newAddress == null ? location : newAddress;
    newImageUrl = newImageUrl == null ? imageUrl : newImageUrl;

    await http.patch(
      Uri.parse(url),
      body: json.encode({
        'email': newEmail,
        'phoneNumber': newPhoneNumber,
        'name': newName,
        'address': newAddress,
        'imageUrl': newImageUrl,
      }),
    );
    email = newEmail;
    phone = newPhoneNumber;
    name = newName;
    location = newAddress;
    imageUrl = newImageUrl;
    notifyListeners();
  }
}
