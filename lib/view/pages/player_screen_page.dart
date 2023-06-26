import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/controllers/player_controller.dart';

class Player extends StatelessWidget {
  Player({super.key});
  final playerController = Get.put(PlayerController());
  final BetterPlayerController arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BetterPlayer(
        controller: arguments,
      ),
    );
  }
}
