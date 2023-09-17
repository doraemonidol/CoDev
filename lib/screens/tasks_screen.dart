import 'package:codev/screens/detailed_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:codev/icon/my_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/tasks.dart';
import 'new_lesson_screen.dart';

//FigmaTextStyles.mH3.copyWith(color:FigmaColors.sUNRISELightCharcoal,
enum Actions { delete, access }

class TasksScreen extends StatefulWidget {
  static const routeName = '/tasks-screen';
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskList> list = [];
  List<PopupMenuEntry> popUpMenuList = [];
  List<String> fieldLearned = [];
  String selectedFieldFilter = 'All';

  @override
  void initState() {
    // TODO: implement initState

    popUpMenuList.add(PopupMenuItem(
      child: Text(
        'All',
        style: FigmaTextStyles.mB,
      ),
      value: 'All',
    ));
    bool _isLoading = true;
    fetchScheduled(Provider.of<Auth>(context, listen: false).userId)
        .then((taskLists) {
      if (taskLists != null) {
        taskLists.forEach((taskList) {
          taskList.tasks.forEach((task) {
            if (!fieldLearned.contains(task.field)) {
              fieldLearned.add(task.field);
              popUpMenuList.add(PopupMenuItem(
                child: Text(
                  task.field,
                  style: FigmaTextStyles.mB,
                ),
                value: task.field,
              ));
            }
          });
        });
      }
    });
  }

