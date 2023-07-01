import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/register_controller.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final RegisterController registerController = Get.put(RegisterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register dengan Email"),
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
                        onChanged: (value) => registerController.onChange('username', value),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
                          label: Text("Username"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) => registerController.onChange('email', value),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
                          label: Text("Email"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => TextFormField(
                          onChanged: (value) => registerController.onChange('password', value),
                          obscureText: !registerController.showPassword,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
                            label: const Text("Kata Sandi"),
                            suffixIcon: IconButton(
                              onPressed: () => registerController.tooglePassword(),
                              icon: Icon(
                                registerController.showPassword ? Icons.visibility_off : Icons.visibility,
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
                            onPressed: registerController.status == Status.loading
                                ? null
                                : registerController.buttonEnabled
                                    ? () async {
                                        try {
                                          await registerController.register();
                                        } catch (e) {
                                          Get.snackbar('Ada Kesalahan', getError(e));
                                        }
                                      }
                                    : null,
                            child: registerController.status == Status.loading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Text("Tunggu Sebentar"),
                                    ],
                                  )
                                : const Text("Daftar"),
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
