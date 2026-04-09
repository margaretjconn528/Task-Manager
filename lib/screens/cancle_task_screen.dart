import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../widgets/task_card.dart';

/// Screen that displays all "Cancelled" tasks.
///
/// Features:
/// - Fetch tasks on screen load
/// - Display list of cancelled tasks
/// - Allow refresh after update/delete via TaskCard callback
class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {

  /// Called when the widget is first initialized
  /// Uses post-frame callback to safely access context
  @override
  void initState() {
    super.initState();

    /// Ensures context is available before calling provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  /// Loads cancelled tasks from API via TaskProvider
  void _loadData() {
    final token = context.read<AuthProvider>().accessToken;

    /// Fetch tasks with "Cancelled" status
    context.read<TaskProvider>().fetchTasksByStatus('Cancelled', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Custom AppBar with user info
      appBar: const TmAppbar(),

      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {

          /// List of cancelled tasks
          return ListView.separated(
            itemCount: taskProvider.cancelledTaskList.length,

            /// Builds each task item
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: taskProvider.cancelledTaskList[index],

                /// Red color to indicate cancelled status
                cardColor: Colors.red,

                /// Refresh callback after update/delete
                onRefresh: _loadData,
              );
            },

            /// Space between items
            separatorBuilder: (context, index) {
              return const SizedBox(height: 4);
            },
          );
        },
      ),
    );
  }
}