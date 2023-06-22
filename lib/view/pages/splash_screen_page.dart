import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => Get.offNamed('/welcome'));
  }

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
