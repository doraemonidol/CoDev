import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class RewardScreen extends StatefulWidget {
  static const routeName = '/reward-screen';

  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  Size? deviceSize;
  double? safeHeight;
  int isCompleted = 0; //tasks
  int stage = 0; //in the cycle

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

  Future<void> _completeLesson() async {
    if (isCompleted < 3) {
      setState(() {
        // isCompleted++;
      });
    } else if (isCompleted == 3) {
      setState(() {
        isCompleted = 0; // Reset
        stage++;
      });

      setState(() {
        initialImages = List<String>.generate(
          3,
              (index) => 'assets/images/image ${index + 1}.png',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Widget widget = Scaffold(
      backgroundColor: FigmaColors.sUNRISESunray,
      appBar: AppBar(
        title: Text(
          'Reward',
          style: FigmaTextStyles.mButton,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [
          Center(
            child: Container(
              width: deviceSize.width*0.9,
              height: deviceSize.height*0.13,
              decoration: BoxDecoration(
                color:FigmaColors.sUNRISEWhite,
                border: Border.all(
                  color: Color(0xFFFDD563),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
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
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.asset(
                        isCompleted >= index + 1
                            ? 'assets/images/image 15.png'
                            : 'assets/images/image 7.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
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
                SizedBox(height: deviceSize.height*0.15),
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
                          'assets/images/${(isCompleted == 3 && stage == 0) || (stage > 0)? 'eggs' : 'black_eggs'}.png',
                          width: deviceSize.width * 0.55,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Positioned(
                        left: deviceSize.width * 0.5,
                        top: deviceSize.height * 0.115,
                        child: Image.asset(
                          'assets/images/${(isCompleted == 3 && stage == 1) || (stage > 1)? 'cater' : 'black_cater'}.png',
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
                          'assets/images/${(isCompleted == 3 && stage == 3) ? 'butterfly' : 'black_butterfly'}.png',
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
    _completeLesson();
    return widget;
    }
  }

