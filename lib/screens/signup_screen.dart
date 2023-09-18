import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codev/providers/sign_in_info.dart';
import 'package:codev/providers/user.dart';
import 'package:codev/screens/main_screen.dart';
import 'package:codev/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../helpers/style.dart';

enum Status { SUCESS, EMAIL_EXISTS, INVALID_EMAIL, ELSE }

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  String? email;

  SignUpScreen(this.email);

  @override
  State<StatefulWidget> createState() => _SignUpScreen(email);
}

class _SignUpScreen extends State<SignUpScreen> {
  final emailReader = TextEditingController();
  final passwordReader = TextEditingController();
  String? email;

  _SignUpScreen(this.email);

  @override
  void initState() {
    emailReader.text = email!;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailReader.dispose();
    passwordReader.dispose();
  }

  Future<bool> _showErrorDialog(String message) async {
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred!', style: FigmaTextStyles.h3),
        content: Text(message, style: FigmaTextStyles.p),
        actions: [
          TextButton(
            child: Text('Retry', style: FigmaTextStyles.mButton),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          if (message ==
              'This email address is already in use. Signin instead?')
            TextButton(
              child: Text('Signin', style: FigmaTextStyles.mButton),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '👋',
                      style: FigmaTextStyles.h1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Getting Started",
                          style: FigmaTextStyles.h3.copyWith(
                            color: FigmaColors.sUNRISECharcoal,
                          ),
                        ),
                        SizedBox(height: deviceSize.height * 0.005),
                        Text(
                          "Create an account to continue!",
                          style: FigmaTextStyles.p.copyWith(
                            color: FigmaColors.sUNRISETextGrey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: deviceSize.height * 0.05),
                TextFormField(
                  style: FigmaTextStyles.b.copyWith(
                    color: FigmaColors.sUNRISECharcoal,
                  ),
                  controller: emailReader,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                    hintStyle: FigmaTextStyles.b,
                    labelStyle: FigmaTextStyles.b,
                    floatingLabelStyle: FigmaTextStyles.b,
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                TextFormField(
                  style: FigmaTextStyles.b.copyWith(
                    color: FigmaColors.sUNRISECharcoal,
                  ),
                  controller: passwordReader,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintStyle: FigmaTextStyles.b,
                    labelStyle: FigmaTextStyles.b,
                    floatingLabelStyle: FigmaTextStyles.b,
                    errorStyle: FigmaTextStyles.mP.copyWith(
                      color: FigmaColors.sUNRISEErrorRed,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value?.length)! < 6
                      ? 'Password must be at least 6 characters long'
                      : null,
                ),
                SizedBox(height: deviceSize.height * 0.02),
                TextFormField(
                  style: FigmaTextStyles.b.copyWith(
                    color: FigmaColors.sUNRISECharcoal,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintStyle: FigmaTextStyles.b,
                    labelStyle: FigmaTextStyles.b,
                    floatingLabelStyle: FigmaTextStyles.b,
                    errorStyle: FigmaTextStyles.mP.copyWith(
                      color: FigmaColors.sUNRISEErrorRed,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value! == passwordReader.text)
                      ? null
                      : "Password doesn't match",
                ),
                SizedBox(height: deviceSize.height * 0.05),
                Center(
                  child: SizedBox(
                      width: deviceSize.width * 0.8,
                      height: deviceSize.height * 0.07,
                      child: ChangeNotifierProvider<User>(
                        create: (context) => User(),
                        child: ElevatedButton(
                            onPressed: () async {
                              bool noError = true;
                              await Provider.of<Auth>(context, listen: false)
                                  .signup(
                                emailReader.text,
                                passwordReader.text,
                                context,
                              )
                                  .onError((error, stackTrace) {
                                noError = false;
                                print('error catched');
                                print(error);
                                //await player.resume();
                                var errorMessage = 'Authentication failed';
                                if (error.toString().contains('EMAIL_EXISTS')) {
                                  errorMessage =
                                      'This email address is already in use. Signin instead?';
                                } else if (error
                                    .toString()
                                    .contains('INVALID_EMAIL')) {
                                  errorMessage =
                                      'This is not a valid email address';
                                } else if (error
                                    .toString()
                                    .contains('WEAK_PASSWORD')) {
                                  errorMessage = 'This password is too weak.';
                                } else if (error
                                    .toString()
                                    .contains('EMAIL_NOT_FOUND')) {
                                  errorMessage =
                                      'Could not find a user with that email.';
                                } else if (error
                                    .toString()
                                    .contains('INVALID_PASSWORD')) {
                                  errorMessage = 'Invalid password.';
                                }
                                _showErrorDialog(errorMessage).then((value) {
                                  if (value == true) {
                                    print('signin');
                                    Provider.of<SignUpProvider>(context,
                                            listen: false)
                                        .init();
                                  }
                                });
                                return;
                              });
                              if (noError) {
                                print('no error');
                                Provider.of<SignUpProvider>(context,
                                        listen: false)
                                    .init();
                              }
                            },
                            child: Text(
                              "Create Account",
                              style: FigmaTextStyles.mButton,
                            )),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
