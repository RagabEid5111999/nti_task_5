import 'package:flutter/material.dart';
import 'package:nti_task_5/sql_db.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TextEditingController taskController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  late List<Map> dataList = [];
  late int doneTasks = 0;
  bool onChanged = false;

  Future<void> setVaraible() async {
    await sqlDb.readData("SELECT COUNT(*) FROM notes WHERE done = 1").then((
      value,
    ) {
      doneTasks = value[0]['COUNT(*)'];
    });
  }

  @override
  void initState() {
    setVaraible();
    super.initState();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display total tasks and done tasks////////////////////////
              Text(
                'Total Tasks: ${dataList.length} \nDone Tasks: $doneTasks',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Input field to add new task////////////////////////
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Add task functionality
                      if (taskController.text.isNotEmpty) {
                        setState(() {
                          sqlDb.insertData(
                            "INSERT INTO notes (title, note) VALUES ('Task', '${taskController.text}')",
                          );
                          dataList;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Task Added: ${taskController.text}'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a task')),
                        );
                      }
                      taskController.clear();
                    },
                    icon: const Icon(Icons.add),
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'add your task here',
                ),
              ),

              Expanded(child: customListOfTasks()),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),

          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/profilepage');
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

  FutureBuilder<List<Map<dynamic, dynamic>>> customListOfTasks() {
    return FutureBuilder(
      future: sqlDb.readData("SELECT * FROM notes"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        dataList = snapshot.data as List<Map<String, dynamic>>;
        // dataList = dataList;

        return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                /// Edit Task
                IconButton(
                  onPressed: () {
                    // Edit task functionality
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController editController =
                            TextEditingController();
                        editController.text = dataList[index]['note'];
                        return AlertDialog(
                          title: const Text('Edit Task'),
                          content: TextField(
                            controller: editController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Edit your task',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                sqlDb.updateData(
                                  "UPDATE notes SET note = '${editController.text}' WHERE id = ${dataList[index]['id']}",
                                );
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),

                SizedBox(
                  width: 300,
                  child: ListTile(
                    title: Text(dataList[index]['title']),
                    subtitle: Text(dataList[index]['note']),
                    leading: Checkbox(
                      value: dataList[index]['done'] == 1 ? true : false,
                      onChanged: (value) {
                        // Handle checkbox state change
                        // value = !value!;
                        value!
                            ? {
                                sqlDb.updateData(
                                  "UPDATE notes SET done = 1 WHERE id = ${dataList[index]['id']}",
                                ),
                                doneTasks++,
                              }
                            : {
                                sqlDb.updateData(
                                  "UPDATE notes SET done = 0 WHERE id = ${dataList[index]['id']}",
                                ),
                                doneTasks--,
                              };

                        setState(() {});
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await sqlDb.deleteData(
                          "DELETE FROM notes WHERE id = ${dataList[index]['id']}",
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
