import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

import '../utils/urls.dart';
import '../widgets/screen_background.dart';


class SignUpScreen extends StatefulWidget {
  // constructor
  const SignUpScreen({super.key});

  @override
  // state create করা হচ্ছে
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // form validation এর জন্য key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // বিভিন্ন input field এর controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // loading state
  bool isLoading = false;

  // সব input field clear করার function
  _clearTextField(){
    _emailController.clear(); // email clear
    _firstNameController.clear(); // first name clear
    _lastNameController.clear(); // last name clear
    _mobileController.clear(); // mobile clear
    _passwordController.clear(); // password clear
  }

  // signup API call method
  Future <void> _signUp() async {
    
    // request body তৈরি করা হচ্ছে
    Map<String,dynamic> requestBody = {
      "email": _emailController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "mobile": _mobileController.text,
      "password": _passwordController.text,
    };

    // loading true
    setState(() {
      isLoading = true;
    });
    
    // API call
    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.SignUpURL,
      body: requestBody,
    );

    // loading false
    setState(() {
      isLoading = false;
    });

    // যদি success হয়
    if(response.isSuccess){
      _clearTextField(); // field clear
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up success..!'))
      );
    }else{
      // error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']))
      );
    }
  }

  // login screen এ যাওয়ার function
  void _onTaplogin(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>LoginScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          
          // scrollable করা হয়েছে (keyboard overlap avoid)
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // top spacing
                  SizedBox(
                    height: 150,
                  ),
                  
                  // title
                  Text(
                    'Join with Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  
                  SizedBox(
                    height: 25,
                  ),
                  
                  // email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please Enter email';
                      }else{
                        return null;
                      }
                    },
                  ),
                  
                  SizedBox(height: 10,),
                  
                  // first name field
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: 'First name'),
                    
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please Enter First name';
                      }else{
                        return null;
                      }
                    },
                  ),
                  
                  SizedBox(height: 10,),
                  
                  // last name field
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: 'Last name'),
                    
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please Enter Last name';
                      }else{
                        return null;
                      }
                    },
                  ),
                  
                  SizedBox(height: 10,),
                  
                  // mobile field
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please Enter phone number';
                      }else if(value.length != 11){
                        return 'Please enter correct phone number';
                      }else{
                        return null;
                      }
                    },
                  ),
                  
                  SizedBox(height: 10,),
                  
                  // password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                    
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please Enter First name'; // ⚠️ ভুল message
                      }else{
                        return null;
                      }
                    },
                  ),
                  
                  // loading হলে spinner, না হলে button
                  isLoading 
                    ? Center(child: CircularProgressIndicator())
                    : FilledButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _signUp(); // signup call
                          }
                        },
                        child: Icon(Icons.arrow_circle_right_outlined)
                      ),

                  SizedBox(height: 35,),
                  
                  // login redirect text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Have an account? ",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                        
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(color: AppColors.Pcolor,fontWeight: FontWeight.bold),
                            
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTaplogin
                          )
                        ]
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}