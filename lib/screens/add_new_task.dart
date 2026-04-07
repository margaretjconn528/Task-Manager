import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/add_task_provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import 'main_nav_screen.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _addNewTask() async {
    final addTaskProvider = context.read<AddTaskProvider>();
    final token = context.read<AuthProvider>().accessToken;

    final response = await addTaskProvider.addTask(
      title: titleController.text,
      description: descriptionController.text,
      token: token,
    );

    if (response.isSuccess) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Task added..!')));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainNavScreen()),
        (predicate) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.responseData['data'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppbar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    'Add new Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(hintText: 'Description'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter Description';
                      }
                      return null;
                    },
                  ),
                  Consumer<AddTaskProvider>(
                    builder: (context, addTaskProvider, child) {
                      if (addTaskProvider.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addNewTask();
                            }
                          },
                          child: Icon(Icons.arrow_circle_right_outlined));
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
}