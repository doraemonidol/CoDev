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
    } else {
      status = FIRST_AUTH_SCREEN;
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

class SignUpProvider extends ChangeNotifier {
  bool isSigningUp = false;

  void init() {
    isSigningUp = false;
  }

  void changeSigningUp() {
    isSigningUp = !isSigningUp;
    notifyListeners();
  }

  bool getIsSigningUp() {
    return isSigningUp;
  }
}
