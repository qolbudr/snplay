import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';

class Success extends StatelessWidget {
  Success({super.key});
  final message = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: primaryColor,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              "Berhasil",
              style: h2,
            ),
            const SizedBox(height: 5),
            Text(
              message,
              style: h3,
            )
          ],
        ),
      ),
    );
  }
}
