import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import 'profile_screen.dart';
import 'agenda_screen.dart';
import 'notification_screen.dart';
import 'tasks_screen.dart';

enum pages {
  agenda,
  tasks,
  homeButton,
  notification,
  personal,
}

class TabsScreen extends StatefulWidget {
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  int _prevSelectedPageIndex = 0;

  void _selectPage(int index) async {
    setState(() {
      if (index == _selectedPageIndex) {
        if (index == 2) {
          _selectedPageIndex = _prevSelectedPageIndex;
        }
      } else {
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
    'Personal',
  ];
  Stack get bottomNavigationBar {
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
                    height: index == _selectedPageIndex ? 60 : 48,
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
                                  ? Theme.of(context).colorScheme.primary
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
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
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

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    // Provider.of<User>(context, listen: false);
    return DefaultTabController(
      length: 5,
      child: switch (pages.values[_selectedPageIndex]) {
        pages.agenda => Scaffold(
            body: AgendaScreen(),
            extendBody: true,
            bottomNavigationBar: bottomNavigationBar,
          ),
        pages.tasks => Scaffold(
            body: TasksScreen(),
            extendBody: true,
            bottomNavigationBar: bottomNavigationBar,
          ),
        pages.homeButton => Scaffold(
            body: Stack(
              children: <Widget>[
                PageView.builder(itemBuilder: (context, pos) {
                  return Stack(
                    children: <Widget>[
                      _prevSelectedPageIndex == 0
                          ? AgendaScreen()
                          : _prevSelectedPageIndex == 1
                              ? TasksScreen()
                              : _prevSelectedPageIndex == 3
                                  ? NotificationScreen()
                                  : ProfileScreen(),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                          bottom: displayWidth * 0.22,
                        ),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            extendBody: true,
            bottomNavigationBar: bottomNavigationBar,
          ),
        pages.notification => Scaffold(
            body: NotificationScreen(),
            extendBody: true,
            bottomNavigationBar: bottomNavigationBar,
          ),
        pages.personal => Scaffold(
            body: ProfileScreen(),
            extendBody: true,
            bottomNavigationBar: bottomNavigationBar,
          ),
      },
    );
  }
}
