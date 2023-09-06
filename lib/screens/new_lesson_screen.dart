import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codev/widgets/horizontal_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import '../icon/my_icons.dart';

class NewLessonScreen extends StatefulWidget {
  static const routeName = '/new-lesson-screen';
  const NewLessonScreen({super.key});

  @override
  State<NewLessonScreen> createState() => _NewLessonScreenState();
}

class _NewLessonScreenState extends State<NewLessonScreen> {
  // const NewLessonScreen({super.key});
  final urlOb =
      'https://www.hindustantimes.com/ht-img/img/2023/07/15/550x309/jennie_1689410686831_1689410687014.jpg';
  final controller = ScrollController();
  Size? deviceSize;
  double? safeHeight;
  List list = [];
  String query = '';

  void _showModalBottomSheet(BuildContext context, {String? name, int? index}) {
    final field = name != null
        ? list.firstWhere((element) => element['name'] == query)
        : list[index!];

    print('field: $field');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: safeHeight! * 0.7,
          padding: EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    field['name'],
                    style: FigmaTextStyles.mH1
                        .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
                    style: FigmaTextStyles.mP
                        .copyWith(color: FigmaColors.sUNRISECharcoal),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current Level',
                    style: FigmaTextStyles.mP
                        .copyWith(color: FigmaColors.sUNRISETextGrey),
                  ),
                ),
                HorizontalTextButtonList(
                  texts: ['Beginner', 'Intermediate', 'Advanced'],
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
                        padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                        backgroundColor: FigmaColors.sUNRISEBluePrimary,
                        shape: ContinuousRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                                deviceSize!.width * 0.1))),
                    child: Text('Add lesson',
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISEWhite),
                        textAlign: TextAlign.center),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildGridView() {
    final user = FirebaseAuth.instance.currentUser;

    //get list of field from firestore
    print('building grid view');

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        shrinkWrap: true,
        padding: EdgeInsets.only(right: 4),
        controller: controller,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          final name = item['name']
              .split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ');

          return buildNum(
              name, item['url'] == null ? urlOb : item['url'], index);
        },
      ),
    );
  }

  Widget buildNum(String title, String url, int index) {
    return InkWell(
      onTap: () {
        _showModalBottomSheet(context, index: index);
      },
      child: Container(
        width: deviceSize!.width * 0.4,
        height: deviceSize!.width * 0.4,
        decoration: BoxDecoration(
          border: Border.all(
            color: FigmaColors.lightblue,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: FigmaColors.sUNRISEBluePrimary,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: FigmaTextStyles.mButton23
                .copyWith(color: FigmaColors.sUNRISESunray),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    safeHeight = deviceSize!.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Roadmap').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> fieldSnapshot) {
        if (fieldSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        }
        if (fieldSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        list = fieldSnapshot.data!.docs[0]['fields'];
        print('query: $query');
        return Scaffold(
          backgroundColor: FigmaColors.sUNRISELightCoral,
          appBar: AppBar(
            backgroundColor: FigmaColors.sUNRISELightCoral,
            elevation: 0,
            title: Text(
              'Choose a field',
              style: FigmaTextStyles.mButton,
            ),
            centerTitle: true,
          ),
          extendBody: true,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            query = await showSearch(
                              context: context,
                              delegate: MySearchDelegate(
                                list.map((e) => e['name'] as String).toList(),
                              ),
                            );
                            _showModalBottomSheet(context);
                          },
                          child: Row(
                            children: [
                              DefaultTextStyle(
                                style: TextStyle(
                                    color: FigmaColors.sUNRISETextGrey),
                                child: Text('Search', style: FigmaTextStyles.p),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          query = await showSearch(
                            query: query,
                            context: context,
                            delegate: MySearchDelegate(
                              list.map((e) => e['name'] as String).toList(),
                            ),
                          );
                          _showModalBottomSheet(context);
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                buildGridView(),
              ],
            ),
          ),
        );
      },
    );
  }

  buildColor(int index) {
    final color = Colors.primaries[index % Colors.primaries.length];
    final isSelected = index == 0;

    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pop();
        // Navigator.of(context).pushNamed(
        //   NewLessonScreen.routeName,
        //   arguments: {
        //     'color': color,
        //   },
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: FigmaColors.sUNRISEBluePrimary,
                  width: 2,
                )
              : null,
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [];

  MySearchDelegate(
    this.searchResults,
  );

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
          if (query.isEmpty)
            close(context, null); //close the searchbar
          else
            query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // show query result
  @override
  Widget buildResults(BuildContext context) {
    Navigator.of(context).pop(query);
    return Center(
      child: Text(
        query,
        style: FigmaTextStyles.p,
      ),
    );
  }

  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
            title: Text(result, style: FigmaTextStyles.p),
            onTap: () {
              query = result;
              showResults(context);
            });
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: FigmaColors.sUNRISELightCoral,
        elevation: 0,
        iconTheme: IconThemeData(color: FigmaColors.sUNRISETextGrey),
        titleTextStyle: FigmaTextStyles.mButton.copyWith(
          color: FigmaColors.sUNRISETextGrey,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: FigmaTextStyles.p.copyWith(
          color: FigmaColors.sUNRISETextGrey,
        ),
        border: InputBorder.none,
      ),
    );
  }

  @override
  TextStyle? get searchFieldStyle => FigmaTextStyles.p.copyWith(
        color: FigmaColors.systemDark,
      );
}
