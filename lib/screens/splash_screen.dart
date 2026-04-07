import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/utils/asset_path.dart';

import 'main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    movetoNextScreen();
  }

  Future<void> movetoNextScreen() async {
    await Future.delayed(Duration(seconds: 3));

    final authProvider = context.read<AuthProvider>();
    final bool isLoggedIn = await authProvider.isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainNavScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SvgPicture.asset(AssetPaths.backgroundSVG),
        Center(child: SvgPicture.asset(AssetPaths.logoSVG)),
      ],
    ));
  }
}