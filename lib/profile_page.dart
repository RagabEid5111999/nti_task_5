import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nti_task_5/tasks_page.dart';

class ProfilePage extends StatefulWidget {
  final int totalTasks;
  final int doneTasks;
  final String userName;
  const ProfilePage({
    super.key,
    required this.totalTasks,
    required this.doneTasks,
    required this.userName,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.userName}'s Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Total Tasks: ${widget.totalTasks}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Done Tasks: ${widget.doneTasks}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _image != null
                      ? CircleAvatar(
                          radius: 100,

                          backgroundImage: Image.file(_image!).image,
                        )
                      : CircleAvatar(
                          radius: 100,

                          backgroundImage: AssetImage(
                            'assets/images/bread.jpg',
                          ),
                        ),
                  ElevatedButton(
                    onPressed: pickImage,
                    child: Text('Tap to select image from gallery'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TasksPage(userName: widget.userName),
                  ),
                );
              },
              icon: Icon(Icons.task),
            ),
            label: 'Tasks',
          ),

          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You are already on Profile Page')),
                );
              },
              icon: const Icon(Icons.person),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
