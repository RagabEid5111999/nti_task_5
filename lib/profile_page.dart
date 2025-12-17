import 'dart:io';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nti_task_5/shared_preferances_class.dart';
import 'package:nti_task_5/tasks_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final List<SelectedListItem<String>> _listOfImages = [
    SelectedListItem<String>(data: 'assets/images/bread.jpg'),
    SelectedListItem<String>(data: 'assets/images/flower.jpg'),
    SelectedListItem<String>(data: 'assets/images/splash2.png'),
    SelectedListItem<String>(data: 'assets/images/splash.png'),
    SelectedListItem<String>(data: 'assets/images/almsar.jpg'),
    SelectedListItem<String>(data: 'assets/images/Almasarlogo1.png'),
  ];

  final TextEditingController _imageTextEditingController =
      TextEditingController();

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
                  // SizedBox(height: 20),
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
            // activeIcon: Text("data"),
          ),
        ],
      ),
    );
  }

  void onTextFieldTap() async {
    await DropDownState<String>(
      dropDown: DropDown<String>(
        isDismissible: true,
        bottomSheetTitle: const Text(
          "Select Cities: ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        submitButtonText: 'Save',
        clearButtonText: 'Clear',
        data: _listOfImages,
        onSelected: (selectedItems) {
          List<String> list = [];
          for (var item in selectedItems) {
            list.add(item.data);
            _imageTextEditingController.text = item.data;
          }
          showSnackBar(list.toString());
        },
        enableMultipleSelection: false,
        maxSelectedItems: 3,
      ),
    ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
