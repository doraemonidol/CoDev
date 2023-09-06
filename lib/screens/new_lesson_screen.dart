import 'dart:math';

import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import '../icon/my_icons.dart';

class ToDoCard {
  String date;
  String time;
  String title;
  String description;
  IconData icon;
  Color color;
  ImageProvider img;
  ToDoCard(this.date, this.time, this.title, this.description, this.icon, this.color, this.img);
}
class NewLessonScreen extends StatefulWidget {
  const NewLessonScreen({super.key});

  @override
  State<NewLessonScreen> createState() => _NewLessonScreenState();
}

class _NewLessonScreenState extends State<NewLessonScreen> {
  bool isPressed = false;
  // const NewLessonScreen({super.key});
  final urlOb = 'https://www.hindustantimes.com/ht-img/img/2023/07/15/550x309/jennie_1689410686831_1689410687014.jpg';
  //final nums = List.generate(100, (index) => '$index');
  final List<ToDoCard> list = [
    ToDoCard(
      "Monday 17 August",
      "11:30 AM - 12:30 PM",
      "Jennie Ruby Jane",
      "Create a unique emotional story that describes better than words",
      MyIcons.robot,
      Color(0xFFFF7A7B),
      NetworkImage('https://www.hindustantimes.com/ht-img/img/2023/07/15/550x309/jennie_1689410686831_1689410687014.jpg'),
    ),
    ToDoCard(
      "Monday 17 August",
      "11:30 AM - 12:30 PM",
      "Kim",
      "Create a unique emotional story that describes better than words",
      MyIcons.robot,
      Color(0xFFFF7A7B),
      NetworkImage('https://www.allkpop.com/upload/2022/12/content/281808/1672268895-image.png'),
    ),
    ToDoCard(
      "Monday 17 August",
      "11:30 AM - 12:30 PM",
      "Black",
      "Lesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson DescriptionLesson Description",
      MyIcons.robot,
      Color(0xFFFF7A7B),
      NetworkImage('https://www.allkpop.com/upload/2022/12/content/281808/1672268898-image.png'),
    ),
    ToDoCard(
      "Monday 17 August",
      "11:30 AM - 12:30 PM",
      "Pink",
      "Create a unique emotional story that describes better than words",
      MyIcons.robot,
      Color(0xFFFF7A7B),
      NetworkImage('https://www.allkpop.com/upload/2022/12/content/281808/1672268902-image.png'),
    ),
  ];
  final controller = ScrollController();

