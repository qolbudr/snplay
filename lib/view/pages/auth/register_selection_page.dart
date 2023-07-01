import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/register_controller.dart';

class RegisterSelection extends StatelessWidget {
  RegisterSelection({super.key});
  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                secondaryColor,
              ],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/logo-alt.png', width: 150),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                style: defaultButtonStyle.copyWith(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () => registerController.registerWithGoogle(),
                child: Row(
                  children: [
                    Image.asset('assets/images/logo-google.png', width: 28),
                    const SizedBox(width: 10),
                    const Text("Lanjutkan dengan Google"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: defaultButtonStyle,
                onPressed: () => Get.toNamed('/register'),
                child: Row(
                  children: const [
                    Icon(Icons.email_outlined),
                    SizedBox(width: 10),
                    Text("Lanjutkan dengan akun SnPlay"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Dengan membuat akun atau melanjutkan menggunakan aplikasi SnPlay anda telah bersedia dan setuju dengan Ketentuan Layanan dan Kebijakan kami",
                style: smallText.copyWith(color: Colors.white.withOpacity(0.5)),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
