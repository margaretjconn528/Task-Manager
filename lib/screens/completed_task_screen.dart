import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final token = context.read<AuthProvider>().accessToken;
    context.read<TaskProvider>().fetchTasksByStatus('Completed', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppbar(),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return ListView.separated(
            itemCount: taskProvider.completedTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: taskProvider.completedTaskList[index],
                cardColor: Colors.green,
                onRefresh: _loadData,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4);
            },
          );
        },
      ),
    );
  }
}