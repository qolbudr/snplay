import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo-alt.png', width: 150),
              const Expanded(child: SizedBox()),
              Text("Tonton Sinema", style: h1.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              const Text(
                "Tonton ribuan sinema series kesukaan anda apa saja dimana saja kapan saja.",
                style: h4,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: defaultButtonStyle,
                  onPressed: () {},
                  child: const Text("Daftar"),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: defaultButtonStyle.copyWith(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(secondaryColor),
                  ),
                  onPressed: () => Get.toNamed('/login/selection'),
                  child: const Text("Masuk"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
