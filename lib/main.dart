import 'package:flutter/material.dart';
import 'package:nti_task_5/my_home_page.dart';
import 'package:nti_task_5/profile_page.dart';
import 'package:nti_task_5/sign_up.dart';
import 'package:nti_task_5/tasks_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/taskspage': (context) => const TasksPage(),
        '/signup': (context) => SignUp(),
        '/profilepage': (context) => const ProfilePage(),
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
