import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Controller/auth_controller.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';
import '../widgets/screen_background.dart';
import 'forget_password_email_verify.dart';
import 'main_nav_screen.dart';


class LoginScreen extends StatefulWidget {
  // constructor
  const LoginScreen({super.key});

  @override
  // state create করা হচ্ছে
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form validation এর জন্য key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // email input controller
  final TextEditingController _emailController = TextEditingController();
  
  // password input controller
  final TextEditingController _passwordController = TextEditingController();
  
  // loading state
  bool isLoading = false;

  // login function (API call)
  Future <void> _signIn() async {
    
    // request body তৈরি করা হচ্ছে
    Map<String,dynamic> requestBody = {
      "email": _emailController.text, // email নেওয়া হচ্ছে
      "password": _passwordController.text, // password নেওয়া হচ্ছে
    };

    // loading true করা হচ্ছে
    setState(() {
      isLoading = true;
    });

    // API call করা হচ্ছে
    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.LoginUrl,
      body: requestBody,
    );

    // loading false করা হচ্ছে
    setState(() {
      isLoading = false;
    });

    // যদি login success হয়
    if(response.isSuccess){
      
      // response থেকে user model তৈরি করা হচ্ছে
      UserModel model = UserModel.fromJson(response.responseData['data']);
      
      // token নেওয়া হচ্ছে
      String accessToken = response.responseData['token'];

      // user data local storage এ save করা হচ্ছে
      AuthController.saveUserData(model, accessToken);

      // main screen এ redirect
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>MainNavScreen())
      );

      // success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign In success..!'))
      );

    }else{
      // error message দেখানো হচ্ছে
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']))
      );
    }
  }

  // SignUp screen এ যাওয়ার function
  void _onTapSignUp(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>SignUpScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background widget
      body: ScreenBackground(
        child: Padding(
          // padding দেওয়া হয়েছে
          padding: const EdgeInsets.all(20.0),
          
          child: SingleChildScrollView(
            child: Form(
              // form key assign
              key: _formKey,
              
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // left align
              children: [
                
                // top spacing
                SizedBox(
                  height: 150,
                ),
                
                // title text
                Text(
                  'Get Started With',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                
                SizedBox(
                  height: 25,
                ),
                
                // email input field
                TextFormField(
                  controller: _emailController,
                  
                  // validation
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please Enter email';
                    }else{
                      return null;
                    }
                  },

                  decoration: InputDecoration(hintText: 'Email'),
                ),
                
                SizedBox(
                  height: 10,
                ),
                
                // password input field
                TextFormField(
                  controller: _passwordController,
                  
                  obscureText: true, // password hide
                  
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please Enter First name'; // ⚠️ message ভুল (password হওয়া উচিত)
                    }else{
                      return null;
                    }
                  },
                  
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                
                // login button
                FilledButton(
                  onPressed: () {
                    // form validate করা হচ্ছে
                    if(_formKey.currentState!.validate()){
                      _signIn(); // API call
                    }
                  },
                  child: Icon(Icons.arrow_circle_right_outlined)
                ),

                SizedBox(height: 35,),
                
                // নিচের section (forgot password + signup)
                Center(
                  child: Column(
                    children: [
                      
                      // forget password button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>ForgetPasswordEmailVerify())
                          );
                        },
                        child: Text(
                          'Forget password ?',
                          style: TextStyle(color: Colors.grey),
                        )
                      ),

                      // signup text with clickable span
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                          
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(color: AppColors.Pcolor,fontWeight: FontWeight.bold),
                              
                              // tap করলে signup screen এ যাবে
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignUp
                            )
                          ]
                        )
                      )
                    ],
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