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
      "Create a unique emotional story that describes better than words",
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

  Widget buildNum(ToDoCard card) =>
      Container(
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
