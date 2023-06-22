import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login dengan Email"),
      ),
      body: SafeArea(
        child: Container(
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
              const Expanded(child: SizedBox()),
              Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) => loginController.onChange('email', value),
                        decoration: const InputDecoration(
                          label: Text("Email"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => TextFormField(
                          onChanged: (value) => loginController.onChange('password', value),
                          obscureText: !loginController.showPassword,
                          decoration: InputDecoration(
                            label: const Text("Kata Sandi"),
                            suffixIcon: IconButton(
                              onPressed: () => loginController.tooglePassword(),
                              icon: Icon(
                                loginController.showPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: defaultButtonStyle,
                            onPressed: loginController.buttonEnabled ? () {} : null,
                            child: const Text("Masuk"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
