import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../widgets/task_card.dart';
import '../widgets/task_count_by_status.dart';
import 'add_new_task.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final token = context.read<AuthProvider>().accessToken;
    final taskProvider = context.read<TaskProvider>();
    taskProvider.fetchTaskCounts(token);
    taskProvider.fetchTasksByStatus('New', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppbar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 90,
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskProvider.taskCountList.length,
                    itemBuilder: (context, index) {
                      return TaskCountByStatus(
                        title: taskProvider.taskCountList[index].status,
                        count: taskProvider.taskCountList[index].count,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 10);
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return ListView.separated(
                  itemCount: taskProvider.newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: taskProvider.newTaskList[index],
                      cardColor: Colors.blue,
                      onRefresh: _loadData,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNewTask()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}