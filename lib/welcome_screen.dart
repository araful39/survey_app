import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surveyor_app/view/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){

          Get.to(()=>HomeScreen());
        }, child: Text("Let's Start")),
      ),
    );
  }
}
