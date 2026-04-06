import 'package:flutter/material.dart';
import 'package:task_manager/screens/cancle_task_screen.dart';
import 'package:task_manager/screens/completed_task_screen.dart';
import 'package:task_manager/screens/new_task_screen.dart';
import 'package:task_manager/screens/progress_task_screen.dart';

class MainNavScreen extends StatefulWidget {
  // constructor
  const MainNavScreen({super.key});

  @override
  // state create করা হচ্ছে
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  // বর্তমানে কোন tab selected আছে তা রাখার জন্য index
  int _selectedIndex = 0;

  // সব screen এর list (bottom navigation অনুযায়ী)
  List _screens = [
    NewTaskScreen(),        // index 0 → New Task screen
    ProgressTaskScreen(),   // index 1 → Progress Task screen
    CompletedTaskScreen(),  // index 2 → Completed Task screen
    CancelTaskScreen(),     // index 3 → Cancelled Task screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // selected index অনুযায়ী screen show করা হচ্ছে
      body: _screens[_selectedIndex],
      
      // bottom navigation bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex, // current selected tab
        
        // tab change হলে এই function call হবে
        onDestinationSelected: (int index){
          _selectedIndex = index; // নতুন index assign
          
          // UI refresh করা হচ্ছে
          setState(() {

          });
        },
        
        // navigation items (tabs)
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.task), 
            label: 'New' // নতুন task tab
          ),
          
          NavigationDestination(
            icon: Icon(Icons.refresh), 
            label: 'Progress' // চলমান task
          ),
          
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined), 
            label: 'Completed' // সম্পন্ন task
          ),
          
          NavigationDestination(
            icon: Icon(Icons.cancel), 
            label: 'Cancel' // বাতিল task
          ),
        ]
      ),
    );
  }
}