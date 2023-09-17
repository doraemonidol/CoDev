import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../providers/auth.dart';
import '../providers/tasks.dart';
import '../widgets/date_picker.dart';
import '../widgets/my_seperator.dart';
import 'add_task_page.dart';
import 'package:codev/helpers/style.dart';
import 'package:dotted_border/dotted_border.dart';

import 'detailed_task_screen.dart';

class AgendaScreen extends StatefulWidget {
  static const routeName = '/agenda-screen';
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _selectedDate = DateTime.now();
  List<TaskList> taskLists = [];
  final DatePickerController _controller = DatePickerController();

  void executeAfterBuild() {
    print("executeAfterBuild");
    _controller.animateToSelection();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;
    //WidgetsBinding.instance!.addPostFrameCallback((_) => executeAfterBuild());

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future:
            fetchScheduled(Provider.of<Auth>(context, listen: false).userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            print('adsfasdf');
            taskLists = snapshot.data as List<TaskList>;
            print('done assigne');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dateSelection(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "OnGoing",
                    style: FigmaTextStyles.h4
                        .copyWith(color: FigmaColors.sUNRISEDarkCharcoal),
                  ),
                ),
                AgendaTaskList(
                    taskLists.firstWhere(
                        (taskList) =>
                            taskList.date.year == _selectedDate.year &&
                            taskList.date.month == _selectedDate.month &&
                            taskList.date.day == _selectedDate.day, orElse: () {
                      return TaskList(
                        date: _selectedDate,
                        tasks: [],
                      );
                    }).tasks,
                    _selectedDate)
              ],
            );
          }
        },
      ),
    );
  }

  Widget _dateSelection() {
    List<String> abbrMonths = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    List<String> months = [
      "January",
      "Febuary",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    WidgetsBinding.instance!.addPostFrameCallback((_) => executeAfterBuild());
    print('date selection');
    return Container(
      color: Color(0xFFF5FBFF),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedDate = _selectedDate
                        .subtract(Duration(days: _selectedDate.day)));
                    print(_selectedDate);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                          size: 15,
                        ),
                        Text(
                          abbrMonths[(_selectedDate.month + 12 - 2) % 12],
                          style: FigmaTextStyles.b
                              .copyWith(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(months[_selectedDate.month - 1],
                        style: FigmaTextStyles.h3
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal)),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => _getDateFromUser(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: FigmaColors.lightblue, width: 1),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: FigmaColors.sUNRISEBluePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedDate = _selectedDate.add(Duration(
                        days: DateUtils.getDaysInMonth(
                                _selectedDate.year, _selectedDate.month) -
                            _selectedDate.day +
                            1)));
                    print(_selectedDate);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          abbrMonths[_selectedDate.month % 12],
                          style: FigmaTextStyles.b
                              .copyWith(fontSize: 13, color: Colors.grey),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: DatePicker(
              DateTime(_selectedDate.year, _selectedDate.month, 1),
              daysCount: DateUtils.getDaysInMonth(
                  _selectedDate.year, _selectedDate.month),
              height: 105,
              width: 64,
              initialSelectedDate: _selectedDate,
              controller: _controller,
              selectionColor: FigmaColors.sUNRISEBluePrimary,
              deactivatedColor: Colors.white,
              selectedTextColor: Colors.white,
              dateTextStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: FigmaColors.systemGrey,
              ),
              dayTextStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: FigmaColors.systemGrey,
              ),
              enabledMonthText: false,
              dateChangedFromOutside: true,
              onDateChange: (date) {
                setState(() => _selectedDate = date);
                //_selectedDate = date;
              },
            ),
          )
        ],
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));
    setState(() => _selectedDate = _pickerDate!);
    //_selectedDate = _pickerDate!;
  }
}

class AgendaTaskList extends StatefulWidget {
  List<Task> selectedList = [];
  DateTime date;
  AgendaTaskList(this.selectedList, this.date);

  @override
  State<AgendaTaskList> createState() =>
      _AgendaTaskListState(selectedList, date);
}

class _AgendaTaskListState extends State<AgendaTaskList> {
  final ItemScrollController _scrollController = ItemScrollController();
  List<bool> _addTask = List.filled(24, false);
  List<Task> selectedList;
  List<DateTime> hours = [];
  DateTime date;
  int currentListIndex = 0;

  _AgendaTaskListState(this.selectedList, this.date);

