import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime? _selectedDeadline;

  void _submitTask(BuildContext context)async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDeadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a deadline')),
        );
        
        return;
      }

      final newTask = Task(  id: FirebaseFirestore.instance.collection('tasks').doc().id,
      title: _titleController.text,
      deadline: _selectedDeadline!,
      isCompleted: false,
    );
       try {
        await Provider.of<TaskProvider>(context, listen: false).addTask(newTask); 
        Navigator.of(context).pop(); 
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task: $error')),
        );
      }

     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 236, 219, 240),
        title: Text('Add New Task',style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
           height: MediaQuery.of(context).size.height,
          child: Card(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Task Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  Text(
                    _selectedDeadline == null
                        ? 'No deadline chosen!'
                        : 'Deadline: ${_selectedDeadline.toString()}',
                  style: TextStyle(fontSize: 13),),
                  SizedBox(width: MediaQuery.of(context).size.width*0.08,),
                  Flexible(
                    child: TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _selectedDeadline = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                          
                              );
                            });
                          }
                        }
                      },
                      child: Text('Select Deadline',style: TextStyle(fontSize: 20),),
                    ),
                  ),
                  SizedBox(height:  MediaQuery.of(context).size.height*0.07,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 236, 219, 240)),
                    onPressed: () => _submitTask(context),
                    child: Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
