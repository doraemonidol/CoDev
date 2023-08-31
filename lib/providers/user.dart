import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

class User with ChangeNotifier {
  String email;
  String phoneNumber;
  String name;
  String address;
  String imageUrl;
  String authToken;
  String userId;

  User({
    this.authToken = '',
    this.userId = '',
    this.email = 'Unknown',
    this.phoneNumber = 'Unknown',
    this.name = 'You Guys',
    this.address = 'Unknown',
    this.imageUrl =
        'https://upload.wikimedia.org/wikipedia/vi/b/b1/1989Deluxe.jpeg',
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
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';

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
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';
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
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';

    newEmail = newEmail == null ? email : newEmail;
    newPhoneNumber = newPhoneNumber == null ? phoneNumber : newPhoneNumber;
    newName = newName == null ? name : newName;
    newAddress = newAddress == null ? address : newAddress;
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
    phoneNumber = newPhoneNumber;
    name = newName;
    address = newAddress;
    imageUrl = newImageUrl;
    notifyListeners();
  }
}
