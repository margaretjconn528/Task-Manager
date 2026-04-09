import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/login_provider.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

import '../widgets/screen_background.dart';
import 'forget_password_email_verify.dart';
import 'main_nav_screen.dart';

/// Login screen responsible for user authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Controller for email input
  final TextEditingController _emailController = TextEditingController();

  /// Controller for password input
  final TextEditingController _passwordController = TextEditingController();

  /// Handles user login process
  Future<void> _signIn() async {
    final loginProvider = context.read<LoginProvider>();
    final authProvider = context.read<AuthProvider>();

    // Call login API
    final response = await loginProvider.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (response.isSuccess) {
      // Parse user data from response
      UserModel model =
          UserModel.fromJson(response.responseData['data']);

      // Extract access token
      String accessToken = response.responseData['token'];

      // Save user session data (local storage / secure storage)
      await authProvider.saveUserData(model, accessToken);

      // Navigate to main app screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavScreen()),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign In success..!')),
      );
    } else {
      // Show error message from API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data'])),
      );
    }
  }

  /// Navigate to Sign Up screen
  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  void dispose() {
    /// Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),

                  /// Screen title
                  Text(
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 25),

                  /// Email input field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  /// Password input field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter password';
                      }
                      return null;
                    },
                  ),

                  /// Login button with loading state
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, child) {
                      if (loginProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signIn();
                          }
                        },
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 35),

                  /// Bottom section (forgot password & sign up)
                  Center(
                    child: Column(
                      children: [
                        /// Navigate to forgot password flow
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ForgetPasswordEmailVerify(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forget password ?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),

                        /// Navigate to Sign Up
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.Pcolor,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSignUp,
                              )
                            ],
                          ),
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