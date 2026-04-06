import 'package:flutter/material.dart';
import 'package:task_manager/widgets/screen_background.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';
import 'main_nav_screen.dart';


class AddNewTask extends StatefulWidget {
  // constructor (key নেওয়ার জন্য)
  const AddNewTask({super.key});

  @override
  // state create করা হচ্ছে
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  // title input এর জন্য controller
  TextEditingController titleController = TextEditingController();
  
  // description input এর জন্য controller
  TextEditingController descriptionController = TextEditingController();
  
  // form validation এর জন্য global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // loading state handle করার জন্য variable
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // custom app bar
      appBar: TmAppbar(),
      
      // background widget ব্যবহার করা হয়েছে
      body: ScreenBackground(
        child: Padding(
          // সব দিক থেকে padding দেওয়া হয়েছে
          padding: const EdgeInsets.all(20.0),
          
          child: Form(
            // form key assign করা হয়েছে
            key: _formKey,
            
            child: Column(
              children: [
                // উপরে ফাঁকা space
                SizedBox(
                  height: 80,
                ),

                // title text
                Text(
                  'Add new Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                
                // spacing
                SizedBox(
                  height: 20,
                ),

                // title input field
                TextFormField(
                  controller: titleController, // controller bind করা হয়েছে
                  
                  decoration: InputDecoration(
                    hintText: 'Title' // placeholder text
                  ),

                  // validation function
                  validator: (String ? value){
                    if(value == null || value.isEmpty){
                      return 'please enter title'; // error message
                    }
                    return null; // valid হলে null
                  },
                ),

                SizedBox(
                  height: 20,
                ),

                // description input field
                TextFormField(
                  controller: descriptionController, // controller bind
                  
                  maxLines: 6, // multi-line input
                  
                  decoration: InputDecoration(
                    hintText: 'Description'
                  ),

                  // validation
                  validator: (String ? value){
                    if(value == null || value.isEmpty){
                      return 'please enter Description';
                    }
                    return null;
                  },
                ),

                // submit button
                FilledButton(
                  onPressed: () {
                    // form validate করা হচ্ছে
                    if(_formKey.currentState!.validate()){
                      addNewTask(); // valid হলে API call
                    }
                  },
                  
                  // button icon
                  child: Icon(Icons.arrow_circle_right_outlined)
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  // নতুন task add করার method
  Future <void> addNewTask() async {
    // request body তৈরি করা হচ্ছে
    Map<String,dynamic> requestBody = {
      "title": titleController.text, // title নেওয়া হচ্ছে
      "description": descriptionController.text, // description নেওয়া হচ্ছে
      "status": "New" // default status
    };

    // loading true করা হচ্ছে
    setState(() {
      isLoading = true;
    });

    // API call করা হচ্ছে
    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.AddTaskURL,
      body: requestBody,
    );

    // loading false করা হচ্ছে
    setState(() {
      isLoading = false;
    });

    // যদি request success হয়
    if(response.isSuccess){

      // success message দেখানো হচ্ছে
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added..!'))
      );

      // main screen এ redirect করা হচ্ছে (পুরনো route remove করে)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context)=>MainNavScreen()),
        (predicate)=>false
      );

    }else{
      // error message দেখানো হচ্ছে
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']))
      );
    }
  }
}