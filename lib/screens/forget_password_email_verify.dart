import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/forgot_password_provider.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/widgets/showSnackBar.dart';

import '../widgets/screen_background.dart';
import 'forget_password_ptp_verification.dart';

/// Screen for verifying user email in "Forgot Password" flow.
///
/// Workflow:
/// 1. User enters email
/// 2. API verifies email
/// 3. If valid → navigate to OTP verification screen
class ForgetPasswordEmailVerify extends StatefulWidget {
  const ForgetPasswordEmailVerify({super.key});

  @override
  State<ForgetPasswordEmailVerify> createState() =>
      _ForgetPasswordEmailVerifyState();
}

class _ForgetPasswordEmailVerifyState extends State<ForgetPasswordEmailVerify> {

  /// Controller for email input field
  final TextEditingController _emailController = TextEditingController();

  /// Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Navigates to SignUp screen (NOTE: naming mismatch, see suggestion below)
  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  /// Handles email verification process
  ///
  /// - Validates form
  /// - Calls API via provider
  /// - Navigates to OTP screen on success
  Future<void> _verifyEmail() async {
    /// Validate form input
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final forgotProvider = context.read<ForgotPasswordProvider>();

    /// Trim email to remove unnecessary spaces
    String email = _emailController.text.trim();

    final response = await forgotProvider.verifyEmail(email);

    /// Check API success response
    if (response.isSuccess &&
        response.responseData['status'] == 'success') {

      /// Show success message
      showSnackbar(
        context,
        response.responseData['message'] ?? 'OTP sent to email',
      );

      /// Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ForgetPasswordOtpVerification(email: email),
        ),
      );
    } else {
      /// Show error message
      showSnackbar(context, 'Verification failed. Try again.');
    }
  }

  /// Dispose controller to prevent memory leaks
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
                  const SizedBox(height: 150),

                  /// Screen title
                  Text(
                    'Your email address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 25),

                  /// Email input field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'Email'),

                    /// Basic validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Consumer for loading state handling
                  Consumer<ForgotPasswordProvider>(
                    builder: (context, provider, child) {

                      /// Show loader during API call
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      /// Submit button
                      return FilledButton(
                        onPressed: _verifyEmail,
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 35),

                  /// Navigation to login/signup section
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Have an account? ",
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
                          ),
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