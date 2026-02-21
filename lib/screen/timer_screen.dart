import 'package:flutter/material.dart';
import 'package:intern_habit_app/screen/timer_controls.dart';
import 'package:provider/provider.dart';
import '../provider/timer_provider.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final seconds = context.watch<TimerProvider>().seconds;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Focus Timer'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xE400DC0E),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xE400DC0E).withOpacity(0.3),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Text(
                _formatTime(seconds),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const TimerControls(),
          ],
        ),
      ),
    );
  }
}
