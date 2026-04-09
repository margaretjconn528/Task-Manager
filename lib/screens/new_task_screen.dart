import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../widgets/task_card.dart';
import '../widgets/task_count_by_status.dart';
import 'add_new_task.dart';

/// Screen responsible for displaying "New Tasks"
/// Also shows task count summary and task list
class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();

    /// Ensures API calls happen AFTER widget is rendered
    /// (avoids context-related issues in initState)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  /// Loads task-related data from API
  void _loadData() {
    final token = context.read<AuthProvider>().accessToken;
    final taskProvider = context.read<TaskProvider>();

    // Fetch task count summary (New, Progress, Completed, Cancel)
    taskProvider.fetchTaskCounts(token);

    // Fetch only "New" tasks
    taskProvider.fetchTasksByStatus('New', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Custom reusable app bar
      appBar: TmAppbar(),

      body: Column(
        children: [
          /// Task summary (horizontal list)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 90,

              /// Listen to TaskProvider for task counts
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskProvider.taskCountList.length,

                    /// Each item shows task count by status
                    itemBuilder: (context, index) {
                      final item = taskProvider.taskCountList[index];

                      return TaskCountByStatus(
                        title: item.status,
                        count: item.count,
                      );
                    },

                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                  );
                },
              ),
            ),
          ),

          /// Task list section
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return ListView.separated(
                  itemCount: taskProvider.newTaskList.length,

                  /// Each task item card
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: taskProvider.newTaskList[index],
                      cardColor: Colors.blue,

                      /// Refresh callback after update/delete
                      onRefresh: _loadData,
                    );
                  },

                  separatorBuilder: (context, index) => const Divider(),
                );
              },
            ),
          ),
        ],
      ),

      /// Floating button to add new task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewTask()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
