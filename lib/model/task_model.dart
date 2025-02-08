class Task {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final bool isCompleted;
  final String userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.userId,
  });

  // 🔹 Convert Task object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  // 🔹 Convert Firestore Map to Task object
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      priority: map['priority'],
      isCompleted: map['isCompleted'],
      userId: map['userId'],
    );
  }

  // ✅ `copyWith` Method for Editing Tasks
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? dueDate,
    String? priority,
    bool? isCompleted,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}
