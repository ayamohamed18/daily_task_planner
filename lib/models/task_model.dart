import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
   String id;
  final String title;
  final DateTime deadline;
  bool isCompleted; 

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    this.isCompleted = false, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

 factory Task.fromMap(Map<String, dynamic> map) {
  return Task(
    id: map['id'] ?? '', 
    title: map['title'] ?? 'Untitled Task', 
deadline: (map['deadline'] as Timestamp).toDate(),    isCompleted: map['isCompleted'] ?? false,
  );
}
}
