import 'package:flutter/material.dart';
import 'package:task_manager/screens/splash_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600
          )
        ),



        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          hintStyle: TextStyle(
            color: Colors.grey
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none
          ),

          border: OutlineInputBorder(
              borderSide: BorderSide.none
          )
        ),


        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.Pcolor,
            fixedSize: Size.fromWidth(double.maxFinite),
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          )
        )


      ),

      home:SplashScreen(),
    );
  }
}
