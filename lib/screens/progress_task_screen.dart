import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../widgets/task_card.dart';

// This screen shows all tasks that are currently in "Progress" status
class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  // Called once when the widget is inserted into the widget tree
  @override
  void initState() {
    super.initState();

    // Ensures that _loadData() runs AFTER the first frame is rendered
    // Useful when using context inside initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  // Function to load tasks from API based on "Progress" status
  void _loadData() {
    // Get access token from AuthProvider
    final token = context.read<AuthProvider>().accessToken;

    // Call provider method to fetch tasks with "Progress" status
    context.read<TaskProvider>().fetchTasksByStatus('Progress', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom AppBar widget
      appBar: TmAppbar(),

      // Consumer listens to TaskProvider changes and rebuilds UI automatically
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {

          // ListView to display tasks with spacing between items
          return ListView.separated(

            // Total number of progress tasks
            itemCount: taskProvider.progressTaskList.length,

            // Builds each task item
            itemBuilder: (context, index) {
              return TaskCard(
                // Passing individual task data
                taskModel: taskProvider.progressTaskList[index],

                // Card color for progress tasks
                cardColor: Colors.purple,

                // Callback function to refresh data after any update
                onRefresh: _loadData,
              );
            },

            // Adds spacing between list items
            separatorBuilder: (context, index) {
              return SizedBox(height: 4);
            },
          );
        },
      ),
    );
  }
}