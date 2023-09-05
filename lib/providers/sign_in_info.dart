import 'package:flutter/material.dart';

class SignInProvider extends ChangeNotifier {
  String email = "";

  String password = "";

  static const int FIRST_AUTH_SCREEN = 0;

  static const int SECOND_AUTH_SCREEN = 1;

  int status = FIRST_AUTH_SCREEN;

  void changeAuthScreen() {
    if (status == FIRST_AUTH_SCREEN) {
      status = SECOND_AUTH_SCREEN;
      notifyListeners();
    }
  }

  int getStatus() {
    return status;
  }

  void receiveEmail(email) {
    this.email = email;
  }

  void receivePassword(password) {
    this.password = password;
  }

}