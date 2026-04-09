import 'package:flutter/material.dart';

/// A reusable UI widget that displays task count by status.
///
/// Example:
/// - "New: 5"
/// - "Completed: 10"
///
/// Typically used in dashboard/statistics section.
class TaskCountByStatus extends StatelessWidget {
  /// Title representing task status (e.g., New, Completed)
  final String title;

  /// عدد of tasks for the given status
  final int count;

  const TaskCountByStatus({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        /// Internal spacing for better UI appearance
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Displays task count (highlighted)
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),

            /// Displays task status label
            Text(title),
          ],
        ),
      ),
    );
  }
}