import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Application root widget
import 'package:task_manager/app.dart';

// Providers for state management
import 'package:task_manager/providers/add_task_provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/forgot_password_provider.dart';
import 'package:task_manager/providers/login_provider.dart';
import 'package:task_manager/providers/profile_provider.dart';
import 'package:task_manager/providers/sign_up_provider.dart';
import 'package:task_manager/providers/task_provider.dart';

/// Entry point of the application.
/// Initializes dependency injection using MultiProvider
/// and bootstraps the main application widget.
void main() {
  runApp(
    /// MultiProvider is used to register multiple providers
    /// at the root of the widget tree for global state management.
    MultiProvider(
      providers: [
        /// Handles authentication state (login status, user session, etc.)
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        /// Manages task-related operations (CRUD, filtering, etc.)
        ChangeNotifierProvider(create: (_) => TaskProvider()),

        /// Handles login form logic and API calls
        ChangeNotifierProvider(create: (_) => LoginProvider()),

        /// Handles user registration (sign-up) logic
        ChangeNotifierProvider(create: (_) => SignUpProvider()),

        /// Manages adding new tasks
        ChangeNotifierProvider(create: (_) => AddTaskProvider()),

        /// Handles forgot password workflow (email verification, reset, etc.)
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),

        /// Manages user profile data and updates
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],

      /// Root widget of the application
      /// This contains MaterialApp and route configurations
      child: TaskManagerApp(),
    ),
  );
}