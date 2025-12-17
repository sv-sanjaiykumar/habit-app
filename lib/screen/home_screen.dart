import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/habit_provider.dart';
import 'habit_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final habitController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDeadline;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HabitProvider>().loadHabits();
    });
  }

  @override
  void dispose() {
    habitController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().habits;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        title: const Text("Today's Habits", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAddHabitCard(),
            const SizedBox(height: 16),
            habits.isEmpty
                ? const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "No habits yet.\nStart by adding one!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => HabitTile(habitId: habits[i].id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddHabitCard() {
    final provider = context.read<HabitProvider>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            controller: habitController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter habit title',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
          TextField(
            controller: descriptionController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter description',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedDeadline == null
                      ? "No deadline selected"
                      : "Deadline: ${DateFormat.yMMMd().format(selectedDeadline!)}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (_, child) => Theme(
                      data: ThemeData.dark(),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => selectedDeadline = picked);
                },
                child: const Text("Pick Deadline"),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xE400DC0E), size: 32),
              onPressed: () async {
                if (habitController.text.trim().isEmpty) return;
                await provider.addHabit(
                  habitController.text.trim(),
                  descriptionController.text.trim(),
                  selectedDeadline,
                );
                habitController.clear();
                descriptionController.clear();
                setState(() => selectedDeadline = null);
              },
            ),
          ),
        ],
      ),
    );
  }
}
