import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/urls.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/widgets/showSnackBar.dart';

import '../widgets/screen_background.dart';
import 'forget_password_ptp_verification.dart';

class ForgetPasswordEmailVerify extends StatefulWidget {
  const ForgetPasswordEmailVerify({super.key});

  @override
  State<ForgetPasswordEmailVerify> createState() => _ForgetPasswordEmailVerifyState();
}

class _ForgetPasswordEmailVerifyState extends State<ForgetPasswordEmailVerify> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  void _onTapSignUp(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>SignUpScreen())
    );
  }

  Future<void> _verifyEmail() async {
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _inProgress = true;
    });

    String email = _emailController.text.trim();
    ApiResponse response = await ApiCaller.getRequest(URL: Urls.RecoverVerifyEmail(email));

    setState(() {
      _inProgress = false;
    });

    if(response.isSuccess && response.responseData['status'] == 'success') {
      showSnackbar(context, response.responseData['message'] ?? 'OTP sent to email');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context)=>ForgetPasswordOtpVerification(email: email)
        )
      );
    } else {
      showSnackbar(context, 'Verification failed. Try again.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Text(
                    'Your email address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email'
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Enter your email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _inProgress 
                    ? Center(child: CircularProgressIndicator()) 
                    : FilledButton(
                        onPressed: _verifyEmail,
                        child: Icon(Icons.arrow_circle_right_outlined)
                      ),
                  SizedBox(height: 35),
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
                            recognizer: TapGestureRecognizer()..onTap = _onTapSignUp
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