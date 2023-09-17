import 'dart:ui';
import 'package:codev/helpers/notification_service.dart';
import 'package:codev/providers/auth.dart';
import 'package:codev/providers/tasks.dart';
import 'package:codev/screens/new_lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/structure.dart';
import '../helpers/style.dart';

import '../providers/user.dart';

import 'detailed_task_screen.dart';
import 'profile_screen.dart';
import 'agenda_screen.dart';
import 'notification_screen.dart';
import 'tasks_screen.dart';

enum pages {
  agenda,
  tasks,
  notification,
  personal,
}

final pageStack = MyStack<int>();
int _selectedPageIndex = 0;
int _prevSelectedPageIndex = 0;

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  void _selectPage(int index) async {
    setState(() {
      if (index == _selectedPageIndex) {
        if (index == 2) {
          _selectedPageIndex = _prevSelectedPageIndex;
        }
      } else {
        pageStack.push(index);
        print(pageStack);
        _prevSelectedPageIndex = _selectedPageIndex;
        _selectedPageIndex = index;
      }
    });
  }

  @override
  void initState() {
    _selectedPageIndex = 0;
    _prevSelectedPageIndex = 0;
    while (!pageStack.isEmpty) pageStack.pop();
    pageStack.push(0);
  }

  AppBar customizedAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: FigmaTextStyles.mButton,
      ),
      centerTitle: true,
      backgroundColor: FigmaColors.sUNRISESunray,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: pageStack.length > 1
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                pageStack.pop();
                _selectPage(pageStack.peek);
                pageStack.pop();
                //Navigator.of(context).pushReplacementNamed('/');
              },
              color: FigmaColors.sUNRISEBluePrimary,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    // Provider.of<User>(context, listen: false);
    return DefaultTabController(
      length: 5,
      child: switch (pages.values[_selectedPageIndex > 1
          ? _selectedPageIndex - 1
          : _selectedPageIndex]) {
        pages.agenda => Scaffold(
            appBar: customizedAppBar('Agenda'),
            body: AgendaScreen(),
            extendBody: true,
            bottomNavigationBar:
                CustomBottomNavigatorBar(selectPage: _selectPage),
          ),
        pages.tasks => Scaffold(
            appBar: customizedAppBar('Tasks'),
            body: TasksScreen(),
            extendBody: true,
            bottomNavigationBar:
                CustomBottomNavigatorBar(selectPage: _selectPage),
          ),
        pages.notification => Scaffold(
            backgroundColor: FigmaColors.sUNRISESunray,
            appBar: customizedAppBar('Notification'),
            body: NotificationScreen(),
            extendBody: true,
            bottomNavigationBar:
                CustomBottomNavigatorBar(selectPage: _selectPage),
          ),
        pages.personal => Scaffold(
            appBar: customizedAppBar('Profile'),
            body: ProfileScreen(),
            extendBody: true,
            bottomNavigationBar:
                CustomBottomNavigatorBar(selectPage: _selectPage),
          ),
      },
    );
  }
}

class CustomBottomNavigatorBar extends StatefulWidget {
  Function selectPage;

  CustomBottomNavigatorBar({required this.selectPage});

  @override
  State<CustomBottomNavigatorBar> createState() =>
      _CustomBottomNavigatorBarState(
        selectPage: selectPage,
      );
}

class _CustomBottomNavigatorBarState extends State<CustomBottomNavigatorBar> {
  Function selectPage;

  _CustomBottomNavigatorBarState({
    required this.selectPage,
  });

