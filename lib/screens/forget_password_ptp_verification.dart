
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/screens/sign_up_screen.dart';


import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import 'forget_password_set_password.dart';


class ForgetPasswordOtpVerification extends StatefulWidget {
  // constructor
  const ForgetPasswordOtpVerification({super.key});

  @override
  // state create করা হচ্ছে
  State<ForgetPasswordOtpVerification> createState() => _ForgetPasswordOtpVerificationState();
}

class _ForgetPasswordOtpVerificationState extends State<ForgetPasswordOtpVerification> {

  // SignUp/Login screen এ যাওয়ার function
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
                
                // উপরে space
                SizedBox(
                  height: 150,
                ),
                
                // title text
                Text(
                  'PIN Verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                
                // spacing
                SizedBox(
                  height: 25,
                ),
                
                // PIN/OTP input field
                PinCodeTextField(
                  appContext: context, // context pass করা হচ্ছে
                  
                  length: 6, // 6 digit OTP
                  
                  obscureText: true, // input hide থাকবে
                  
                  animationType: AnimationType.fade, // animation
                  
                  keyboardType: TextInputType.number, // numeric keyboard
                  
                  // pin box design
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box, // box shape
                    borderRadius: BorderRadius.circular(7), // border radius
                    fieldHeight: 50, // height
                    fieldWidth: 40, // width
                    activeFillColor: Colors.white, // active color
                    inactiveColor: Colors.grey.shade300, // inactive color
                    selectedColor: AppColors.Pcolor // selected color
                  ),
                  
                  // background transparent
                  backgroundColor: Colors.transparent,
                ),

                // spacing
                SizedBox(height: 20,),
                
                // next button
                FilledButton(
                  onPressed: () {
                    // next screen (set password) এ যাওয়া হচ্ছে
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=>ForgetPasswordSetPassword()
                      )
                    );
                  },
                  
                  // button icon
                  child: Icon(Icons.arrow_circle_right_outlined)
                ),

                // spacing
                SizedBox(height: 35,),
                
                // নিচে sign in option
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
                          text: 'Sign in',
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