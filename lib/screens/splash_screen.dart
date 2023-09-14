import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/tasks.dart';
import '../providers/field.dart';

void dosth() async {
  final Future<Field> field3 = fetchField('angular');
  final Future<Field> field4 = fetchField('backend');
  final Future<Field> field5 = fetchField('blockchain');
  // create a list of above fields
  final List<Field> fields = await Future.wait([field3, field4]);
  // get schedule task
  // final Future<List<TaskList>?> taskLists =
  //     getScheduledTasks("2B9E2a62McR1rhrvuC67fXZSGic2", fields);
  //print(taskLists);
}

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash-screen';
  @override
  Widget build(BuildContext context) {
    //dosth();
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
