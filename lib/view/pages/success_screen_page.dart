import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: primaryColor,
            size: 80,
          )
        ],
      ),
    );
  }
}
