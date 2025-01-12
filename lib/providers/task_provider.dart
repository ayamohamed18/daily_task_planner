import 'package:daily_task_planner/models/task_model.dart';
import 'package:daily_task_planner/services/firebase_service.dart';
import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final FirebaseService _firebaseService = FirebaseService();

  List<Task> get tasks => _tasks;

  Future<List<Task>> fetchTasks() async { 
    try{
    _tasks = await _firebaseService.fetchTasks();
    print('Tasks fetched: $_tasks');
    notifyListeners();
    return _tasks;

    }catch (e) {
      throw e;
    
    }
 
  }

   Future<void> addTask(Task task) async {
    await _firebaseService.addTask(task);
     _tasks.add(task);
     
   // fetchTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await _firebaseService.deleteTask(taskId);
   _tasks.removeWhere((task) => task.id == taskId);
   
    //fetchTasks(); 
    notifyListeners();
  }

   Future<void> toggleTaskStatus(String taskId) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return; 

      final currentStatus = _tasks[taskIndex].isCompleted;
      _tasks[taskIndex].isCompleted = !currentStatus; 

      await _firebaseService.toggleTaskCompletion(
          taskId, currentStatus); 
      notifyListeners(); 
    } catch (error) {
      print('Error toggling task status in provider: $error');
    }
  }

}
