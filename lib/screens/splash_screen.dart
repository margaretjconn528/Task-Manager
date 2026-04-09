import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/utils/asset_path.dart';

import 'main_nav_screen.dart';

// Splash screen shown when app starts
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Called when widget is first created
  @override
  void initState() {
    super.initState();

    // Start navigation logic after splash delay
    movetoNextScreen();
  }

  // Handles delay and navigation decision
  Future<void> movetoNextScreen() async {

    // Wait for 3 seconds (splash screen duration)
    await Future.delayed(Duration(seconds: 3));

    // Get AuthProvider instance
    final authProvider = context.read<AuthProvider>();

    // Check if user is already logged in (token/session exists)
    final bool isLoggedIn = await authProvider.isUserLoggedIn();

    // Navigate based on login status
    if (isLoggedIn) {

      // If logged in → go to main navigation screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainNavScreen()));
    } else {

      // If not logged in → go to login screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // Stack used to place background and logo on top of each other
        body: Stack(
      children: [

        // Background SVG image
        SvgPicture.asset(AssetPaths.backgroundSVG),

        // Centered logo SVG
        Center(child: SvgPicture.asset(AssetPaths.logoSVG)),
      ],
    ));
  }
}