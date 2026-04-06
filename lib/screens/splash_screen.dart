import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/Controller/auth_controller.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/utils/asset_path.dart';

import 'main_nav_screen.dart';


class SplashScreen extends StatefulWidget {
  // constructor
  const SplashScreen({super.key});

  @override
  // state create করা হচ্ছে
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    
    // app start হলে next screen এ যাওয়ার function call
    movetoNextScreen();
  }

  // next screen এ যাওয়ার function
  Future<void> movetoNextScreen() async {
    
    // ৩ সেকেন্ড delay (splash screen দেখানোর জন্য)
    await Future.delayed(Duration(seconds: 3));
    
    // local storage থেকে user data load করা হচ্ছে
    await AuthController.getUserData();
    
    // user login আছে কিনা check করা হচ্ছে
    final bool isLoggIn = await AuthController.isUserLoggeIn();

    // যদি user already login থাকে
    if(isLoggIn){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>MainNavScreen())
      );

    }else{
      // না থাকলে login screen এ পাঠানো হচ্ছে
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>LoginScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background SVG image
          SvgPicture.asset(AssetPaths.backgroundSVG),
          
          // center এ logo দেখানো হচ্ছে
          Center(
            child: SvgPicture.asset(AssetPaths.logoSVG)
          ),
        ],
      )
    );
  }
}