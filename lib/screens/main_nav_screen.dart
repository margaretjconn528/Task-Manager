import 'package:flutter/material.dart';
import 'package:task_manager/screens/cancle_task_screen.dart';
import 'package:task_manager/screens/completed_task_screen.dart';
import 'package:task_manager/screens/new_task_screen.dart';
import 'package:task_manager/screens/progress_task_screen.dart';

/// Main navigation screen that controls bottom tab navigation
class MainNavScreen extends StatefulWidget {
  /// Default constructor
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  /// Currently selected bottom navigation index
  int _selectedIndex = 0;

  /// List of screens mapped with bottom navigation tabs
  /// NOTE: Using `final` for better immutability (industry best practice)
  final List<Widget> _screens = const [
    NewTaskScreen(),        // index 0 → New Task
    ProgressTaskScreen(),   // index 1 → In Progress Task
    CompletedTaskScreen(),  // index 2 → Completed Task
    CancelTaskScreen(),     // index 3 → Cancelled Task
  ];

  /// Handles tab change event
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Displays the selected screen based on index
      body: _screens[_selectedIndex],

      /// Bottom navigation bar (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,

        /// Triggered when user taps a tab
        onDestinationSelected: _onTabChange,

        /// Navigation tabs configuration
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task),
            label: 'New', // New tasks
          ),
          NavigationDestination(
            icon: Icon(Icons.refresh),
            label: 'Progress', // Ongoing tasks
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            label: 'Completed', // Finished tasks
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel),
            label: 'Cancel', // Cancelled tasks
          ),
        ],
      ),
    );
  }
}