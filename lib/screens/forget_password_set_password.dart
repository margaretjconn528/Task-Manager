import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

import '../widgets/screen_background.dart';
import 'forget_password_ptp_verification.dart';


class ForgetPasswordSetPassword extends StatefulWidget {
  // constructor
  const ForgetPasswordSetPassword({super.key});

  @override
  // state create করা হচ্ছে
  State<ForgetPasswordSetPassword> createState() => _ForgetPasswordSetPasswordState();
}

class _ForgetPasswordSetPasswordState extends State<ForgetPasswordSetPassword> {

  // SignUp screen এ যাওয়ার function (⚠️ নামটা misleading)
  void _onTapSignUp(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>SignUpScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background সহ UI
      body: ScreenBackground(
        child: Padding(
          // চারপাশে padding
          padding: const EdgeInsets.all(30.0),
          
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // left align
              children: [
                
                // উপরের দিকে space
                SizedBox(
                  height: 150,
                ),
                
                // title text
                Text(
                  'Set Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                
                SizedBox(height: 10,),
                
                // password rule text
                Text(
                  'Password should be more than 6 letters and combination of numbers',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.grey // grey color
                  ),
                ),
                
                SizedBox(
                  height: 25,
                ),
                
                // password input field
                TextFormField(
                  obscureText: true, // password hide থাকবে
                  
                  decoration: InputDecoration(
                    hintText: 'Password'
                  ),
                ),
                
                SizedBox(height: 10,),
                
                // confirm password input field
                TextFormField(
                  obscureText: true, // password hide
                  
                  decoration: InputDecoration(
                    hintText: 'Conf Password'
                  ),
                ),
                
                SizedBox(height: 20,),
                
                // submit button
                FilledButton(
                  onPressed: () {
                    // password set হওয়ার পর login screen এ redirect
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context)=>LoginScreen())
                    );
                  },
                  
                  // button icon
                  child: Icon(Icons.arrow_circle_right_outlined)
                ),

                SizedBox(height: 35,),
                
                // নিচে login option
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: " have an account? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                      ),
                      
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: AppColors.Pcolor,
                            fontWeight: FontWeight.bold
                          ),
                          
                          // tap করলে function call হবে
                          recognizer: TapGestureRecognizer()
                            ..onTap = _onTapSignUp
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
    );
  }
}