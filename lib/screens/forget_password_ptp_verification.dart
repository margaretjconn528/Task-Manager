import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/forgot_password_provider.dart';
import 'package:task_manager/screens/sign_up_screen.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/widgets/showSnackBar.dart';

import '../widgets/screen_background.dart';
import 'forget_password_set_password.dart';

/// Screen for OTP (PIN) verification in Forgot Password flow.
///
/// Workflow:
/// 1. User receives OTP via email
/// 2. User enters 6-digit OTP
/// 3. API verifies OTP
/// 4. On success → navigate to password reset screen
class ForgetPasswordOtpVerification extends StatefulWidget {
  /// Email passed from previous step
  final String email;

  const ForgetPasswordOtpVerification({
    super.key,
    required this.email,
  });

  @override
  State<ForgetPasswordOtpVerification> createState() =>
      _ForgetPasswordOtpVerificationState();
}

class _ForgetPasswordOtpVerificationState
    extends State<ForgetPasswordOtpVerification> {

  /// Controller for OTP input
  final TextEditingController _otpController = TextEditingController();

  /// Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Navigates to SignUp screen (⚠️ naming mismatch, see suggestion)
  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  /// Handles OTP verification process
  ///
  /// - Validates form
  /// - Ensures OTP length is 6 digits
  /// - Calls API via provider
  /// - Navigates to reset password screen on success
  Future<void> _verifyOtp() async {
    /// Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    /// Ensure OTP length is exactly 6 digits
    if (_otpController.text.length != 6) {
      showSnackbar(context, 'Please enter a 6-digit OTP');
      return;
    }

    final forgotProvider = context.read<ForgotPasswordProvider>();

    /// Get OTP value
    String otp = _otpController.text;

    /// Call API to verify OTP
    final response = await forgotProvider.verifyOtp(widget.email, otp);

    /// Handle success response
    if (response.isSuccess &&
        response.responseData['status'] == 'success') {

      showSnackbar(
        context,
        response.responseData['message'] ?? 'OTP verified',
      );

      /// Navigate to password reset screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgetPasswordSetPassword(
            email: widget.email,
            otp: otp,
          ),
        ),
      );
    } else {
      /// Show error message
      showSnackbar(context, 'OTP verification failed. Try again.');
    }
  }

  /// Dispose controller to prevent memory leaks
  @override
  void dispose() {
    _otpController.dispose();
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
                    'PIN Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 25),

                  /// OTP input field (6-digit PIN)
                  PinCodeTextField(
                    appContext: context,
                    length: 6,

                    /// Hides OTP input for security
                    obscureText: true,

                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    controller: _otpController,

                    /// Custom styling for PIN fields
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(7),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveColor: Colors.grey.shade300,
                      selectedColor: AppColors.Pcolor,
                    ),

                    backgroundColor: Colors.transparent,
                  ),

                  const SizedBox(height: 20),

                  /// Consumer to listen loading state
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
                        onPressed: _verifyOtp,
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 35),

                  /// Navigation text (Login/Signup)
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
                            text: 'Sign in',
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