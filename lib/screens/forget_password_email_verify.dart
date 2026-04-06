import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

import '../widgets/screen_background.dart';
import 'forget_password_ptp_verification.dart';

class ForgetPasswordEmailVerify extends StatefulWidget {
  // constructor
  const ForgetPasswordEmailVerify({super.key});

  @override
  // state create করা হচ্ছে
  State<ForgetPasswordEmailVerify> createState() => _ForgetPasswordEmailVerifyState();
}

class _ForgetPasswordEmailVerifyState extends State<ForgetPasswordEmailVerify> {
  
  // Login (SignUp screen) এ যাওয়ার function
  void _onTapSignUp(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>SignUpScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body তে custom background ব্যবহার করা হয়েছে
      body: ScreenBackground(
        child: Padding(
          // চারপাশে padding দেওয়া হয়েছে
          padding: const EdgeInsets.all(30.0),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // left align
            children: [
              
              // উপরের দিকে ফাঁকা জায়গা
              SizedBox(
                height: 150,
              ),
              
              // title text
              Text(
                'Your email address',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              
              // spacing
              SizedBox(
                height: 25,
              ),
              
              // email input field
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email' // placeholder
                ),
              ),
              
              // spacing
              SizedBox(height: 20,),
              
              // next button
              FilledButton(
                onPressed: () {
                  // OTP verification screen এ navigate করা হচ্ছে
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=>ForgetPasswordOtpVerification()
                    )
                  );
                },
                
                // button icon
                child: Icon(Icons.arrow_circle_right_outlined)
              ),

              // spacing
              SizedBox(height: 35,),
              
              // নিচে login option দেখানো হচ্ছে
              Center(
                child: RichText(
                  text: TextSpan(
                    // main text
                    text: " have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),
                    
                    children: [
                      TextSpan(
                        // clickable text
                        text: 'Login',
                        style: TextStyle(
                          color: AppColors.Pcolor, // custom primary color
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
    );
  }
}