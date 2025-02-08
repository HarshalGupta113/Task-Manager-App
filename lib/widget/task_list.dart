import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model.dart';
import '../provider/task_provider.dart';
import 'task_card.dart'; // Import TaskCard

class TaskListScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String _filterPriority = 'All';
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    List<Task> filteredTasks = tasks.where((task) {
      bool matchesPriority =
          _filterPriority == 'All' || task.priority == _filterPriority;
      bool matchesStatus = _filterStatus == 'All' ||
          (_filterStatus == 'Completed' && task.isCompleted) ||
          (_filterStatus == 'Incomplete' && !task.isCompleted);
      return matchesPriority && matchesStatus;
    }).toList();

    return Column(
      children: [
        _buildFilterRow(),
        Expanded(
          child: filteredTasks.isEmpty
              ? Center(child: Text('No tasks available'))
              : ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                        task: filteredTasks[index]); // 🔹 Use TaskCard
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Priority:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _filterPriority,
            items: ['All', 'Low', 'Medium', 'High'].map((priority) {
              return DropdownMenuItem(value: priority, child: Text(priority));
            }).toList(),
            onChanged: (val) => setState(() => _filterPriority = val!),
          ),
          Text(
            "Status:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _filterStatus,
            items: ['All', 'Completed', 'Incomplete'].map((status) {
              return DropdownMenuItem(value: status, child: Text(status));
            }).toList(),
            onChanged: (val) => setState(() => _filterStatus = val!),
          ),
        ],
      ),
    );
  }
}
