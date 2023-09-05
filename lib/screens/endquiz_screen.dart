import 'package:codev/helpers/style.dart';
import 'package:codev/providers/progress.dart';
import 'package:flutter/material.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:provider/provider.dart';

class EndQuiz extends StatefulWidget {
  static const routeName = '/end-quiz';

  @override
  State<StatefulWidget> createState() => _EndQuiz();
}

class _EndQuiz extends State<EndQuiz> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  int updateAndGetProgressStatus(String field, String course) {
    Provider.of<LearningProgress>(context, listen: false).toggleCourseDone(field, course);
    Provider.of<LearningField>(context, listen: false).updateProgress();
    return Provider.of<LearningField>(context, listen: false).progress;
  }

  @override
  void initState() {
    super.initState();
    
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    offset = Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(0.0, -0.85))
        .animate(controller);

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        switch (controller.status) {
          case AnimationStatus.completed:
            controller.reverse();
            break;
          case AnimationStatus.dismissed:
            controller.forward();
            break;
          default:
            controller.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: deviceSize.width,
                height: deviceSize.height,
              ),
              SlideTransition(
                position: offset, 
                child: Positioned(
                  top: safeHeight * 0.097,
                  child: SizedBox(
                    width: deviceSize.width * 0.63,
                    height: deviceSize.width * 0.63,
                    child: const Image(
                      image: AssetImage('assets/img/wow_cat.png'),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: safeHeight * 0.37,
                child: Column(children: [
                  Container(
                    width: deviceSize.width * 0.85,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF77CC3B),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    padding: EdgeInsets.fromLTRB(
                        deviceSize.width * 0.042,
                        deviceSize.width * 0.042,
                        deviceSize.width * 0.042,
                        deviceSize.width * 0.042),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "You have completed",
                            style: FigmaTextStyles.mB
                                .copyWith(color: FigmaColors.sUNRISEWhite),
                          ),
                        ),
                        SizedBox(
                          height: safeHeight * 0.007,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${args['lesson']}",
                            style: FigmaTextStyles.mH1
                                .copyWith(color: FigmaColors.sUNRISEWhite),
                          ),
                        ),
                        SizedBox(
                          height: safeHeight * 0.007,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "And",
                            style: FigmaTextStyles.mB
                                .copyWith(color: FigmaColors.sUNRISEWhite),
                          ),
                        ),
                        SizedBox(
                          height: safeHeight * 0.007,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: deviceSize.width * 0.26,
                            width: deviceSize.width * 0.26,
                            child: CircleProgressBar(
                                foregroundColor: Color(0xFFFFFFB017),
                                backgroundColor: Colors.black12,
                                strokeWidth: 20,
                                value: 0.66,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "66%", // should be change into "${updateAndGetProgressStatus(args['field'], args['course'])}"
                                    style: FigmaTextStyles.h4.copyWith(color: FigmaColors.sUNRISEWhite),
                                  ), 
                                )),
                          ),
                        ),
                        SizedBox(
                          height: safeHeight * 0.007,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "On",
                            style: FigmaTextStyles.mB
                                .copyWith(color: FigmaColors.sUNRISEWhite),
                          ),
                        ),
                        SizedBox(
                          height: safeHeight * 0.007,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${args['field']}",
                            style: FigmaTextStyles.mH1
                                .copyWith(color: FigmaColors.sUNRISEWhite),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: safeHeight * 0.04,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                          deviceSize.width * 0.85, deviceSize.height * 0.06),
                      backgroundColor: const Color(0xFF77CC3B),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                          elevation: 7,
                    ),
                    child: Text("Done",
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISEWhite)),
                  ),
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
