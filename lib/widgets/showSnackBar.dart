import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Displays a SnackBar with a given message.
///
/// This is a reusable utility function to show brief feedback
/// to the user at the bottom of the screen.
///
/// [context] - The BuildContext used to access ScaffoldMessenger
/// [message] - The message to be displayed inside the SnackBar
void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      /// The main content of the SnackBar
      content: Text(message),
    ),
  );
}