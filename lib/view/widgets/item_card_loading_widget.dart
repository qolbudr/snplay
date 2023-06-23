import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemCardLoading extends StatelessWidget {
  const ItemCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 7,
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.2),
        child: Container(color: Colors.white),
      ),
    );
  }
}
