import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/habit_provider.dart';
import '../provider/history_provider.dart';
import '../model/habit.dart';

class HabitTile extends StatelessWidget {
  final String habitId;

  const HabitTile({super.key, required this.habitId});

  @override
  Widget build(BuildContext context) {
    return Selector<HabitProvider, Habit>(
      selector: (_, p) => p.habits.firstWhere((h) => h.id == habitId),
      builder: (_, habit, __) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Checkbox(
              value: habit.isCompleted,
              activeColor: const Color(0xE400DC0E),
              onChanged: (_) {
                context.read<HabitProvider>().toggleHabit(
                  habit.id,
                  onCompleted: (name) {
                    context.read<HistoryProvider>().addToHistory(name);
                  },
                );
              },
            ),
            title: Text(
              habit.title,
              style: TextStyle(
                color: Colors.white,
                decoration:
                habit.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
