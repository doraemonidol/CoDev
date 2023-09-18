import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codev/main.dart';
import 'package:codev/providers/field.dart';
import 'package:codev/providers/tasks.dart';
import 'package:codev/screens/notification_screen.dart';
import 'package:codev/widgets/horizontal_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:codev/helpers/style.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../helpers/notification_service.dart';
import '../icon/my_icons.dart';
import '../providers/auth.dart';

class NewLessonScreen extends StatefulWidget {
  static const routeName = '/new-lesson-screen';

  @override
  State<NewLessonScreen> createState() => _NewLessonScreenState();
}

class _NewLessonScreenState extends State<NewLessonScreen> {
  // const NewLessonScreen({super.key});
  final urlOb =
      'https://static.vecteezy.com/system/resources/thumbnails/001/882/531/small/dark-blue-technology-background-free-vector.jpg';
  final controller = ScrollController();
  Size? deviceSize;
  double? safeHeight;
  List list = [];
  String query = '';
  bool _isLoading = false;
  IconData? iconData;
  Color? color;

  // set icondata
  void setIconData(IconData icon) {
    iconData = icon;
  }

  // set color
  void setColor(Color color) {
    this.color = color;
  }

  void _showModalBottomSheet(BuildContext context, {String? name, int? index}) {
    final field = name != null
        ? list.firstWhere((element) => element['name'] == query)
        : list[index!];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModalSheet) {
            return Container(
              height: safeHeight! * 0.7,
              padding:
                  EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 16),
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
                        field['description'] ?? '',
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
                    HorizontalIconList(
                      onIconSelected: setIconData,
                    ),
                    SizedBox(height: 15),
                    HorizontalColorList(
                      onColorSelected: setColor,
                    ),
                    SizedBox(height: 18),
                    Container(
                      decoration: BoxDecoration(
                        color: FigmaColors.sUNRISEBluePrimary,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: 250,
                      height: 62,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: FigmaColors.sUNRISEWhite,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                  backgroundColor:
                                      FigmaColors.sUNRISEBluePrimary,
                                  shape: ContinuousRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(
                                          deviceSize!.width * 0.1))),
                              child: Text('Add lesson',
                                  style: FigmaTextStyles.mButton.copyWith(
                                      color: FigmaColors.sUNRISEWhite),
                                  textAlign: TextAlign.center),
                              onPressed: () async {
                                setStateModalSheet(() {
                                  _isLoading = true;
                                });
                                print(field['name']);
                                final userId =
                                    Provider.of<Auth>(context, listen: false)
                                        .userId;
                                List<NotificationDetail> notiList = [];
                                await fetchField(field['name'])
                                    .then((value) async {
                                  await addFieldToSchedule(
                                    context,
                                    userId,
                                    value,
                                    iconData!,
                                    color!,
                                  ).then((value) async {
                                    cancelPendingNotificationRequestsWithTaskPayload();
                                    deleteNotificationFromFirestoreLaterThan(
                                        userId,
                                        DateTime.now()
                                            .add(Duration(minutes: 15)));
// for each task in value, add a notification
                                    // int notiIndex = 1;
                                    value!.forEach((tasks) {
                                      tasks.tasks.forEach((task) {
                                        notiList.add(NotificationDetail(
                                          task: task,
                                          status: NotificationState.unread,
                                        ));
                                        zonedScheduleNotification(
                                          id: notificationId++,
                                          title: 'It\'s time for your lesson!',
                                          body:
                                              'You have a lesson: ${task.course} on ${task.field} in 15 minutes!',
                                          payload: task,
                                          scheduledDate: task.startTime
                                              .subtract(Duration(minutes: 15)),
                                          // DateTime.now().add(Duration(seconds: 20 * notiIndex++)),
                                        );
                                      });
                                    });

                                    await addNotificationListToFirestore(
                                      userId,
                                      notiList,
                                    );

                                    setStateModalSheet(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                  });
                                });
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildGridView() {
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
          final name = item['name'];
          ;
          //print(item['url']);
          return buildNum(
              name, item['url'] == null ? urlOb : item['url'], index);
        },
      ),
    );
  }

  Widget buildNum(String title, String url, int index) {
    /*url has the format https://drive.google.com/file/d/<FILE_ID>/view?usp=sharing. Copy the <FILE_ID> and Append it to this link below in the following format: https://drive.google.com/uc?export=view&id=<FILE_ID> */
    final String url2 = url
        .replaceAll(
          'https://drive.google.com/file/d/',
          'https://drive.google.com/thumbnail?id=',
        )
        .replaceAll('/view?usp=sharing', '')
        .replaceAll('/view?usp=share_link', '');

    print(url);
    print(url2);
    //if (!imageReady[index]) checkImageValidity(url2, index);
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
            image: Image.network(
              url2,
              // errorBuilder: (context, error, stackTrace) {
              //   return;
              // },
            ).image,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
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
        if (fieldSnapshot.connectionState == ConnectionState.waiting ||
            fieldSnapshot.data!.docs.length < 2) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        list = fieldSnapshot.data!.docs[1]['fields'];
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
                            _showModalBottomSheet(context, name: query);
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
                          _showModalBottomSheet(context, name: query);
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
