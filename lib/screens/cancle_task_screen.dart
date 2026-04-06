import 'package:flutter/material.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../data/models/task_model.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';
import '../widgets/task_card.dart';


class CancelTaskScreen extends StatefulWidget {
  // constructor
  const CancelTaskScreen({super.key});

  @override
  // state create করা হচ্ছে
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  // cancelled task গুলো রাখার জন্য list
  List<TaskModel> TaskList = [];

  // API থেকে cancelled task আনার method
  Future<void> getProgressTask() async {

    // API call করা হচ্ছে (Cancelled status অনুযায়ী)
    final response = await ApiCaller.getRequest(
      URL: Urls.TaskByStatusURL('Cancelled')
    );

    // temporary list
    List<TaskModel> taskList = [];

    // UI refresh trigger (⚠️ এখানে empty setState, দরকার নেই)
    setState(() {

    });

    // যদি API success হয়
    if(response.isSuccess){
      // response থেকে data নিয়ে loop চালানো হচ্ছে
      for(Map<String,dynamic> jsonData in response.responseData['data']){
        // json থেকে TaskModel তৈরি করে list এ add করা হচ্ছে
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

    // screen load হলে API call করা হচ্ছে
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
            taskModel: TaskList[index], // current task pass করা হচ্ছে
            
            cardColor: Colors.red, // cancelled task এর জন্য লাল color
            
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