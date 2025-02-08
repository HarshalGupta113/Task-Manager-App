import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task_model.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Load Tasks from Firestore
  void loadTasks(String userId) {
    _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate')
        .snapshots()
        .listen((snapshot) {
      state = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
    });
  }

  // 🔹 Add Task to Firestore
  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).set(task.toMap());
  }

  // 🔹 Update Task in Firestore
  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  // 🔹 Delete Task from Firestore
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
