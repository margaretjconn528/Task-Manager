import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/showSnackBar.dart';

/// A reusable UI component that represents a single Task item.
///
/// Displays task details such as title, description, date, and status.
/// Also provides actions for:
/// - Deleting a task
/// - Updating task status
class TaskCard extends StatelessWidget {
  /// Task data model containing all task-related information
  final TaskModel taskModel;

  /// Background color of the status chip
  final Color cardColor;

  /// Callback to refresh parent UI after any update (delete/status change)
  final VoidCallback onRefresh;

  const TaskCard({
    super.key,
    required this.taskModel,
    required this.cardColor,
    required this.onRefresh,
  });

  /// Deletes the current task using TaskProvider
  /// and shows feedback via Snackbar
  Future<void> _deleteTask(BuildContext context) async {
    final taskProvider = context.read<TaskProvider>();
    final token = context.read<AuthProvider>().accessToken;

    final success = await taskProvider.deleteTask(taskModel.id, token);

    if (success) {
      onRefresh();
      showSnackbar(context, 'Task Deleted');
    } else {
      showSnackbar(context, 'Failed to delete task');
    }
  }

  /// Updates the task status (e.g., New, Progress, Completed, Cancelled)
  /// and refreshes the UI on success
  Future<void> _changeStatus(BuildContext context, String status) async {
    final taskProvider = context.read<TaskProvider>();
    final token = context.read<AuthProvider>().accessToken;

    final success =
        await taskProvider.changeTaskStatus(taskModel.id, status, token);

    if (success) {
      onRefresh();

      /// Close the dialog after successful update
      Navigator.pop(context);

      showSnackbar(context, 'Task Status updated');
    } else {
      showSnackbar(context, 'Failed to update status');
    }
  }

  /// Displays a dialog for selecting and updating task status
  void _showChangeStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Status'),

          /// List of available statuses
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Each ListTile represents a status option
              /// Shows a check icon if it is the current status
              ListTile(
                onTap: () => _changeStatus(context, 'New'),
                title: const Text('New'),
                trailing: taskModel.status == 'New'
                    ? const Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () => _changeStatus(context, 'Progress'),
                title: const Text('Progress'),
                trailing: taskModel.status == 'Progress'
                    ? const Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () => _changeStatus(context, 'Completed'),
                title: const Text('Completed'),
                trailing: taskModel.status == 'Completed'
                    ? const Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () => _changeStatus(context, 'Cancelled'),
                title: const Text('Cancelled'),
                trailing: taskModel.status == 'Cancelled'
                    ? const Icon(Icons.done)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      /// Outer spacing around each task card
      padding: const EdgeInsets.all(8.0),

      child: Card(
        child: ListTile(
          /// Task title with customized theme styling
          title: Text(
            taskModel.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 18),
          ),

          /// Task details section
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Task description
              Text(taskModel.description),

              /// Task creation date
              Text('Date: ${taskModel.createdDate}'),

              /// Status + Action buttons row
              Row(
                children: [
                  /// Status indicator chip
                  Chip(
                    label: Text(taskModel.status),
                    backgroundColor: cardColor,
                    labelStyle: const TextStyle(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  /// Pushes action buttons to the right
                  const Spacer(),

                  /// Edit status button
                  IconButton(
                    onPressed: () => _showChangeStatusDialog(context),
                    icon: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.orange,
                    ),
                  ),

                  /// Delete task button
                  IconButton(
                    onPressed: () => _deleteTask(context),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}