import 'package:daily_task_planner/models/task_model.dart';
import 'package:daily_task_planner/views/add_task_screen.dart';
import 'package:flutter/material.dart';
import '../providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TaskBoardScreen extends StatefulWidget {
  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  late Future<List<Task>> _tasksFuture;
  @override
  void initState() {
    super.initState();
    _tasksFuture =
        Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 236, 219, 240),
        title: Text(
          'Task Board',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No tasks for today. Create one now!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            final tasks = snapshot.data ?? [];
 print('Tasks: ${tasks.map((task) => task.title)}');
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(218, 209, 215, 1),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Deadline: ${DateFormat.yMMMMd().add_jm().format(task.deadline)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (newValue) {
                            taskProvider.toggleTaskStatus(task.id);
                            setState(() {});
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            taskProvider.deleteTask(task.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Task deleted successfully'),
                              ),
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text('Something went wrong.',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
