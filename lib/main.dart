import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/providers/add_task_provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/forgot_password_provider.dart';
import 'package:task_manager/providers/login_provider.dart';
import 'package:task_manager/providers/profile_provider.dart';
import 'package:task_manager/providers/sign_up_provider.dart';
import 'package:task_manager/providers/task_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => AddTaskProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: TaskManagerApp(),
    ),
  );
}