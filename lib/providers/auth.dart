import 'dart:convert';
import 'dart:io';
import 'dart:async';

import './user.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime? _expiryDate = null;
  String _userId = '';
  Timer? _authTimer = null;

  Auth() {
    //SharedPreferences.setMockInitialValues({});
  }

  bool get isAuth {
    //print('isAuth: ${token != ''}');
    //return true;
    return token != '';
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String urlSegment,
      BuildContext context) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBR0zZipvqvGfMfrigt-8JGoU0k-w84gmI';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout(context!);
      if (urlSegment == 'signUp') {
        Provider.of<User>(context!, listen: false).addUser(email);
      }
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('1989data', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(
      String email, String password, BuildContext context) async {
    return _authenticate(email, password, 'signUp', context);
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    return _authenticate(email, password, 'signInWithPassword', context);
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout(BuildContext context) {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () => logout());
  }

  Future<bool> tryAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('1989data')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('1989data')!);
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    //Provider.of<User>(context, listen: false).fetchAndSetUser();
    _autoLogout(context);
    return true;
  }
}
