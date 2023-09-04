import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:codev/icon/my_icons.dart';

//FigmaTextStyles.mH3.copyWith(color:FigmaColors.sUNRISELightCharcoal,
enum Actions {delete, access}

class TasksScreen extends StatefulWidget {
  static const routeName = '/tasks-screen';
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<ToDoCard> list = [
    ToDoCard(
      "Monday 17 August",
      "11:30 AM - 12:30 PM",
      "Math",
      "Create a unique emotional story that describes better than words",
      MyIcons.robot,
      Color(0xFFFF7A7B),
    ),
    ToDoCard(
      "Monday 17 August",
      "11:30 AM - 12:30 PM",
      "Math",
      "Create a unique emotional story that describes better than words and explore yourself to the finest degree",
      MyIcons.robot,
      Color(0xFFFF7A7B),
    )];
  final List<ToDoCard> list1 = [
    ToDoCard(
      "Monday 8 August",
      "11:30 AM - 12:30 PM",
      "Geometry",
      "Create a unique emotional story that describes better than words",
      MyIcons.cube_outline,
      Color(0xFF26BFBF),
    ),
    ToDoCard(
      "Monday 8 August",
      "11:30 AM - 12:30 PM",
      "Geometry",
      "Create a unique emotional story that describes better than words",
      MyIcons.cube_outline,
      Color(0xFF26BFBF),
    ),
  ];
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      body: Column(
        children: [
          Container(
            width:375,
            height:190,
            padding: EdgeInsets.fromLTRB(10.5, 0, 10.5, 22),
            color: FigmaColors.sUNRISELightCoral,
            child: Container(
              width: 354,
              height: 48,
              margin: EdgeInsets.only(top: 121),
              decoration: BoxDecoration(
                color: FigmaColors.sUNRISEWhite,
                borderRadius: BorderRadius.circular(12),
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
          ),
          // filter icon and add new lesson here
          Container(
            padding: EdgeInsets.fromLTRB(13, 16, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Center(child: Icon(MyIcons.filter_variant, color: FigmaColors.sUNRISELightCharcoal)),
                  iconSize: 20,
                  onPressed: (){},
                  style: IconButton.styleFrom(
                      backgroundColor: FigmaColors.sUNRISEWhite,
                      shape: ContinuousRectangleBorder(
                        side: BorderSide(color: FigmaColors.lightblue, width: 1),
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                ),

                TextButton.icon(
                  label: DefaultTextStyle(
                    style: TextStyle(color: FigmaColors.sUNRISEBluePrimary),
                    child: Text('New Lesson', style: FigmaTextStyles.mB),
                  ),
                  icon: const Icon(Icons.add, color: FigmaColors.sUNRISEBluePrimary),
                  onPressed: (){},
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                Page(list, list1, "Due"),
                Page(list, list1, "In-progress"),
                Page(list, list1, "Completed"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ToDoCard {
  String date;
  String time;
  String title;
  String description;
  IconData icon;
  Color color;
  ToDoCard(this.date, this.time, this.title, this.description, this.icon, this.color);
}


class Page extends StatefulWidget {
  final List<ToDoCard> list, list1;
  final String curState;

  const Page(this.list, this.list1, this.curState, {super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(23, 16, 0, 0),
              child: Text.rich(
                TextSpan(
                  text: '${widget.curState}. ',
                  style: FigmaTextStyles.p.copyWith(color:FigmaColors.sUNRISEDarkGrey),
                  children: <TextSpan>[
                    TextSpan(text: 'Today, Monday 17',
                        style: FigmaTextStyles.mB.copyWith(color:FigmaColors.sUNRISETextGrey)),
                  ],
                ),
              ),
            ),
            buildCardList(widget.list),
            Container(
              margin: const EdgeInsets.fromLTRB(23,0, 0, 0),
              child: Text.rich(
                TextSpan(
                  text: '${widget.curState}. ',
                  style: FigmaTextStyles.p.copyWith(color:FigmaColors.sUNRISEDarkGrey),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Tuesday 18',
                        style: FigmaTextStyles.mB.copyWith(color:FigmaColors.sUNRISETextGrey))
                  ],
                ),
              ),
            ),
            buildCardList(widget.list1),
          ],
        ),
      )
  );

  Widget buildCardList(List<ToDoCard> list) {
    final _color  = List<Color>.filled(list.length, FigmaColors.sUNRISEWhite, growable: true); //
    return  SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: SizedBox(
        height: 135 * list.length * 1.0,
        width: 375,
        child: ListView.builder(
            physics:  NeverScrollableScrollPhysics(),
            itemCount: list.length, // number of tasks in this date
            itemBuilder: (context, index) {
              final ToDoCard card = list[index];
              return Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: const StretchMotion(),
                  children: [
                    Expanded(
                      child: Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.fromLTRB(0,0,2.7,0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFFF7A7B),
                        ),
                        child: IconButton(onPressed: () {},
                            icon: const Icon(MyIcons.delete_outline, color: Colors.white)
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.fromLTRB(0,0,2.7,0),
                        padding: EdgeInsets.all(0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFF2FD1C5),
                        ),
                        child: IconButton(onPressed: () {},
                            icon: const Icon(MyIcons.play, color: Colors.white)
                        ),
                      ),
                    ),
                  ],
                ),
                child: buildCard(card, index),
              );
            }),
      ),
    );
  }

  int _expandedIndex = -1;

  Widget buildCard(ToDoCard card, int index) =>
      Builder(
        builder: (context) => GestureDetector(
          onTap: () {setState(() => _expandedIndex = index);
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(13.5, 0, 13.5, 10),
            padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
            decoration: BoxDecoration(
              color: _expandedIndex == index
                  ? Color(0xFFC4D7FF)
                  : FigmaColors.sUNRISEWhite,
              border: Border(
                top: BorderSide(color: card.color, width: 1),
                right: BorderSide(color: card.color, width: 1),
                bottom: BorderSide(color: card.color, width: 1),
                left: BorderSide(color: card.color, width:5),
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 209,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(card.icon, color: card.color),
                        SizedBox(width: 10),
                        Text(card.time, style: FigmaTextStyles.mT.copyWith(color: FigmaColors.systemGrey)),
                      ],),
                      Text(
                        card.title, style: FigmaTextStyles.sButton.copyWith(color: FigmaColors.systemDark)),
                      Text(card.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: FigmaTextStyles.mT.copyWith(color: FigmaColors.sUNRISETextGrey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_outlined, color: Color(0xFFD8DEF3)),
                  onPressed: (){},
                ),
              ],
            ),
          ),
        ),
      );
}