  void _selectPage(int index) async {
    setState(() {
      if (index == _selectedPageIndex) {
        if (index == 2) {
          _selectedPageIndex = _prevSelectedPageIndex;
        }
      } else {
        pageStack.push(index);
        print(pageStack);
        _prevSelectedPageIndex = _selectedPageIndex;
        _selectedPageIndex = index;
      }
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    IconData icon,
    String label,
  ) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).colorScheme.background,
      icon: Icon(icon),
      label: label,
    );
  }

  List<IconData> listOfIcons = [
    Icons.calendar_month_outlined,
    Icons.work_outline_rounded,
    Icons.dataset_outlined,
    Icons.notifications_outlined,
    Icons.person_outline,
  ];

  List<String> listOfStrings = [
    'Agenda',
    'Tasks',
    '',
    'Notification',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1.0,
                  sigmaY: 1.0,
                ),
                child: Container(
                    width: double.maxFinite,
                    height: displayWidth * .180,
                    color: Colors.black.withOpacity(0)))),
        Container(
          margin: EdgeInsets.all(displayWidth * .03),
          height: displayWidth * .160,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(displayWidth * .015),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                _selectPage(index);
                if (index == 2) {
                  showGeneralDialog(
                    barrierLabel: "Label",
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 500),
                    context: context,
                    pageBuilder: (context, anim1, anim2) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                          bottom: displayWidth * 0.22,
                        ),
                        child: Container(
                          width: displayWidth * 0.7,
                          height: 150,
                          decoration: BoxDecoration(
                            color: FigmaColors.sUNRISESunray,
                            border: Border.all(
                              width: 1,
                              color: FigmaColors.lightblue,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await fetchTaskList(
                                        Provider.of<Auth>(context,
                                                listen: false)
                                            .userId,
                                      ).then((taskList) {
                                        final currentTask =
                                            taskList.tasks.indexWhere(
                                          (element) =>
                                              element.startTime
                                                  .isBefore(DateTime.now()) &&
                                              element.endTime.isAfter(
                                                DateTime.now(),
                                              ),
                                        );
                                        if (currentTask != -1) {
                                          Navigator.pushNamed(
                                            context,
                                            DetailedTaskScreen.routeName,
                                            arguments:
                                                taskList.tasks[currentTask],
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                'No current task',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FigmaTextStyles.h4.copyWith(
                                                  color: FigmaColors
                                                      .sUNRISEErrorRed,
                                                ),
                                              ),
                                              content: Text(
                                                'You have no task to start right now',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FigmaTextStyles.p.copyWith(
                                                  color: FigmaColors
                                                      .sUNRISETextGrey,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Ok',
                                                    style: FigmaTextStyles
                                                        .mButton
                                                        .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.play_circle_outlined,
                                    ),
                                    label: Text('Start current task'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        FigmaColors.sUNRISEWhite,
                                      ),
                                      textStyle:
                                          MaterialStateProperty.all<TextStyle>(
                                        FigmaTextStyles.mP,
                                      ),
                                      iconColor:
                                          MaterialStateProperty.all<Color>(
                                        // FigmaColors.sUNRISEWaves,
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        // FigmaColors.sUNRISEWaves,
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              side: BorderSide(
                                                  color:
                                                      FigmaColors.lightblue))),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(context,
                                              NewLessonScreen.routeName)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    },
                                    icon:
                                        Icon(Icons.add_circle_outline_rounded),
                                    label: Text('Learn something new'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        FigmaColors.sUNRISEWhite,
                                      ),
                                      textStyle:
                                          MaterialStateProperty.all<TextStyle>(
                                        FigmaTextStyles.mP,
                                      ),
                                      iconColor:
                                          MaterialStateProperty.all<Color>(
                                        // FigmaColors.sUNRISEWaves,
                                        FigmaColors.sUNRISEBluePrimary,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        // FigmaColors.sUNRISEWaves,
                                        FigmaColors.sUNRISEBluePrimary,
                                      ),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              side: BorderSide(
                                                  color:
                                                      FigmaColors.lightblue))),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    transitionBuilder: (context, anim1, anim2, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                            .animate(anim1),
                        child: child,
                      );
                    },
                  ).then((value) {
                    _selectPage(_selectedPageIndex);
                  });
                } else
                  selectPage(index);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == _selectedPageIndex
                        ? displayWidth * .1816 //268 16
                        : displayWidth * .1816,
                    height: index == _selectedPageIndex ? 60 : 60,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                            ),
                            Icon(
                              listOfIcons[index],
                              size: index == 2
                                  ? displayWidth * .12
                                  : displayWidth * .076,
                              color: index == _selectedPageIndex
                                  ? FigmaColors.sUNRISEBluePrimary
                                  : Colors.black26,
                            ),
                          ],
                        ),
                        index == 2 || index != _selectedPageIndex
                            ? Container()
                            : Column(
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        index == _selectedPageIndex ? 1 : 0,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: Text(
                                      index == _selectedPageIndex
                                          ? '${listOfStrings[index]}'
                                          : '',
                                      style: FigmaTextStyles.mP.copyWith(
                                        color: FigmaColors.sUNRISEBluePrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
