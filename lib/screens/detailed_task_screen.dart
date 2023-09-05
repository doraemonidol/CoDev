import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codev/providers/tasks.dart';
import 'package:codev/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:codev/icon/my_icons.dart';
import 'package:intl/intl.dart';

class DetailedTaskScreen extends StatefulWidget {
  static const routeName = '/detailed-task-screen';
  const DetailedTaskScreen({super.key});

  @override
  State<DetailedTaskScreen> createState() => _DetailedTaskScreenState();
}

class _DetailedTaskScreenState extends State<DetailedTaskScreen> {
  Task? task;
  double val = 50;
  String? value;
  Size? deviceSize;
  double? safeHeight;

  @override
  Widget build(BuildContext context) {
    this.task = ModalRoute.of(context)!.settings.arguments as Task;
    deviceSize = MediaQuery.of(context).size;
    safeHeight = deviceSize!.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Details',
          style: FigmaTextStyles.mButton,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: FigmaColors.sUNRISELightCoral,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Dropdown menu item and edit button
            firstPart(),
            SizedBox(height: 20),

            // // Card Information
            secondPart(),
            SizedBox(height: 20),

            // // Card Timer
            thirdPart(),

            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: val / 120,
                  minHeight: 36,
                  backgroundColor: Colors.white,
                  // change color of progress bar as val increase
                  valueColor: AlwaysStoppedAnimation<Color>(Color.lerp(
                      Color.lerp(Colors.red, Colors.yellow, val / 100),
                      Color.lerp(Colors.yellow, Colors.green, val / 100),
                      val / 100)!),
                  borderRadius: BorderRadius.circular(12),
                ),
                Text(
                  '${val.toInt()}% completed',
                  style: FigmaTextStyles.mH4.copyWith(
                    color: FigmaColors.systemDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(QuizScreen.routeName, arguments: task!);
              },
              style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF2FD1C5)),
              iconSize: 60,
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Study now!',
              style: FigmaTextStyles.mButton.copyWith(color: Color(0xFF00394C)),
            )
          ],
        ),
      ),
    );
  }

  Widget firstPart() => Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFC4D7FF),
                      width: 2,
                    )),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      focusColor: Colors.white,
                      value: task!.state == 0
                          ? 'To Do'
                          : task!.state == 1
                              ? 'In Progress'
                              : 'Completed',
                      iconSize: 36,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_sharp,
                          color: Color(0xFF585A66)),
                      items: TaskState.values
                          .map((e) => buildMenuItem(e == TaskState.todo
                              ? 'To Do'
                              : e == TaskState.inProgress
                                  ? 'In Progress'
                                  : 'Completed'))
                          .toList(),
                      onChanged: (value) => setState(() => this.value = value)),
                ),
              ),
            ),
            Container(
              width: 48,
              height: 48,
              padding: EdgeInsets.all(0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: FigmaColors.sUNRISEBluePrimary,
              ),
              child: IconButton(
                icon: const Icon(Icons.border_color, color: Colors.white),
                onPressed: () {},
              ),
            )
          ],
        ),
      );

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: SelectableText(
          item,
          style: FigmaTextStyles.p.copyWith(color: FigmaColors.sUNRISETextGrey),
        ),
      );

  Widget secondPart() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: FigmaColors.sUNRISEWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            top: BorderSide(color: task!.color, width: 1),
            right: BorderSide(color: task!.color, width: 1),
            bottom: BorderSide(color: task!.color, width: 1),
            left: BorderSide(color: task!.color, width: 5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(task!.icon, color: task!.color),
            SizedBox(height: 16),
            SelectableText(task!.chapter,
                style:
                    FigmaTextStyles.h3.copyWith(color: FigmaColors.systemDark)),
            Text(
              task!.field + ' | ' + task!.course,
              maxLines: 20,
              overflow: TextOverflow.ellipsis,
              style:
                  FigmaTextStyles.mH4.copyWith(color: FigmaColors.systemGrey),
            ),
            SizedBox(height: 16),
            // output description
          ],
        ),
      );

  Widget thirdPart() {
    return Container(
      width: double.infinity,
      height: 99,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: FigmaColors.sUNRISEWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: FigmaColors.lightblue, width: 1.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 26),
              Text.rich(
                TextSpan(
                  text: 'Due. ',
                  style: FigmaTextStyles.mP
                      .copyWith(color: FigmaColors.sUNRISEDarkGrey),
                  children: [
                    TextSpan(
                      text: task!.startTime.difference(DateTime.now()).inDays ==
                              0
                          ? 'Today, ${DateFormat('EEEE d').format(task!.startTime)}'
                          : DateFormat('EEEE, MMMM d').format(task!.startTime),
                      style: FigmaTextStyles.mB14
                          .copyWith(color: FigmaColors.sUNRISETextGrey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              //output start time and end time in this format 11:30 AM - 12:30 PM
              Text(
                '${DateFormat('h:mm a').format(task!.startTime)} - ${DateFormat('h:mm a').format(task!.endTime)}',
                style:
                    FigmaTextStyles.mT.copyWith(color: FigmaColors.systemGrey),
              ),
            ],
          ),
          buildTimer(),
        ],
      ),
    );
  }

  Widget buildTimer() => SizedBox(
        width: deviceSize!.width * 0.175,
        height: deviceSize!.width * 0.175,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: task!.endTime.difference(DateTime.now()).inSeconds / 1000,
              strokeWidth: 6,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFB017)),
              backgroundColor: const Color(0xFFE4EDFF),
            ),
            Center(child: buildTime()),
          ],
        ),
      );

  Widget buildTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer, color: Color(0xFF2FD1C5), size: 20),
        FittedBox(
          child: Text(
              // output time left
              task!.endTime.difference(DateTime.now()).inSeconds < 0
                  ? '0 s'
                  : (task!.endTime.difference(DateTime.now()).inHours != 0
                      ? '${task!.endTime.difference(DateTime.now()).inHours}h ${task!.endTime.difference(DateTime.now()).inMinutes.remainder(60)}m'
                      : (task!.endTime.difference(DateTime.now()).inMinutes != 0
                          ? '${task!.endTime.difference(DateTime.now()).inMinutes}m ${task!.endTime.difference(DateTime.now()).inSeconds.remainder(60)}s'
                          : '${task!.endTime.difference(DateTime.now()).inSeconds} s')),
              style: FigmaTextStyles.mT
                  .copyWith(color: FigmaColors.sUNRISETextGrey)),
        ),
      ],
    );
  }
}
