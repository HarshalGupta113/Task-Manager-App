import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model.dart';
import '../provider/task_provider.dart';
import '../screens/add_edit_task_screen.dart';

class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description
                .isNotEmpty) // 🔹 Show description only if it's not empty
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  task.description,
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 2, // Limit description to 2 lines
                  overflow: TextOverflow.ellipsis, // Add "..." if too long
                ),
              ),
            Text('Priority: ${task.priority}'),
            Text('Due: ${task.dueDate}'),
          ],
        ),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            ref
                .read(taskProvider.notifier)
                .updateTask(task.copyWith(isCompleted: val!));
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(task: task),
            ),
          );
        },
        onLongPress: () {
          _confirmDelete(context, ref);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
              Navigator.pop(ctx);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
