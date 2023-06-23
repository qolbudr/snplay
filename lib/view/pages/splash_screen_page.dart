import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController splashController = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo-alt.png', width: 200),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: primaryColor),
          ],
        ),
      ),
    );
  }
}
