import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/sign_up_provider.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

import '../widgets/screen_background.dart';

// SignUp screen where user can create a new account
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  // Key to manage form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers to get user input from text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Clear all input fields after successful signup
  _clearTextField() {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }

  // Function to call signup API via provider
  Future<void> _signUp() async {

    // Get provider instance
    final signUpProvider = context.read<SignUpProvider>();

    // Call signup method with user input data
    final response = await signUpProvider.signUp(
      email: _emailController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      mobile: _mobileController.text,
      password: _passwordController.text,
    );

    // Handle success response
    if (response.isSuccess) {
      _clearTextField(); // clear fields
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign up success..!')));
    } else {
      // Show error message from API
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.responseData['data'])));
    }
  }

  // Navigate to Login screen when user taps "Login"
  void _onTaplogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Custom background widget
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),

          // Scrollable view to avoid overflow when keyboard appears
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // attach form key

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150),

                  // Title text
                  Text(
                    'Join with Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  SizedBox(height: 25),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),

                    // Validation logic
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  // First Name field
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: 'First name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter First name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  // Last Name field
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: 'Last name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Last name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  // Mobile number field
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter phone number';
                      } else if (value.length != 11) {
                        return 'Please enter correct phone number';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true, // hide password
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter password';
                      }
                      return null;
                    },
                  ),

                  // Listen to loading state from provider
                  Consumer<SignUpProvider>(
                    builder: (context, signUpProvider, child) {

                      // Show loader when API call is in progress
                      if (signUpProvider.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // Signup button
                      return FilledButton(
                          onPressed: () {

                            // Validate form before submitting
                            if (_formKey.currentState!.validate()) {
                              _signUp();
                            }
                          },
                          child: Icon(Icons.arrow_circle_right_outlined));
                    },
                  ),

                  SizedBox(height: 35),

                  // Bottom text with clickable Login option
                  Center(
                    child: RichText(
                        text: TextSpan(
                            text: "Have an account? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            children: [

                          // Clickable Login text
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  color: AppColors.Pcolor,
                                  fontWeight: FontWeight.bold),

                              // Gesture recognizer to handle tap
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTaplogin)
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