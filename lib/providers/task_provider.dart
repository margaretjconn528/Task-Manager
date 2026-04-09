import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/models/task_status_count.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

/// Provider responsible for managing all task-related operations.
///
/// Responsibilities:
/// - Fetch tasks by status (New, Progress, Completed, Cancelled)
/// - Fetch task count summary
/// - Delete task
/// - Update task status
/// - Maintain in-memory task lists for UI
class TaskProvider extends ChangeNotifier {
  /// Task lists categorized by status
  List<TaskModel> _newTaskList = [];
  List<TaskModel> _progressTaskList = [];
  List<TaskModel> _completedTaskList = [];
  List<TaskModel> _cancelledTaskList = [];

  /// Task count summary (e.g., number of tasks per status)
  List<TaskStatusCountModel> _taskCountList = [];

  /// Public getters for UI access
  List<TaskModel> get newTaskList => _newTaskList;
  List<TaskModel> get progressTaskList => _progressTaskList;
  List<TaskModel> get completedTaskList => _completedTaskList;
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;
  List<TaskStatusCountModel> get taskCountList => _taskCountList;

  /// Fetches tasks based on a given status
  ///
  /// [status] - Task status (New, Progress, Completed, Cancelled)
  /// [token] - Authorization token
  ///
  /// Returns:
  /// - true if request is successful
  /// - false otherwise
  Future<bool> fetchTasksByStatus(String status, String? token) async {
    final response = await ApiCaller.getRequest(
      URL: Urls.TaskByStatusURL(status),
      token: token,
    );

    /// Temporary list to store parsed tasks
    List<TaskModel> tasks = [];

    /// Validate response and parse JSON data
    if (response.isSuccess &&
        response.responseData != null &&
        response.responseData['data'] != null) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        tasks.add(TaskModel.fromJson(jsonData));
      }
    }

    /// Assign tasks to corresponding list based on status
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

  /// Fetches task count summary from API
  ///
  /// Returns:
  /// - true if successful
  /// - false otherwise
  Future<bool> fetchTaskCounts(String? token) async {
    final response = await ApiCaller.getRequest(
      URL: Urls.TaskCountURL,
      token: token,
    );

    /// Temporary list for parsed task counts
    List<TaskStatusCountModel> taskCount = [];

    /// Validate and parse response
    if (response.isSuccess &&
        response.responseData != null &&
        response.responseData['data'] != null) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        taskCount.add(TaskStatusCountModel.formJson(jsonData));
      }
    }

    /// Update state
    _taskCountList = taskCount;

    notifyListeners();
    return response.isSuccess;
  }

  /// Deletes a task by ID
  ///
  /// [taskId] - Unique identifier of the task
  /// [token] - Authorization token
  ///
  /// Returns:
  /// - true if deletion successful
  Future<bool> deleteTask(String taskId, String? token) async {
    final response = await ApiCaller.getRequest(
      URL: Urls.DeleteTaskURL(taskId),
      token: token,
    );

    notifyListeners();
    return response.isSuccess;
  }

  /// Updates task status (e.g., New → Progress → Completed)
  ///
  /// [taskId] - Task ID
  /// [status] - New status value
  /// [token] - Authorization token
  ///
  /// Returns:
  /// - true if update successful
  Future<bool> changeTaskStatus(
      String taskId, String status, String? token) async {
    final response = await ApiCaller.getRequest(
      URL: Urls.ChangeStatusURL(taskId, status),
      token: token,
    );

    notifyListeners();
    return response.isSuccess;
  }
}