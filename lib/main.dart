import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surveyor_app/view/home_screen.dart';
import 'package:surveyor_app/welcome_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  WelcomeScreen(),
    );
  }
}