  void updateScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: FigmaColors.sUNRISESunray,
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                height: safeHeight * 0.065,
                decoration: BoxDecoration(
                  color: FigmaColors.sUNRISEWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: FigmaColors.sUNRISELightCoral,
                    width: 2,
                  ),
                ),
                child: TabBar(
                  padding: EdgeInsets.all(3.0),
                  unselectedLabelStyle: FigmaTextStyles.mP,
                  labelStyle: FigmaTextStyles.sButton14,
                  unselectedLabelColor: FigmaColors.sUNRISETextGrey,
                  labelColor: FigmaColors.sUNRISEWhite,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: FigmaColors.sUNRISEBluePrimary,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  tabs: [
                    Text('To Do', textAlign: TextAlign.center),
                    Text('In Progress', textAlign: TextAlign.center),
                    Text('Completed', textAlign: TextAlign.center),
                  ],
                ),
              ),
              SizedBox(height: safeHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // pop up menu button to choose filter option
                  PopupMenuButton(
                    color: FigmaColors.sUNRISEWhite,
                    itemBuilder: (context) {
                      return popUpMenuList;
                    },
                    onSelected: (value) {
                      // filter the list
                      print('value: $value');
                      selectedFieldFilter = value;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: FigmaColors.sUNRISEWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: FigmaColors.sUNRISELightCoral,
                          width: 2,
                        ),
                      ),
                      child: Icon(MyIcons.filter_variant,
                          color: FigmaColors.sUNRISELightCharcoal),
                    ),
                  ),
                  Spacer(),
                  TextButton.icon(
                    label: DefaultTextStyle(
                      style: TextStyle(color: FigmaColors.sUNRISEBluePrimary),
                      child: Text('New Lesson', style: FigmaTextStyles.mB),
                    ),
                    icon: const Icon(Icons.add,
                        color: FigmaColors.sUNRISEBluePrimary),
                    onPressed: () {
                      Navigator.pushNamed(context, NewLessonScreen.routeName)
                          .then((value) {
                        setState(() {});
                      });
                    },
                  ),
                ],
              ),
              FutureBuilder(
                future: fetchScheduled(
                    Provider.of<Auth>(context, listen: true).userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    list = snapshot.data == null
                        ? []
                        : snapshot.data as List<TaskList>;
                    if (selectedFieldFilter != 'All')
                      list = list
                          .where((element) =>
                              element.tasks
                                  .where((element) =>
                                      element.field == selectedFieldFilter)
                                  .toList()
                                  .length >
                              0)
                          .toList();
                    print(list);
                    return Expanded(
                      child: TabBarView(
                        children: [
                          Page(list, TaskState.todo, updateScreen),
                          Page(list, TaskState.inProgress, updateScreen),
                          Page(list, TaskState.completed, updateScreen),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page extends StatefulWidget {
  final List<TaskList> list;
  final TaskState curState;
  final Function updateScreen;

  const Page(this.list, this.curState, this.updateScreen, {super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    print('curState: ${widget.curState.index}');
    final List<Task> curStateTaskList = [];
    for (int i = 0; i < widget.list.length; i++) {
      print('widget.list[i].tasks.length: ${widget.list[i].tasks.length}');
      for (int j = 0; j < widget.list[i].tasks.length; j++) {
        print(
            'widget.list[i].tasks[j].state: ${widget.list[i].tasks[j].state}');
        if (widget.list[i].tasks[j].state == widget.curState.index) {
          curStateTaskList.add(widget.list[i].tasks[j]);
        }
      }
    }
    //print(curStateTaskList);
    // sort curStateTaskList by startTime
    curStateTaskList.sort((a, b) => a.startTime.compareTo(b.startTime));
    //print(curStateTaskList);
    // get list of dates (day, month, year) unique in curStateTaskList
    final List<DateTime> dates = [];
    for (int i = 0; i < curStateTaskList.length; i++) {
      if (dates.isEmpty) {
        dates.add(curStateTaskList[i].startTime);
      } else {
        bool isExist = false;
        for (int j = 0; j < dates.length; j++) {
          if (curStateTaskList[i].startTime.day == dates[j].day &&
              curStateTaskList[i].startTime.month == dates[j].month &&
              curStateTaskList[i].startTime.year == dates[j].year) {
            isExist = true;
            break;
          }
        }
        if (!isExist) {
          dates.add(curStateTaskList[i].startTime);
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dates.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 24,
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: 'Due ',
                      style: FigmaTextStyles.p
                          .copyWith(color: FigmaColors.sUNRISEDarkGrey),
                      children: <TextSpan>[
                        TextSpan(
                            text: dates[index].day == DateTime.now().day &&
                                    dates[index].month ==
                                        DateTime.now().month &&
                                    dates[index].year == DateTime.now().year
                                ? 'Today, ${DateFormat('EEEE d').format(dates[index])}'
                                : DateFormat('EEEE, MMMM d')
                                        .format(dates[index]) +
                                    (dates[index].year == DateTime.now().year
                                        ? ''
                                        : ', ${dates[index].year}'),
                            style: FigmaTextStyles.mB
                                .copyWith(color: FigmaColors.sUNRISETextGrey)),
                      ],
                    ),
                  ),
                ),
                buildCardList(
                  curStateTaskList
                      .where((element) =>
                          element.startTime.day == dates[index].day &&
                          element.startTime.month == dates[index].month &&
                          element.startTime.year == dates[index].year)
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildCardList(List<Task> list) {
    final _color = List<Color>.filled(list.length, FigmaColors.sUNRISEWhite,
        growable: true); //

    final deviceSize = MediaQuery.of(context).size;

    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: Column(
        children: List.generate(
          list.length,
          (index) {
            final Task card = list[index];
            return Slidable(
              endActionPane: ActionPane(
                extentRatio: 0.32,
                motion: const StretchMotion(),
                children: [
                  Expanded(
                    child: Container(
                      width: 48,
                      height: 48,
                      margin: EdgeInsets.only(
                        left: 6,
                        right: 3,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFFFF7A7B),
                      ),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(MyIcons.delete_outline,
                              color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 48,
                      height: 48,
                      margin: EdgeInsets.only(
                        left: 3,
                        right: 6,
                      ),
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFF2FD1C5),
                      ),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                    context, DetailedTaskScreen.routeName,
                                    arguments: card)
                                .then((value) {
                              widget.updateScreen();
                            });
                          },
                          icon: const Icon(MyIcons.play, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              child: buildCard(card, index),
            );
          },
        ),
      ),
    );
  }

  int _expandedIndex = -1;

  Widget buildCard(Task card, int index) {
    final deviceSize = MediaQuery.of(context).size;
    return Consumer<TaskList>(
      builder: (context, cart, child) => Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            //setState(() => _expandedIndex = index);
            Navigator.pushNamed(context, DetailedTaskScreen.routeName,
                    arguments: card)
                .then((value) {
              widget.updateScreen();
            });
          },
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _expandedIndex == index
                  ? Color(0xFFC4D7FF)
                  : FigmaColors.sUNRISEWhite,
              border: Border(
                top: BorderSide(color: card.color, width: 1),
                right: BorderSide(color: card.color, width: 1),
                bottom: BorderSide(color: card.color, width: 1),
                left: BorderSide(color: card.color, width: 5),
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(card.icon, color: card.color),
                          SizedBox(width: 10),
                          Text(
                              card.startTime.hour.toString() +
                                  ':' +
                                  card.startTime.minute.toString() +
                                  ' - ' +
                                  card.endTime.hour.toString() +
                                  ':' +
                                  card.endTime.minute.toString(),
                              style: FigmaTextStyles.mT
                                  .copyWith(color: FigmaColors.systemGrey)),
                        ],
                      ),
                      Text(card.course,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: FigmaTextStyles.sButton.copyWith(
                              color: FigmaColors.sUNRISELightCharcoal)),
                      Text(card.field + ' - ' + card.stage,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: FigmaTextStyles.mT
                              .copyWith(color: FigmaColors.sUNRISETextGrey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_outlined,
                      color: Color(0xFFD8DEF3)),
                  onPressed: () {
                    // show a menu with options to do the task later 1 hour / 1 day or delete the task
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        height: deviceSize.height * 0.24,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.assignment_add),
                              title: Text('Move to In Progress tab',
                                  style: FigmaTextStyles.mB),
                              iconColor: Theme.of(context).colorScheme.primary,
                              textColor: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                setTaskState(
                                  Provider.of<Auth>(context, listen: false)
                                      .userId,
                                  card,
                                  TaskState.inProgress.index,
                                ).then((value) {
                                  print('poped');
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.timer),
                              title: Text(
                                'Wait an hour',
                                style: FigmaTextStyles.mB,
                              ),
                              iconColor: Theme.of(context).colorScheme.primary,
                              textColor: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.calendar_today_rounded),
                              title: Text(
                                'I will do this tomorrow',
                                style: FigmaTextStyles.mB,
                              ),
                              iconColor: Theme.of(context).colorScheme.primary,
                              textColor: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ).then((value) {
                      print('value: $value');
                      widget.updateScreen();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
