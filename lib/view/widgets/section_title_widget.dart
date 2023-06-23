import 'package:flutter/material.dart';
import 'package:snplay/constant.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.detail, required this.onTap});
  final String title, detail;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: h4),
                const Icon(Icons.chevron_right_outlined),
              ],
            ),
            Text(detail, style: h5.copyWith(color: Colors.white.withOpacity(0.5))),
          ],
        ),
      ),
    );
  }
}
