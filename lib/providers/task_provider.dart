import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/models/task_status_count.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _newTaskList = [];
  List<TaskModel> _progressTaskList = [];
  List<TaskModel> _completedTaskList = [];
  List<TaskModel> _cancelledTaskList = [];
  List<TaskStatusCountModel> _taskCountList = [];

  List<TaskModel> get newTaskList => _newTaskList;
  List<TaskModel> get progressTaskList => _progressTaskList;
  List<TaskModel> get completedTaskList => _completedTaskList;
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;
  List<TaskStatusCountModel> get taskCountList => _taskCountList;

  Future<bool> fetchTasksByStatus(String status, String? token) async {
    final response = await ApiCaller.getRequest(
      URL: Urls.TaskByStatusURL(status),
      token: token,
    );

    List<TaskModel> tasks = [];

    if (response.isSuccess &&
        response.responseData != null &&
        response.responseData['data'] != null) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        tasks.add(TaskModel.fromJson(jsonData));
      }
    }

    switch (status) {
      case 'New':
        _newTaskList = tasks;
        break;
      case 'Progress':
        _progressTaskList = tasks;
        break;
      case 'Completed':
        _completedTaskList = tasks;
        break;
      case 'Cancelled':
        _cancelledTaskList = tasks;
        break;
    }

    notifyListeners();
    return response.isSuccess;
  }

  Future<bool> fetchTaskCounts(String? token) async {
    final response = await ApiCaller.getRequest(
      URL: Urls.TaskCountURL,
      token: token,
    );

    List<TaskStatusCountModel> taskCount = [];

    if (response.isSuccess &&
        response.responseData != null &&
        response.responseData['data'] != null) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        taskCount.add(TaskStatusCountModel.formJson(jsonData));
      }
    }

    _taskCountList = taskCount;
    notifyListeners();
    return response.isSuccess;
  }

  Future<bool> deleteTask(String taskId, String? token) async {
    final response = await ApiCaller.getRequest(
      URL: Urls.DeleteTaskURL(taskId),
      token: token,
    );
    notifyListeners();
    return response.isSuccess;
  }

  Future<bool> changeTaskStatus(String taskId, String status, String? token) async {
    final response = await ApiCaller.getRequest(
      URL: Urls.ChangeStatusURL(taskId, status),
      token: token,
    );
    notifyListeners();
    return response.isSuccess;
  }
}
