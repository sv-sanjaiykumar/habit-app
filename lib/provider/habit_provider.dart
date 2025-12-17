import 'package:flutter/material.dart';
import '../firebase/firebase_services.dart';
import '../model/habit.dart';

class HabitProvider with ChangeNotifier {
  final _firebaseService = FirebaseService();
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  Future<void> loadHabits() async {
    final data = await _firebaseService.fetchUserHabits();
    _habits = data.map((e) => Habit.fromMap(e, e['id'])).toList();
    notifyListeners();
  }

  Future<void> addHabit(String title, String desc, DateTime? deadline) async {
    await _firebaseService.addHabit(title, desc, deadline);
    await loadHabits();
  }

  Future<void> toggleHabit(String id, {Function(String)? onCompleted}) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final newValue = !_habits[index].isCompleted;

    _habits[index] = _habits[index].copyWith(isCompleted: newValue);
    notifyListeners();

    await _firebaseService.updateHabitStatus(id, newValue);

    if (newValue && onCompleted != null) {
      onCompleted(_habits[index].title);
    }
  }

  Future<void> removeHabit(String id) async {
    await _firebaseService.deleteHabit(id);
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }
}
