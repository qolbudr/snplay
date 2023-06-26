import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/controllers/player_controller.dart';

class PlayerSeries extends StatefulWidget {
  const PlayerSeries({super.key});

  @override
  State<PlayerSeries> createState() => _PlayerSeriesState();
}

class _PlayerSeriesState extends State<PlayerSeries> {
  final playerController = Get.put(PlayerController());
  final Widget arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: arguments,
    );
  }
}
