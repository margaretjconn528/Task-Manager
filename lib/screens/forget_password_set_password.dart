import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/forgot_password_provider.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/widgets/showSnackBar.dart';

import '../widgets/screen_background.dart';

/// Screen responsible for setting a new password after OTP verification
class ForgetPasswordSetPassword extends StatefulWidget {
  /// User email used for password reset
  final String email;

  /// OTP used for verification
  final String otp;

  const ForgetPasswordSetPassword({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ForgetPasswordSetPassword> createState() =>
      _ForgetPasswordSetPasswordState();
}

class _ForgetPasswordSetPasswordState extends State<ForgetPasswordSetPassword> {
  /// Controller for password input field
  final TextEditingController _passwordController = TextEditingController();

  /// Controller for confirm password input field
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  /// Global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Navigate to Sign Up screen
  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  /// Handles password reset logic
  Future<void> _resetPassword() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if password and confirm password match
    if (_passwordController.text != _confirmPasswordController.text) {
      showSnackbar(context, 'Passwords do not match');
      return;
    }

    // Access provider for API call
    final forgotProvider = context.read<ForgotPasswordProvider>();

    // Call reset password API
    final response = await forgotProvider.resetPassword(
      email: widget.email,
      otp: widget.otp,
      password: _passwordController.text,
    );

    // Handle success response
    if (response.isSuccess &&
        response.responseData['status'] == 'success') {
      showSnackbar(
        context,
        response.responseData['message'] ?? 'Password reset successful',
      );

      // Navigate to login screen and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      // Handle failure response
      showSnackbar(context, 'Password reset failed. Try again.');
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
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
                  const SizedBox(height: 150),

                  /// Screen title
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 10),

                  /// Password instruction text
                  Text(
                    'Password should be more than 6 letters and combination of numbers',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  /// Password input field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
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

                  const SizedBox(height: 10),

                  /// Confirm password input field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Conf Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Submit button with loading state handling
                  Consumer<ForgotPasswordProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return FilledButton(
                        onPressed: _resetPassword,
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 35),

                  /// Redirect to login (UI text seems mismatched, kept as-is)
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: " have an account? ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppColors.Pcolor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignUp,
                          )
                        ],
                      ),
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