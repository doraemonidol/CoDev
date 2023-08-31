import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  static const routeName = '/tasks-screen';
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tasks Screen'),
    );
  }
}
