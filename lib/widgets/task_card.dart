import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/showSnackBar.dart';

class TaskCard extends StatelessWidget {
  final TaskModel taskModel;
  final Color cardColor;
  final VoidCallback onRefresh;

  const TaskCard({
    super.key,
    required this.taskModel,
    required this.cardColor,
    required this.onRefresh,
  });

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

  Future<void> _changeStatus(BuildContext context, String status) async {
    final taskProvider = context.read<TaskProvider>();
    final token = context.read<AuthProvider>().accessToken;

    final success =
        await taskProvider.changeTaskStatus(taskModel.id, status, token);

    if (success) {
      onRefresh();
      Navigator.pop(context);
      showSnackbar(context, 'Task Status updated');
    } else {
      showSnackbar(context, 'Failed to update status');
    }
  }

  void _showChangeStatusDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('Change Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => _changeStatus(context, 'New'),
                  title: Text('New'),
                  trailing: taskModel.status == 'New'
                      ? Icon(Icons.done)
                      : null,
                ),
                ListTile(
                  onTap: () => _changeStatus(context, 'Progress'),
                  title: Text('Progress'),
                  trailing: taskModel.status == 'Progress'
                      ? Icon(Icons.done)
                      : null,
                ),
                ListTile(
                  onTap: () => _changeStatus(context, 'Completed'),
                  title: Text('Completed'),
                  trailing: taskModel.status == 'Completed'
                      ? Icon(Icons.done)
                      : null,
                ),
                ListTile(
                  onTap: () => _changeStatus(context, 'Cancelled'),
                  title: Text('Cancelled'),
                  trailing: taskModel.status == 'Cancelled'
                      ? Icon(Icons.done)
                      : null,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(
            taskModel.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(taskModel.description),
              Text('Date: ${taskModel.createdDate}'),
              Row(
                children: [
                  Chip(
                    label: Text(taskModel.status),
                    backgroundColor: cardColor,
                    labelStyle: TextStyle(color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () => _showChangeStatusDialog(context),
                      icon: Icon(Icons.edit_note_rounded,
                          color: Colors.orange)),
                  IconButton(
                      onPressed: () => _deleteTask(context),
                      icon: Icon(Icons.delete, color: Colors.red)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
