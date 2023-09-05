import 'package:codev/helpers/style.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;

    return Scaffold(
        body: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.6,
                  height: safeHeight * 0.25,
                  child: const Image(
                      image: AssetImage('assets/img/cute_eagle_confusing.png')),
                ),
                SizedBox(
                  width: deviceSize.width * 0.05,
                  height: deviceSize.width * 0.05,
                ),
                SizedBox(
                  width: 300,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "There is something going wrong..",
                        style: FigmaTextStyles.b
                            .copyWith(color: FigmaColors.sUNRISEDarkCharcoal),
                      )),
                ),
                SizedBox(
                  width: deviceSize.width * 0.05,
                  height: deviceSize.width * 0.05,
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    minimumSize: const Size(327, 50), //////// HERE
                  ),
                  child: Text(
                    "Continue",
                    style: FigmaTextStyles.mButton.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            )));
  }
}
