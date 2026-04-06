import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/task_status_count.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../utils/urls.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status.dart';
import 'add_new_task.dart';


class NewTaskScreen extends StatefulWidget {
  // constructor
  const NewTaskScreen({super.key});

  @override
  // state create করা হচ্ছে
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  // নতুন task গুলো রাখার list
  List<TaskModel> _newTaskList = [];
  
  // task count (status অনুযায়ী) রাখার list
  List<TaskStatusCountModel> taskCountList = [];

  // সব task এর count (status অনুযায়ী) আনার method
  Future<void> getAllTaskCount() async {

    // API call
    final response = await ApiCaller.getRequest(URL: Urls.TaskCountURL);

    // temporary list
    List<TaskStatusCountModel> taskCount = [];

    // ⚠️ empty setState (দরকার নেই)
    setState(() {

    });

    // success হলে
    if(response.isSuccess){
      for(Map<String,dynamic> jsonData in response.responseData['data']){
        // json থেকে model তৈরি
        taskCount.add(TaskStatusCountModel.formJson(jsonData));
      }
    }else{
      // error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']))
      );
    }

    // main list update
    taskCountList = taskCount;
  }

  // নতুন task list আনার method
  Future<void> getNewTask() async {

    // API call (New status)
    final response = await ApiCaller.getRequest(
      URL: Urls.TaskByStatusURL('New')
    );

    // temporary list
    List<TaskModel> newTask = [];

    // ⚠️ empty setState (দরকার নেই)
    setState(() {

    });

    // success হলে
    if(response.isSuccess){
      for(Map<String,dynamic> jsonData in response.responseData['data']){
        newTask.add(TaskModel.fromJson(jsonData));
      }
    }else{
      // error show
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']))
      );
    }

    // main list update
    _newTaskList = newTask;
  }

  @override
  void initState() {
    super.initState();

    // screen load হলে দুইটা API call হচ্ছে
    getAllTaskCount();
    getNewTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // custom appbar
      appBar: TmAppbar(),
      
      body: Column(
        children: [
          
          // task count section
          Padding(
            padding: const EdgeInsets.all(8.0),
            
            child: SizedBox(
              height: 90,
              
              child: ListView.separated(
                scrollDirection: Axis.horizontal, // horizontal scroll
                
                itemCount: taskCountList.length,
                
                itemBuilder: (context,index){
                  // debug print
                  print(taskCountList[index]);
                  
                  return TaskCountByStatus(
                    title: taskCountList[index].status, // status name
                    count: taskCountList[index].count, // count number
                  );
                },
                
                separatorBuilder: (context,index){
                  return SizedBox(width: 10,);
                },
              ),
            ),
          ),

          // task list section
          Expanded(
            child: ListView.separated(
              itemCount: _newTaskList.length,
              
              itemBuilder: (context,index){
                return TaskCard(
                  taskModel: _newTaskList[index], // current task
                  
                  cardColor: Colors.blue, // new task color
                  
                  // refresh function
                  refreshParent: () {
                    getAllTaskCount();
                    getNewTask();
                  },
                );
              },
              
              separatorBuilder: (context,index){
                return Divider(); // divider line
              },
            ),
          )
        ],
      ),
      
      // add new task button
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>AddNewTask())
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}