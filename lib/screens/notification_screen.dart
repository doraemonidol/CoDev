import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codev/providers/auth.dart';
import 'package:codev/providers/tasks.dart';
import 'package:flutter/material.dart';
import 'package:codev/icon/my_icons.dart';
import 'package:codev/icon/tick_icons.dart';
import 'package:codev/helpers/style.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'detailed_task_screen.dart';

enum NotificationState { read, unread }

class NotificationDetail {
  Task task;
  NotificationState status;

  NotificationDetail({
    required this.task,
    required this.status,
  });

  // add notification to firestore
  Future<void> saveNotification(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add({
      'field': task.field,
      'stage': task.stage,
      'course': task.course,
      'description': task.description,
      'startTime': task.startTime,
      'endTime': task.endTime,
      'color': task.color.value,
      'icon': task.icon.codePoint,
      'state': task.state,
      'status': status.index,
    }).then((documentSnapshot) =>
            print("Added Data with ID: ${documentSnapshot.id}"));
  }

  // update notification status to firestore
  Future<void> updateNotificationStatus(
      String userId, NotificationState newStatus) async {
    status = newStatus;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('field', isEqualTo: task.field)
        .where('stage', isEqualTo: task.stage)
        .where('course', isEqualTo: task.course)
        .where('startTime', isEqualTo: task.startTime)
        .where('endTime', isEqualTo: task.endTime)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.reference.id);
        element.reference.update({'status': newStatus.index});
      });
    });
  }
}

// delete notification from firestore with the given task
Future<void> deleteNotificationFromFirestore(String userId, Task task) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .where('field', isEqualTo: task.field)
      .where('stage', isEqualTo: task.stage)
      .where('course', isEqualTo: task.course)
      .where('startTime', isEqualTo: task.startTime)
      .where('endTime', isEqualTo: task.endTime)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      print(element.reference.id);
      element.reference.delete();
    });
  });
}

// delete notification from firestore later than the given time
Future<void> deleteNotificationFromFirestoreLaterThan(
    String userId, DateTime time) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .where('endTime', isGreaterThan: time)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      print(element.reference.id);
      element.reference.delete();
    });
  });
}

// add list of notification to firestore
Future<void> addNotificationListToFirestore(
    String userId, List<NotificationDetail> notificationList) async {
  for (int i = 0; i < notificationList.length; i++) {
    await notificationList[i].saveNotification(userId);
  }
}

// fetch the notification list from firestore: in the collection users, in the document with ID userId, an array object named "notifications"
Future<List<NotificationDetail>> fetchNotificationList(String userId) async {
  print('fetchNotificationList');
  final description = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .get();
  print('fetchNotificationList2');
  final descriptionData = description.docs;
  final notificationList = descriptionData.map<NotificationDetail>((noti) {
    return NotificationDetail(
      task: Task(
        field: noti['field'],
        stage: noti['stage'],
        course: noti['course'],
        description: noti['description'],
        startTime: noti['startTime'].toDate(),
        endTime: noti['endTime'].toDate(),
        color: Color(noti['color']),
        icon: IconData(
          noti['icon'],
          fontFamily: 'CupertinoIcons',
          fontPackage: 'cupertino_icons',
        ),
        state: noti['state'],
      ),
      status: NotificationState.values[noti['status']],
    );
  }).toList();

  //sort the notification list by time
  notificationList.sort((a, b) => a.task.startTime.compareTo(b.task.startTime));
  int begin = 0, end = -1;
  for (int i = 0; i < notificationList.length; i++) {
    print('fetching notification list: ${notificationList[i].task.course} ' +
        DateFormat('yyyy-MM-dd – kk:mm')
            .format(notificationList[i].task.startTime));
    if (notificationList[i]
        .task
        .startTime
        .subtract(Duration(minutes: 15))
        .isBefore(DateTime.now())) {
      end = i;
    } else {
      break;
    }
  }
  print('fetchNotificationList3');
  if (end == -1) {
    return [];
  }

  return notificationList.sublist(begin, end + 1).reversed.toList();
}

