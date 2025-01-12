import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_task_planner/models/task_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Task>> fetchTasks() async {
    try {
      final querySnapshot = await _firestore
          .collection('tasks')
          .orderBy('deadline') 
          .get();

       return querySnapshot.docs.map((doc) {
      final task = Task.fromMap(doc.data());
      task.id = doc.id; 
      return task;
    }).toList();
    }
     catch (error) {
      print('Error fetching tasks: $error');
      return [];
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final docRef= await _firestore.collection('tasks').add({
       // 'id': task.id,
        'title': task.title,
        'deadline': task.deadline,
        'isCompleted': task.isCompleted,
      });
      task.id = docRef.id;
    } catch (error) {
      print('Error adding task: $error');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
       print('Task deleted from Firebase: $taskId');
    } catch (error) {
      print('Error deleting task: $error');
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _firestore
          .collection('tasks')
          .doc(taskId)
          .update({'isCompleted': !isCompleted});
    } catch (error) {
      print('Error toggling task completion: $error');
    }
  }
}
