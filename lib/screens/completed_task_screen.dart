import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../widgets/task_card.dart';

/// Screen that displays all "Completed" tasks.
///
/// Features:
/// - Fetch completed tasks on screen load
/// - Display list of completed tasks
/// - Allow refresh after update/delete via TaskCard callback
class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  /// Called when the widget is initialized
  /// Uses post-frame callback to safely access context
  @override
  void initState() {
    super.initState();

    /// Ensures provider access after first frame render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  /// Loads completed tasks from API via TaskProvider
  void _loadData() {
    final token = context.read<AuthProvider>().accessToken;

    /// Fetch tasks with "Completed" status
    context.read<TaskProvider>().fetchTasksByStatus('Completed', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Custom AppBar with user info and logout
      appBar: const TmAppbar(),

      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {

          /// Displays list of completed tasks
          return ListView.separated(
            itemCount: taskProvider.completedTaskList.length,

            /// Builds each task card
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: taskProvider.completedTaskList[index],

                /// Green color indicates completed status
                cardColor: Colors.green,

                /// Refresh list after update/delete
                onRefresh: _loadData,
              );
            },

            /// Spacing between list items
            separatorBuilder: (context, index) {
              return const SizedBox(height: 4);
            },
          );
        },
      ),
    );
  }
}