  Widget buildGridView() => Expanded(
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing:5,
        crossAxisSpacing:16,
      ),
      padding: EdgeInsets.symmetric(horizontal:21),
      controller: controller,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return buildNum(item);
      },
    ),
  );

  Widget buildNum(ToDoCard card) => InkWell(
      onTap: (){
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context){
            return Container(
              height:477,
              width:375,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25,25,25,0),
                      child: Text(
                        card.title,
                        style: FigmaTextStyles.mH1.copyWith(color: FigmaColors.sUNRISELightCharcoal),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 76,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25,0,25,0),
                        child: Text(
                          card.description,
                          style: FigmaTextStyles.mP.copyWith(color: FigmaColors.sUNRISECharcoal),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 1),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25,0,0,5),
                        child: Text(
                          'Current Level',
                          style: FigmaTextStyles.mP.copyWith(color: FigmaColors.sUNRISETextGrey),
                        ),
                      ),
                    ),

                  Row(
                      children: [
                        SizedBox(width: 25),
                        CustomButton(),
                        SizedBox(width: 10),
                        CustomButton(),
                        SizedBox(width: 10),
                        CustomButton(),
                      ]
                  ),
                  SizedBox(height: 15),
                  HorizontalIconList(),
                  SizedBox(height: 15),
                  HorizontalColorList(),

                  SizedBox(height: 18),
                    Container(
                      decoration: BoxDecoration(
                        color: FigmaColors.sUNRISEBluePrimary,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: 250,
                      height: 62,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(2,0,0,0),
                          backgroundColor: FigmaColors.sUNRISEBluePrimary,
                          shape: ContinuousRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.0))),
                          child: Text('Add lesson', style: FigmaTextStyles.mButton.copyWith(color: FigmaColors.sUNRISEWhite), textAlign: TextAlign.center),
                          onPressed: () {},
                      ),
                ),
                ],
              )
            );
        },
        );
      },
    child: Container(
      width: 150,
      height: 96,
        decoration: BoxDecoration(
          border: Border.all(
            color: FigmaColors.sUNRISEBluePrimary,
            width: 2.0,
          ),
          image: DecorationImage(image: card.img, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(
              card.title,
              style: FigmaTextStyles.mButton23.copyWith(color: FigmaColors.sUNRISESunray),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            )
        )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.sUNRISELightCoral,
      appBar: AppBar(
        backgroundColor: FigmaColors.sUNRISELightCoral,
      ),
      body: Column(
        children: [
        Positioned(
          left: 21,
          top: 96,
          child: SizedBox(
            width: 332,
            height: 46,
            child: Container(
              padding: EdgeInsets.fromLTRB(16,0,8,0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: MySearchDelegate(),
                        );
                      },
                      child: DefaultTextStyle(
                        style: TextStyle(color: FigmaColors.sUNRISETextGrey),
                        child: Text('Search', style: FigmaTextStyles.p),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: MySearchDelegate(),
                        );
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height:16),
          buildGridView(),
          ]
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      height: 35,
      child: ElevatedButton(
        child: Text(
        "Beginner",
        style: FigmaTextStyles.mP.copyWith(color: isPressed ? FigmaColors.sUNRISEWhite : FigmaColors.sUNRISEBluePrimary),
        textAlign: TextAlign.center,
      ),
        onPressed: () {
          setState(() {
            isPressed = !isPressed;
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: isPressed
                        ? FigmaColors.sUNRISEBluePrimary
                        : FigmaColors.sUNRISEWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isPressed ? FigmaColors.sUNRISEWhite : FigmaColors.sUNRISEBluePrimary,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate{
  List<String> searchResults = [
    'Front-end',
    'Back-end',
    'Database',
    'Calculus I',
    'General Physics III',
    'Computer Hardware',
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null), //close the searchbar
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if(query.isEmpty) close(context,null); //close the searchbar
          else query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // show query result
  @override
  Widget buildResults(BuildContext context) => Center(
      child: Text(
        query,
        style: FigmaTextStyles.h3.copyWith(color:FigmaColors.sUNRISELightCharcoal),
      )
  );

  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = searchResults.where((searchResult){
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
            title: Text(result),
            onTap: () {
              query = result;
              showResults(context);
            }
        );
      },
    );
  }
}

class HorizontalIconList extends StatelessWidget {
  final int numberOfIcons = 20;
  final List<IconData> iconDataList = [
    MyIcons.robot,
    MyIcons.cube_outline,
    Icons.home,
    Icons.star,
    Icons.mail,
    Icons.settings,
    MyIcons.play,
    Icons.circle,
    Icons.square,
  ];

  Color generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 43,
        child: Row(
          children: List.generate(numberOfIcons, (index) {
            final iconData = iconDataList[index % iconDataList.length];
            final iconColor = generateRandomColor();
            return Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                iconData,
                size: 36.0,
                color: iconColor,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class HorizontalColorList extends StatefulWidget {
  @override
  _HorizontalColorListState createState() => _HorizontalColorListState();
}

class _HorizontalColorListState extends State<HorizontalColorList> {
  final int numberOfColors = 20;
  List<bool> isPressedList = List.generate(20, (index) => false);
  List<Color> iconColors = [];

  Color generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize iconColors with random colors
    iconColors = List.generate(numberOfColors, (_) => generateRandomColor());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border.all(
          color: FigmaColors.lightblue,
          width: 1.0,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 43,
          child: Row(
            children: List.generate(numberOfColors, (index) {
              final iconColor = iconColors[index % iconColors.length];
              return Padding(
                padding: EdgeInsets.only(right: 0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPressedList[index] = !isPressedList[index];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,
                    shape: CircleBorder(),
                    minimumSize: Size(32.0, 32.0),
                  ),
                  child: Icon(
                    Icons.circle,
                    color: isPressedList[index] ? FigmaColors.sUNRISEWhite : iconColor,
                    size: 16.0,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}





