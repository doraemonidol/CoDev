import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//fetch the description from firestore: in the collection Roadmap, in the document with ID 123, an array object named "fields", find in it the object has "name": "angular", in which there is an array object named "stages", find in it the object has "name": "typescript basics", in which there is an array object named "courses", find in it the object has "name": "what is typescript", print it "description"
Future<void> fetchDescription() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final description = await FirebaseFirestore.instance
      .collection('Roadmap')
      .doc('Vz40NN26K2R7Y9jrKrK4')
      .get();
  final descriptionData = description.data();
  final fields = descriptionData!['fields'];
  final field = fields.firstWhere((element) => element['name'] == 'angular');
  final stages = field['stages'];
  final stage =
      stages.firstWhere((element) => element['name'] == 'typescript basics');
  final courses = stage['courses'];
  final course =
      courses.firstWhere((element) => element['name'] == 'what is typescript');
  print(course['description']);
}

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash-screen';
  @override
  Widget build(BuildContext context) {
    // fetch the description from firestore: in the collection Roadmap, in the subcollection fields, in the stages list with named "angular", in the courses list with named "what is typescript"
    fetchDescription();
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
