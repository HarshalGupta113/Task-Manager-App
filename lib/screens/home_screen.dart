import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_task/screens/add_edit_task_screen.dart';
import 'package:my_task/screens/login_screen.dart';
import '../widget/task_list.dart';
import '../provider/auth_provider.dart';
import '../provider/task_provider.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      ref.read(taskProvider.notifier).loadTasks(user.uid);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
      body: TaskListScreen(), // 🔹 Use TaskListScreen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEditTaskScreen()));
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
