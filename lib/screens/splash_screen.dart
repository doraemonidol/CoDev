import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
