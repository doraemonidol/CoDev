import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class RewardScreen extends StatefulWidget {
  static const routeName = '/reward-screen';
  final int point;
  const RewardScreen({Key? key, required this.point}) : super(key: key);

  @override
  State<RewardScreen> createState() => _RewardScreenState(point: point);
}

class _RewardScreenState extends State<RewardScreen> {
  Size? deviceSize;
  double? safeHeight;
  int isCompleted = 1; //tasks
  int stage = 0; //in the cycle
  final int point;
  _RewardScreenState({required this.point});

  @override
  void initState() {
    isCompleted = point % 3;
    stage = point ~/ 3;
    super.initState();
  }

  List<String> initialImages = [
    'assets/images/image 7.png',
    'assets/images/image 7.png',
    'assets/images/image 7.png',
  ];

  List<String> updatedImages = [
    'assets/images/image 15.png',
    'assets/images/image 15.png',
    'assets/images/image 15.png',
  ];

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: FigmaColors.sUNRISESunray,
      appBar: AppBar(
        title: Text(
          'Reward',
          style: FigmaTextStyles.mButton,
        ),
        centerTitle: true,
        backgroundColor: FigmaColors.sUNRISESunray,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: deviceSize.width * 0.05,
                  right: deviceSize.width * 0.05,
                ),
                child: Text(
                  'You have completed $point tasks! Complete ${3 - isCompleted} more to grow the butterfly!',
                  style: FigmaTextStyles.mButton,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: deviceSize.height * 0.01),
              Center(
                child: Container(
                  width: deviceSize.width * 0.9,
                  height: deviceSize.height * 0.13,
                  decoration: BoxDecoration(
                    color: FigmaColors.sUNRISEWhite,
                    border: Border.all(
                      color: Color(0xFFFDD563),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // onTap: () {
                        //   _completeLesson();
                        // },

                        child: Container(
                          width: deviceSize.width * 0.255,
                          height: deviceSize.width * 0.255,
                          margin: EdgeInsets.symmetric(
                              horizontal: deviceSize.width * 0.045 / 2),
                          child: isCompleted >= index + 1
                              ? Image.asset(
                                  'assets/images/image 15.png',
                                  fit: BoxFit.cover,
                                  width: deviceSize.width * 0.255,
                                  height: deviceSize.width * 0.255,
                                )
                              : Icon(
                                  CupertinoIcons.star_circle,
                                  color: Color(0xFFE5E5E5),
                                  size: deviceSize.width * 0.255,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 5),
                //     child: Image.asset(
                //       'assets/images/sun.png',
                //       width: deviceSize.width * 0.55,
                //       height: deviceSize.width * 0.55,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/branch.png',
                        width: deviceSize.width * 2.5,
                        height: deviceSize.width,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: deviceSize.width * 0.15,
                        top: deviceSize.height * 0.307,
                        child: Image.asset(
                          'assets/images/${(isCompleted == 3 && stage == 0) || (stage > 0) ? 'eggs' : 'black_eggs'}.png',
                          width: deviceSize.width * 0.55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: deviceSize.width * 0.5,
                        top: deviceSize.height * 0.115,
                        child: Image.asset(
                          'assets/images/${(isCompleted == 3 && stage == 1) || (stage > 1) ? 'cater' : 'black_cater'}.png',
                          width: deviceSize.width * 0.55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: deviceSize.width * 1.1,
                        top: deviceSize.height * 0.276,
                        child: Image.asset(
                          'assets/images/${(isCompleted == 3 && stage == 2) || (stage > 2) ? 'pupaa' : 'black_pupa'}.png',
                          width: deviceSize.width * 0.55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: deviceSize.width * 1.7,
                        //top: deviceSize.height * 0.0,
                        child: Image.asset(
                          'assets/images/${(isCompleted == 3 && stage == 3) || (stage > 3) ? 'butterfly' : 'black_butterfly'}.png',
                          width: deviceSize.width * 0.55,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
