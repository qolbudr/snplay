import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  static PlayerController instance = Get.find();
  Rx<bool> showControlInit = Rx<bool>(false);

  @override
  void onInit() {
    Future.wait([
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []),
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]),
    ]).then((value) {
      showControlInit.value = true;
    });
    super.onInit();
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp, DeviceOrientation.landscapeRight]);
    super.onClose();
  }
}
