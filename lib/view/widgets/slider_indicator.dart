import 'package:flutter/material.dart';
import 'package:snplay/constant.dart';

class SliderIndicator extends StatelessWidget {
  const SliderIndicator({super.key, required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      width: isActive ? 20 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : secondaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
