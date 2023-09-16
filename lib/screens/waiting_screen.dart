import 'package:codev/helpers/style.dart';
import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;

    return Scaffold(
        backgroundColor: Color(0xfffcfefc),
        body: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.85,
                  height: safeHeight * 0.25,
                  child: const Image(
                      image: AssetImage('assets/img/easter-bunny.gif')),
                ),
                SizedBox(
                  width: deviceSize.width * 0.05,
                  height: deviceSize.width * 0.05,
                ),
                SizedBox(
                  width: deviceSize.width * 0.85,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Enjoy the show\nwhile we're preparing something",
                        textAlign: TextAlign.center,
                        style: FigmaTextStyles.b,
                      )),
                ),
              ],
            )));
  }
}
