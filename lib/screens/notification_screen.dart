import 'package:codev/providers/tasks.dart';
import 'package:flutter/material.dart';
import 'package:codev/icon/my_icons.dart';
import 'package:codev/icon/tick_icons.dart';
import 'package:codev/helpers/style.dart';
import 'package:intl/intl.dart';


class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification-screen';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Task> card=[
  Task(
    field: "Math",
    stage: "Beginner",
    course: "Calculus III",
    startTime: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      11,
      30,
    ),
    endTime: DateTime(
      DateTime.now().year,
      DateTime.now().month,
  DateTime.now().day,
  12,
  30,
  ),
    color: Color(0xFFFF7A7B),
    icon: MyIcons.robot,
    state: 1,
  ),
    Task(
      field: "Math",
      stage: "Beginner",
      course: "Calculus III",
      startTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        11,
        30,
      ),
      endTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        12,
        30,
      ),
      color: Color(0xFFFF7A7B),
      icon: MyIcons.robot,
      state: 1,
    ),
  ];

  double val = 50;
  String? value;
  Size? deviceSize;
  double? safeHeight;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    safeHeight = deviceSize!.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: FigmaTextStyles.mButton,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: FigmaColors.sUNRISELightCoral,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < card.length; i++)
              part(i),
          ],
        ),
      ),
    );
  }

  Widget part(int i) => Center(
    child: Expanded(
      child: Container(
        width: deviceSize!.width*0.85,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
        decoration: BoxDecoration(
          color: FigmaColors.sUNRISEWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            top: BorderSide(color: card[i].color, width: 1),
            right: BorderSide(color: card[i].color, width: 1),
            bottom: BorderSide(color: card[i].color, width: 1),
            left: BorderSide(color: card[i].color, width: 5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3),
                Row(
                  children: [
                    Icon(card[i].icon, color: card[i].color),
                    SizedBox(width: 10),
                    Text(
                      '${DateFormat('h:mm a').format(card[i].startTime)} - ${DateFormat('h:mm a').format(card[i].endTime)}',
                      style:
                      FigmaTextStyles.mT.copyWith(color: FigmaColors.systemGrey),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  card[i].course,
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style:
                  FigmaTextStyles.sButton.copyWith(color: Color(0xFF242736)),
                ),
                SizedBox(height: 5),
                Text(
                  card[i].field + ' | ' + card[i].stage,
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style:
                  FigmaTextStyles.mT.copyWith(color: FigmaColors.sUNRISETextGrey),
                ),
                SizedBox(height: 5),
              ],
            ),
          IconButton(
            onPressed: (){},
            icon: Icon(
              Tick.warning_circle,
              color: FigmaColors.sUNRISEErrorRed,
              size: deviceSize!.width*0.05,
            ),
          ),
          ],
        ),
      ),
    ),
  );
}
