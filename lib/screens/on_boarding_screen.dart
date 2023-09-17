import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codev/providers/auth.dart';
import 'package:codev/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:provider/provider.dart';

import '../widgets/radio_button.dart';

class OnBoardingScreen extends StatefulWidget {
  static const routeName = '/on-boarding-screen';
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _value = 0;
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: FigmaColors.sUNRISESunray,
          ),
          Positioned(
            top: deviceSize.height * 0.075,
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height * 0.925,
              padding: EdgeInsets.only(
                top: deviceSize.width * 0.1,
                left: deviceSize.width * 0.1,
                right: deviceSize.width * 0.1,
                bottom: deviceSize.width * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Education Level',
                        style: FigmaTextStyles.h3
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                      ),
                      SizedBox(height: deviceSize.height * 0.025),
                      Text(
                        'To personalize your learning experience, we\'d like to know more about your education level in the field of Information Technology.',
                        style: FigmaTextStyles.mP
                            .copyWith(color: FigmaColors.sUNRISETextGrey),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceSize.height * 0.025),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          MyRadioListTile<int>(
                            value: 1,
                            groupValue: _value,
                            imageUrl: 'assets/images/ob_1.png',
                            text: 'Year 7-9',
                            borderColor: Color(0xFFFDD563),
                            onChanged: (value) =>
                                setState(() => _value = value!),
                          ),
                          SizedBox(height: 16),
                          MyRadioListTile<int>(
                            value: 2,
                            groupValue: _value,
                            imageUrl: 'assets/images/ob_2.png',
                            text: 'Year 10-11',
                            borderColor: Color(0xFF8BE38B),
                            onChanged: (value) =>
                                setState(() => _value = value!),
                          ),
                          SizedBox(height: 16),
                          MyRadioListTile<int>(
                            value: 3,
                            groupValue: _value,
                            imageUrl: 'assets/images/ob_3.png',
                            text: 'Year 12-13',
                            borderColor: Color(0xFFB3B4F7),
                            onChanged: (value) =>
                                setState(() => _value = value!),
                          ),
                          SizedBox(height: 16),
                          MyRadioListTile<int>(
                            value: 4,
                            groupValue: _value,
                            imageUrl: 'assets/images/ob_4.png',
                            text: 'Bachelors',
                            borderColor: FigmaColors.lightblue,
                            onChanged: (value) =>
                                setState(() => _value = value!),
                          ),
                          SizedBox(height: 16),
                          MyRadioListTile<int>(
                            value: 5,
                            groupValue: _value,
                            imageUrl: 'assets/images/ob_5.png',
                            text: 'Masters',
                            borderColor: FigmaColors.sUNRISEWaves,
                            onChanged: (value) =>
                                setState(() => _value = value!),
                          ),
                          SizedBox(height: 16),
                          MyRadioListTile<int>(
                            value: 6,
                            groupValue: _value,
                            imageUrl: 'assets/images/ob_6.png',
                            text: 'Worked',
                            borderColor: FigmaColors.sUNRISEErrorRed,
                            onChanged: (value) =>
                                setState(() => _value = value!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'Continue',
                          style: FigmaTextStyles.mButton.copyWith(
                            color: _value == 0
                                ? FigmaColors.lightblue
                                : FigmaColors.sUNRISEBluePrimary,
                          ),
                        ),
                        onPressed: () async {
                          if (_value != 0) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .update({
                              'educationLevel': _value == 1
                                  ? 'Year 7-9'
                                  : _value == 2
                                      ? 'Year 10-11'
                                      : _value == 3
                                          ? 'Year 12-13'
                                          : _value == 4
                                              ? 'Bachelors'
                                              : _value == 5
                                                  ? 'Masters'
                                                  : 'Worked',
                            });
                            Provider.of<Auth>(context, listen: false)
                                .setFirstTime(false);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