  @override
  void initState() {
    selectedList.sort((a, b) => a.startTime.compareTo(b.startTime));
    int currentTaskIndex = 0;
    for (int i = 0; i < 24; i++) {
      if (currentTaskIndex < selectedList.length &&
          selectedList[currentTaskIndex].startTime.hour == i) {
        if (selectedList[currentTaskIndex].startTime.minute != 0)
          hours.add(DateTime(date.year, date.month, date.day, i));

        hours.add(selectedList[currentTaskIndex].startTime);

        i = selectedList[currentTaskIndex].endTime.hour - 1;
        if (selectedList[currentTaskIndex].endTime.minute != 0) {
          hours.add(selectedList[currentTaskIndex].endTime);
          i++;
        }
        print(i);
        currentTaskIndex++;
      } else {
        hours.add(DateTime(date.year, date.month, date.day, i));
      }
    }

    print(hours);
    currentListIndex = 0;
    if (DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year) {
      currentListIndex = max(
          hours.indexWhere((hour) => hour.hour > DateTime.now().hour) - 1, 0);
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.scrollTo(
          index: currentListIndex, duration: Duration(seconds: 1));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Expanded(
      child: ScrollablePositionedList.builder(
        padding: EdgeInsets.only(
          bottom: 32.0,
        ),
        itemCount: hours.length,
        itemScrollController: _scrollController,
        itemBuilder: (context, index) {
          List<Task> curList = selectedList
              .where((task) => task.startTime.hour == hours[index].hour)
              .toList();
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == currentListIndex
                    ? Row(
                        children: [
                          SizedBox(
                            width: deviceSize.width * 0.15 - 10,
                            child: Text(
                              hours[index].minute != 0
                                  ? DateFormat.jm().format(hours[index])
                                  : DateFormat('ha').format(hours[index]),
                              style: FigmaTextStyles.t.copyWith(
                                color: FigmaColors.sUNRISETextGrey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 5,
                                  backgroundColor:
                                      FigmaColors.sUNRISEBluePrimary,
                                ),
                                SizedBox(width: 2),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: FigmaColors.sUNRISEBluePrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hours[index].minute != 0
                                ? DateFormat.jm().format(hours[index])
                                : DateFormat('ha').format(hours[index]),
                            style: FigmaTextStyles.t.copyWith(
                              color: FigmaColors.sUNRISETextGrey,
                            ),
                          ),
                          MySeparator(
                            color: Colors.grey,
                            dashWidth: 2.5,
                          ),
                        ],
                      ),
                Container(
                  padding:
                      EdgeInsets.only(top: index == currentListIndex ? 6 : 12),
                  child: Column(
                    children: [
                      if (curList.length == 0)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _addTask[index] = !_addTask[index];
                            });
                          },
                          child: _addTask[index]
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    addTaskButton(),
                                  ],
                                )
                              : Container(
                                  height: 35,
                                ),
                        )
                      else
                        taskWidget(curList[0]),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget addTaskButton() {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Color(0xFFF5FBFF),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: DottedBorder(
        color: Color.fromARGB(255, 115, 211, 255),
        dashPattern: [7, 5],
        strokeWidth: 1.5,
        borderType: BorderType.RRect,
        radius: Radius.circular(15),
        child: Container(
          height: 99,
          width: deviceSize.width * 0.75,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: FigmaColors.sUNRISESunray,
          ),
          child: SizedBox(
            width: 143,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: FigmaColors.sUNRISEWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: FigmaColors.sUNRISEBluePrimary,
                    width: 2,
                  ),
                ),
              ),
              child: Text("Add Task",
                  style: FigmaTextStyles.sButton
                      .copyWith(color: FigmaColors.sUNRISEBluePrimary)),
            ),
          ),
        ),
      ),
    );
  }

  Widget taskWidget(Task task) {
    int defaultHeightPerHour = 80;
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: deviceSize.width * 0.15,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              Navigator.pushNamed(context, DetailedTaskScreen.routeName,
                      arguments: task)
                  .then((value) {});
            },
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              primary: task.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: defaultHeightPerHour *
                  (task.endTime.difference(task.startTime).inMinutes / 60),
              margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.field,
                          style: FigmaTextStyles.sButton
                              .copyWith(color: FigmaColors.sUNRISEWhite)),
                      Text(
                        task.course,
                        style: FigmaTextStyles.t
                            .copyWith(color: FigmaColors.sUNRISEWhite),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(task.startTime) +
                            " - " +
                            DateFormat('h:mm a').format(task.endTime),
                        style: FigmaTextStyles.t
                            .copyWith(color: FigmaColors.sUNRISEWhite),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
