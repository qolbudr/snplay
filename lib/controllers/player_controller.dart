import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  static PlayerController instance = Get.find();
  final BetterPlayerController controller = Get.arguments;

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.onInit();
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.portraitDown, DeviceOrientation.portraitUp, DeviceOrientation.landscapeRight]);
    super.onClose();
  }
}
