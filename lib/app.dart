import 'package:flutter/material.dart';
import 'package:task_manager/screens/splash_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

/// Root widget of the Task Manager application.
/// Configures global theme, styling, and initial route.
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// Removes the debug banner from the top-right corner
      debugShowCheckedModeBanner: false,

      /// Global theme configuration for the application
      theme: ThemeData(
        /// Custom text styles used across the app
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),

        /// Default styling for all Input fields (TextField, TextFormField)
        inputDecorationTheme: const InputDecorationTheme(
          /// Enables background fill for input fields
          filled: true,
          fillColor: Colors.white,

          /// Hint text styling
          hintStyle: TextStyle(
            color: Colors.grey,
          ),

          /// Removes border when input is enabled
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),

          /// Default border style (no visible border)
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),

        /// Global styling for FilledButton widgets
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            /// Primary button color from centralized color config
            backgroundColor: AppColors.Pcolor,

            /// Makes button take full available width
            fixedSize: const Size.fromWidth(double.maxFinite),

            /// Vertical padding inside the button
            padding: const EdgeInsets.symmetric(vertical: 12),

            /// Rounded corner styling
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),

      /// Initial screen displayed when the app launches
      home: const SplashScreen(),
    );
  }
}