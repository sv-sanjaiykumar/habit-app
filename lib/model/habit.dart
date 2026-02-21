import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? deadline;
  final bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.deadline,
    this.isCompleted = false,
  });

  factory Habit.fromMap(Map<String, dynamic> data, String docId) {
    return Habit(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deadline: data['deadline'] != null
          ? (data['deadline'] as Timestamp).toDate()
          : null,
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'deadline': deadline,
      'isCompleted': isCompleted,
    };
  }

  Habit copyWith({bool? isCompleted}) {
    return Habit(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      deadline: deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