Future<List<NotificationDetail>> fetchNotificationListUpcoming(
    String userId) async {
  print('fetchNotificationList');
  final description = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .get();
  print('fetchNotificationList2');
  final descriptionData = description.docs;
  final notificationList = descriptionData.map<NotificationDetail>((noti) {
    return NotificationDetail(
      task: Task(
        field: noti['field'],
        stage: noti['stage'],
        course: noti['course'],
        description: noti['description'],
        startTime: noti['startTime'].toDate(),
        endTime: noti['endTime'].toDate(),
        color: Color(noti['color']),
        icon: IconData(
          noti['icon'],
          fontFamily: 'CupertinoIcons',
          fontPackage: 'cupertino_icons',
        ),
        state: noti['state'],
      ),
      status: NotificationState.values[noti['status']],
    );
  }).toList();

  //sort the notification list by time
  notificationList.sort((a, b) => a.task.startTime.compareTo(b.task.startTime));
  int begin = -1, end = notificationList.length - 1;
  for (int i = 0; i < notificationList.length; i++) {
    print('fetching notification list: ${notificationList[i].task.course} ' +
        DateFormat('yyyy-MM-dd – kk:mm')
            .format(notificationList[i].task.startTime));
    if (notificationList[i]
        .task
        .startTime
        .subtract(Duration(minutes: 15))
        .isBefore(DateTime.now())) {
      begin = i;
    } else {
      break;
    }
  }
  print('fetchNotificationList3');
  if (begin == end) {
    return [];
  }

  return notificationList.sublist(begin + 1, end + 1).reversed.toList();
}

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification-screen';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationDetail> card = [];

  @override
  void initState() {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    fetchNotificationList(userId).then((value) {
      setState(() {
        card.addAll(value);
      });
    });
    super.initState();
  }

  double val = 50;
  String? value;
  Size? deviceSize;
  double? safeHeight;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    safeHeight = deviceSize!.height - MediaQuery.of(context).padding.top;

    return Consumer<TaskList>(
      builder: (context, cart, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < card.length; i++) part(i),
          ],
        ),
      ),
    );
  }

  Widget part(int i) {
    final newCardState =
        Provider.of<TaskList>(context, listen: false).findTask(card[i].task);
    final userId = Provider.of<Auth>(context, listen: false).userId;
    if (newCardState != null) {
      card[i].task.state = newCardState.state;
    }
    final timePassed = card[i]
        .task
        .startTime
        .subtract(Duration(minutes: 15))
        .difference(DateTime.now());
    return Center(
      child: Expanded(
        child: Container(
          width: deviceSize!.width * 0.85,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
          decoration: BoxDecoration(
            color: FigmaColors.sUNRISEWhite.withOpacity(
              card[i].status == NotificationState.read ? 0.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              top: BorderSide(
                  color: card[i].task.color.withOpacity(
                        card[i].status == NotificationState.read ? 0.5 : 1,
                      ),
                  width: 1),
              right: BorderSide(
                  color: card[i].task.color.withOpacity(
                        card[i].status == NotificationState.read ? 0.5 : 1,
                      ),
                  width: 1),
              bottom: BorderSide(
                  color: card[i].task.color.withOpacity(
                        card[i].status == NotificationState.read ? 0.5 : 1,
                      ),
                  width: 1),
              left: BorderSide(
                  color: card[i].task.color.withOpacity(
                        card[i].status == NotificationState.read ? 0.5 : 1,
                      ),
                  width: 5),
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                card[i]
                    .updateNotificationStatus(userId, NotificationState.read);
              });
              Navigator.pushNamed(context, DetailedTaskScreen.routeName,
                  arguments: card[i].task);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(card[i].task.icon,
                            color: card[i].task.color.withOpacity(
                                  card[i].status == NotificationState.read
                                      ? 0.5
                                      : 1,
                                )),
                        SizedBox(width: 10),
                        Text(
                          timePassed.inDays > 1
                              ? '${timePassed.inDays} days ago'
                              : timePassed.inDays == 1
                                  ? '${timePassed.inDays} day ago'
                                  : timePassed.inHours > 1
                                      ? '${timePassed.inHours} hours ago'
                                      : timePassed.inHours == 1
                                          ? '${timePassed.inHours} hour ago'
                                          : timePassed.inMinutes > 1
                                              ? '${timePassed.inMinutes} minutes ago'
                                              : timePassed.inMinutes == 1
                                                  ? '${timePassed.inMinutes} minute ago'
                                                  : timePassed.inSeconds > 1
                                                      ? '${timePassed.inSeconds} seconds ago'
                                                      : 'Just now',
                          style: FigmaTextStyles.mT.copyWith(
                              color: FigmaColors.systemGrey.withOpacity(
                            card[i].status == NotificationState.read ? 0.5 : 1,
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      card[i].task.course,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      style: FigmaTextStyles.sButton.copyWith(
                          color: Color(0xFF242736).withOpacity(
                        card[i].status == NotificationState.read ? 0.5 : 1,
                      )),
                    ),
                    SizedBox(height: 5),
                    Text(
                      card[i].task.field + ' | ' + card[i].task.stage,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      style: FigmaTextStyles.mT.copyWith(
                          color: FigmaColors.sUNRISETextGrey.withOpacity(
                        card[i].status == NotificationState.read ? 0.5 : 1,
                      )),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: card[i].task.state == TaskState.completed.index
                      ? Icon(
                          Tick.ok_circled2,
                          color: Color(0xFF77CC3B).withOpacity(
                            card[i].status == NotificationState.read ? 0.5 : 1,
                          ),
                          size: deviceSize!.width * 0.05,
                        )
                      : Icon(
                          Tick.warning_circle,
                          color: FigmaColors.sUNRISEErrorRed.withOpacity(
                            card[i].status == NotificationState.read ? 0.5 : 1,
                          ),
                          size: deviceSize!.width * 0.05,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
