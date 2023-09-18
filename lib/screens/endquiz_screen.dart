import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codev/helpers/notification_service.dart';
import 'package:codev/helpers/style.dart';
import 'package:codev/main.dart';
import 'package:codev/providers/progress.dart';
import 'package:codev/providers/tasks.dart';
import 'package:codev/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/user.dart';

class EndQuiz extends StatefulWidget {
  static const routeName = '/end-quiz';

  @override
  State<StatefulWidget> createState() => _EndQuiz();
}

class _EndQuiz extends State<EndQuiz> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  Future<int> updateAndGetProgressStatus(Task task) async {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    await cancelPendingNotificationRequestsWithTag(task).then((value) async {
      if (value) {
        print("Notification deleted");
        deleteNotificationFromFirestore(userId, task);
      }
    });
    
    await setTaskState(
      userId,
      task,
      TaskState.completed.index,
    );
    return await fetchLearningProgressToToggleCourseDone(
        userId, task.field, task.course);
  }

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<Auth>(context, listen: false).userId;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      if (value.exists) {
        final user = User.fromJson(value.data()!);
        user.point++;
        user.updateUser(userId);
      }
    });

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    offset = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(0.0, -0.85))
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

    final args = ModalRoute.of(context)!.settings.arguments as Task;

    return Scaffold(
      backgroundColor: FigmaColors.sUNRISESunray,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: deviceSize.width,
            height: deviceSize.height,
          ),
          SlideTransition(
            position: offset,
            child: SizedBox(
              width: deviceSize.width * 0.63,
              height: deviceSize.width * 0.63,
              child: const Image(
                image: AssetImage('assets/img/wow_cat.png'),
              ),
            ),
          ),
          Positioned(
            top: safeHeight * 0.37,
            child: Column(
              children: [
                Container(
                  width: deviceSize.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF77CC3B),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  padding: EdgeInsets.fromLTRB(
                      deviceSize.width * 0.05,
                      deviceSize.width * 0.05,
                      deviceSize.width * 0.05,
                      deviceSize.width * 0.05),
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
                          "${args.course}",
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
                          child: FutureBuilder<int>(
                            future: updateAndGetProgressStatus(args),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CircleProgressBar(
                                  foregroundColor: Color(0xFFFFFFB017),
                                  backgroundColor:
                                      FigmaColors.sUNRISELightCoral,
                                  strokeWidth: 20,
                                  value: snapshot.data! / 100,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${snapshot.data}%",
                                      style: FigmaTextStyles.h4.copyWith(
                                          color: FigmaColors.sUNRISEWhite),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                print(snapshot.error);
                                return Text("${snapshot.error}");
                              }

                              // By default, show a loading spinner.
                              return const CircularProgressIndicator();
                            },
                          ),
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
                          "${args.field}",
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4E9C16),
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                          deviceSize.width * 0.9, deviceSize.height * 0.075),
                      backgroundColor: const Color(0xFF77CC3B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Text(
                      "Great!",
                      style: FigmaTextStyles.buttons
                          .copyWith(color: FigmaColors.sUNRISEWhite),
                    ),
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
