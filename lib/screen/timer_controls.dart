import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/timer_provider.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TimerButton(
            icon: timer.isRunning ? Icons.pause : Icons.play_arrow,
            tooltip: timer.isRunning ? 'Pause' : 'Start',
            onTap: () {
              timer.isRunning
                  ? timer.pauseTimer()
                  : timer.startTimer();
            },
          ),
          const SizedBox(width: 30),
          _TimerButton(
            icon: Icons.replay,
            tooltip: 'Reset',
            onTap: timer.resetTimer,
          ),
        ],
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _TimerButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0E0E0E),
            border: Border.all(
              color: const Color(0xE400DC0E),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            size: 36,
            color: const Color(0xE400DC0E),
          ),
        ),
      ),
    );
  }
}
