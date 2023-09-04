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
      appBar: AppBar(
        backgroundColor: FigmaColors.sUNRISEBluePrimary,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(child: SingleChildScrollView (
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(
                  "👋🏻 Getting Started",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: FigmaColors.sUNRISECharcoal,
                  ),
                ),
                Text(
                  "Create an account to continue!",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            
            ),
            Padding(padding: EdgeInsets.all(7)),
             Text("Email"),
            Padding(padding: EdgeInsets.all(3)),
             TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            Padding(padding: EdgeInsets.all(7)),
             Text("Password"),
            Padding(padding: EdgeInsets.all(3)),
             TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
            Padding(padding: EdgeInsets.all(7)),
             Text("Name"),
            Padding(padding: EdgeInsets.all(3)),
             TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
                prefixIcon: Icon(Icons.person_2_outlined),
              ),
            ),
            Padding(padding: EdgeInsets.all(7)),
             Text("Phone"),
            Padding(padding: EdgeInsets.all(3)),
             TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Phone',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
          ElevatedButton(onPressed: () {}, child: Text("Click"))
        ]),
        )
      )
    ));
  }
}