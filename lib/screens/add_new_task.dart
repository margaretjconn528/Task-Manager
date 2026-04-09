import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/add_task_provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import 'main_nav_screen.dart';

/// Screen for creating a new task.
///
/// Features:
/// - Form validation
/// - API integration via AddTaskProvider
/// - Loading indicator
/// - Navigation after successful task creation
class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  /// Controller for task title input
  final TextEditingController titleController = TextEditingController();

  /// Controller for task description input
  final TextEditingController descriptionController = TextEditingController();

  /// Global form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Handles task creation logic
  ///
  /// - Calls provider API
  /// - Shows success/error messages
  /// - Navigates to main screen on success
  Future<void> _addNewTask() async {
    final addTaskProvider = context.read<AddTaskProvider>();
    final token = context.read<AuthProvider>().accessToken;

    final response = await addTaskProvider.addTask(
      title: titleController.text,
      description: descriptionController.text,
      token: token,
    );

    if (response.isSuccess) {
      /// Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added..!')),
      );

      /// Navigate to main screen and clear navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavScreen()),
        (predicate) => false,
      );
    } else {
      /// Show error message from API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Custom AppBar with user info and logout
      appBar: const TmAppbar(),

      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            /// Page padding
            padding: const EdgeInsets.all(20.0),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  const SizedBox(height: 80),

                  /// Screen title
                  Text(
                    'Add new Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 20),

                  /// Title input field
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: 'Title'),

                    /// Validation for title field
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Description input field
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 6,
                    decoration:
                        const InputDecoration(hintText: 'Description'),

                    /// Validation for description field
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),

                  /// Consumer listens to loading state
                  Consumer<AddTaskProvider>(
                    builder: (context, addTaskProvider, child) {
                      /// Show loader while API call is in progress
                      if (addTaskProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      /// Submit button
                      return FilledButton(
                        onPressed: () {
                          /// Validate form before submission
                          if (_formKey.currentState!.validate()) {
                            _addNewTask();
                          }
                        },
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}