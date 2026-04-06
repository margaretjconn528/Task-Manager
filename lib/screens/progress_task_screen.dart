import 'package:flutter/material.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../data/models/task_model.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';
import '../widgets/task_card.dart';


class ProgressTaskScreen extends StatefulWidget {
  // constructor
  const ProgressTaskScreen({super.key});

  @override
  // state create করা হচ্ছে
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  // progress task গুলো রাখার জন্য list
  List<TaskModel> TaskList = [];

  // API থেকে progress task আনার method
  Future<void> getProgressTask() async {

    // API call করা হচ্ছে (Progress status অনুযায়ী)
    final response = await ApiCaller.getRequest(
      URL: Urls.TaskByStatusURL('Progress')
    );

    // temporary list
    List<TaskModel> taskList = [];

    // ⚠️ empty setState (দরকার নেই)
    setState(() {

    });

    // যদি success হয়
    if(response.isSuccess){
      // response data loop করা হচ্ছে
      for(Map<String,dynamic> jsonData in response.responseData['data']){
        // json থেকে model তৈরি করে list এ যোগ করা হচ্ছে
        taskList.add(TaskModel.fromJson(jsonData));
      }
    }else{
      // error হলে snackbar দেখানো হচ্ছে
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']))
      );
    }

    // main list update করা হচ্ছে
    TaskList = taskList;
  }

  @override
  void initState() {
    super.initState();

    // screen load হলে API call
    getProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // custom appbar
      appBar: TmAppbar(),
      
      body: ListView.separated(
        // মোট item সংখ্যা
        itemCount: TaskList.length,
        
        // প্রতিটি item build করা হচ্ছে
        itemBuilder: (context,index){
          return TaskCard(
            taskModel: TaskList[index], // current task
            
            cardColor: Colors.purple, // progress task color
            
            refreshParent: () {  }, // parent refresh function (empty)
          );
        },
        
        // item এর মাঝে spacing
        separatorBuilder: (context,index){
          return SizedBox(
            height: 4,
          );
        },
      ),
    );
  }
}