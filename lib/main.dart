import 'package:flutter/material.dart';
import 'package:nti_task_5/login_page.dart';
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
        '/taskspage': (context) => const TasksPage(userName: "   "),
        '/signup': (context) => SignUp(),
        '/profilepage': (context) =>
            const ProfilePage(totalTasks: 0, doneTasks: 0, userName: ''),
      },
      home: const LoginPage(title: 'Flutter Demo Home Page'),
    );
  }
}
