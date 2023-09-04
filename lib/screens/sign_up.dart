import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../providers/auth.dart';
import '../helpers/style.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';

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
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                    hintStyle: FigmaTextStyles.b,
                    labelStyle: FigmaTextStyles.b,
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                TextFormField(
                  style: FigmaTextStyles.b.copyWith(
                    color: FigmaColors.sUNRISECharcoal,
                  ),
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintStyle: FigmaTextStyles.b,
                    labelStyle: FigmaTextStyles.b,
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
                    errorStyle: FigmaTextStyles.mP.copyWith(
                      color: FigmaColors.sUNRISEErrorRed,
                    ),
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.05),
                Center(
                  child: SizedBox(
                    width: deviceSize.width * 0.8,
                    height: deviceSize.height * 0.07,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Create Account",
                          style: FigmaTextStyles.mButton,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
