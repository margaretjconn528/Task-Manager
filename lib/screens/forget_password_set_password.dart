import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/forgot_password_provider.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/widgets/showSnackBar.dart';

import '../widgets/screen_background.dart';

class ForgetPasswordSetPassword extends StatefulWidget {
  final String email;
  final String otp;
  const ForgetPasswordSetPassword(
      {super.key, required this.email, required this.otp});

  @override
  State<ForgetPasswordSetPassword> createState() =>
      _ForgetPasswordSetPasswordState();
}

class _ForgetPasswordSetPasswordState extends State<ForgetPasswordSetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onTapSignUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showSnackbar(context, 'Passwords do not match');
      return;
    }

    final forgotProvider = context.read<ForgotPasswordProvider>();
    final response = await forgotProvider.resetPassword(
      email: widget.email,
      otp: widget.otp,
      password: _passwordController.text,
    );

    if (response.isSuccess &&
        response.responseData['status'] == 'success') {
      showSnackbar(context,
          response.responseData['message'] ?? 'Password reset successful');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      showSnackbar(context, 'Password reset failed. Try again.');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Password should be more than 6 letters and combination of numbers',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Conf Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Consumer<ForgotPasswordProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return FilledButton(
                          onPressed: _resetPassword,
                          child: Icon(Icons.arrow_circle_right_outlined));
                    },
                  ),
                  SizedBox(height: 35),
                  Center(
                    child: RichText(
                        text: TextSpan(
                            text: " have an account? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            children: [
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  color: AppColors.Pcolor,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignUp)
                        ])),
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