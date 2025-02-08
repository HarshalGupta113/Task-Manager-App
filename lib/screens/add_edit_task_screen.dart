import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../model/task_model.dart';
import '../provider/task_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // ✅ Import intl for date formatting

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final Task? task;

  const AddEditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _dueDate;
  String _priority = 'Medium';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate; // Stored as String now
      _priority = widget.task!.priority;
    }
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You need to be logged in to save tasks!")),
      );
      return;
    }

    final task = Task(
      id: widget.task?.id ?? Uuid().v4(),
      title: _titleController.text,
      description: _descController.text.isNotEmpty ? _descController.text : "",
      dueDate: _dueDate ??
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now()), // ✅ Ensures a valid date is stored
      priority: _priority,
      isCompleted: widget.task?.isCompleted ?? false,
      userId: user.uid,
    );

    if (widget.task == null) {
      await ref.read(taskProvider.notifier).addTask(task);
    } else {
      await ref.read(taskProvider.notifier).updateTask(task);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.title, color: Colors.blue),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.description, color: Colors.blue),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dueDate == null
                            ? 'Pick a Due Date'
                            : 'Due Date: $_dueDate',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _dueDate = DateFormat('yyyy-MM-dd')
                              .format(picked)); // ✅ Format date properly
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _priority,
                  items: ['Low', 'Medium', 'High'].map((level) {
                    return DropdownMenuItem(value: level, child: Text(level));
                  }).toList(),
                  onChanged: (val) => setState(() => _priority = val!),
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  onPressed: _saveTask,
                  child:
                      Text(widget.task == null ? 'Save Task' : 'Update Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
