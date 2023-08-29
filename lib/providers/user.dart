import './redeem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import './cart.dart';

class User with ChangeNotifier {
  String email;
  String phoneNumber;
  String name;
  String address;
  String imageUrl;
  List<CartItem>? products;
  int loyaltyPoints;
  String authToken;
  String userId;
  Function(List<CartItem>)? updateMainCart;

  User(
      {this.authToken = '',
      this.userId = '',
      this.updateMainCart,
      this.email = 'Unknown',
      this.phoneNumber = 'Unknown',
      this.name = 'You Guys',
      this.address = 'Unknown',
      this.imageUrl =
          'https://upload.wikimedia.org/wikipedia/vi/b/b1/1989Deluxe.jpeg',
      this.loyaltyPoints = 0,
      newProduct = null}) {
    if (authToken == '') return;
    print(newProduct);
    if (newProduct != null)
      updateCart(newProduct);
    else
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

      email = extractedData['email'];
      phoneNumber = extractedData['phoneNumber'];
      name = extractedData['name'];
      address = extractedData['address'];
      imageUrl = extractedData['imageUrl'];
      products = extractedData['products'] == null
          ? []
          : extractedData['products']
              .map<CartItem>((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                    description: item['description'],
                    note: item['note'],
                  ))
              .toList();
      loyaltyPoints = extractedData['loyaltyPoints'];
      print('before update main cart');
      if (updateMainCart != null && products != null)
        updateMainCart!(products!);
      Provider.of<Redeems>(context!, listen: false)
          .setLoyaltyCount(loyaltyPoints);

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
        body: json.encode({
          'email': email,
          'phoneNumber': phoneNumber,
          'name': name,
          'address': address,
          'imageUrl': imageUrl,
          'products': products,
          'loyaltyPoints': loyaltyPoints,
        }),
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
    int? newLoyaltyPoints,
  }) async {
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';
    print(newEmail);
    print(newPhoneNumber);
    print(newName);
    print(newAddress);
    print(newImageUrl);
    print(newLoyaltyPoints);
    bool notify = true;
    if (newLoyaltyPoints != null) {
      notify = false;
    }
    newEmail = newEmail == null ? email : newEmail;
    newPhoneNumber = newPhoneNumber == null ? phoneNumber : newPhoneNumber;
    newName = newName == null ? name : newName;
    newAddress = newAddress == null ? address : newAddress;
    newImageUrl = newImageUrl == null ? imageUrl : newImageUrl;
    newLoyaltyPoints = newLoyaltyPoints == null
        ? loyaltyPoints
        : (loyaltyPoints + newLoyaltyPoints) % 7;

    print('updating user');
    print(newEmail);
    print(newPhoneNumber);
    print(newName);
    print(newAddress);
    print(newImageUrl);
    print(newLoyaltyPoints);

    await http.patch(
      Uri.parse(url),
      body: json.encode({
        'email': newEmail,
        'phoneNumber': newPhoneNumber,
        'name': newName,
        'address': newAddress,
        'imageUrl': newImageUrl,
        'products': products,
        'loyaltyPoints': newLoyaltyPoints,
      }),
    );
    email = newEmail;
    phoneNumber = newPhoneNumber;
    name = newName;
    address = newAddress;
    imageUrl = newImageUrl;
    loyaltyPoints = newLoyaltyPoints;
    if (notify) notifyListeners();
  }

  Future<void> updateCart(List<CartItem> newCart) async {
    print('updating cart');
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$authToken';
    print(newCart);
    print(json.encode({
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'address': address,
      'imageUrl': imageUrl,
      'products': newCart,
      'loyaltyPoints': loyaltyPoints,
    }));
    await http.patch(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'phoneNumber': phoneNumber,
        'name': name,
        'address': address,
        'imageUrl': imageUrl,
        'products': newCart,
        'loyaltyPoints': loyaltyPoints,
      }),
    );
    products = newCart;
    notifyListeners();
  }
}
