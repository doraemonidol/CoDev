import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:codev/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import './user.dart' as CoDevUser;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime? _expiryDate = null;
  String _userId = '';
  Timer? _authTimer = null;

  Auth() {
    //SharedPreferences.setMockInitialValues({});
  }

  bool get isAuth {
    print('isAuth: ${token != ''}');
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
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC8LIjb-vxYyM1nHU4WMwjDyOOGiFlTqWM';
    try {
      await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      )
      .then((response) async {
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
        _autoLogout(context);
        if (urlSegment == 'signUp') {
          Provider.of<CoDevUser.User>(context, listen: false).addUser(email);
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
        prefs.setString('codev_auth', userData);
      })
      .onError((error, stackTrace) => throw error.toString());
    } catch (error) {
      rethrow;
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
    if (!prefs.containsKey('codev_auth')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('codev_auth')!);
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

  Future<firebase.UserCredential> _signInWithGoogle(context) async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication auth = await user!.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      firebase.UserCredential user_cres =  await firebase.FirebaseAuth.instance.signInWithCredential(credential);
      String? _token_ = await firebase.FirebaseAuth.instance.currentUser!.getIdToken();
      _token = _token_!;
      _userId = firebase.FirebaseAuth.instance.currentUser!.uid;
      _expiryDate = DateTime.now().add(
        const Duration(
          minutes: 55,
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('codev_auth', userData);
      Navigator.of(context).pushNamed(MainScreen.routeName);
      return user_cres;
    } catch (e) {
      throw "Process to log in with Google failed. Error: $e";
    }
  }

  Future<void> signInWithGoogle(context) async {
    _signInWithGoogle(context).then((value) async {
    });
  }
}
