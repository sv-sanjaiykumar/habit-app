import 'package:flutter/material.dart';
import '../provider/history_provider.dart';
import 'package:intl/intl.dart';

// Define the color constants (consistent with your dark theme)
const tileBackgroundColor = Color(0xFF656565);     // surface
const titleTextColor = Color(0xFFDFE5F2);          // onBackground
const subtitleTextColor = Color(0xFF656565);       // surfaceVariant
const leadingIconColor = Color(0xE400DC0E);        // green

class HistoryTile extends StatelessWidget {
  final HistoryItem item;

  const HistoryTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy • hh:mm a').format(item.completedOn);

    return Container(
      decoration: BoxDecoration(
        color: tileBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        title: Text(
          item.habitName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: titleTextColor,
          ),
        ),
        subtitle: Text(
          formattedDate,
          style: const TextStyle(
            color: subtitleTextColor,
            fontSize: 13,
          ),
        ),
        leading: const Icon(
          Icons.check_circle,
          color: leadingIconColor,
        ),
      ),
    );
  }
}
