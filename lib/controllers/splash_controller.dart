import 'package:get/get.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/db_service.dart';
import 'package:snplay/view/entities/user_data_entity.dart';

class SplashController extends GetxController {
  static SplashController instance = Get.find();
  final LoginController loginController = Get.put(LoginController());
  final dbService = DBService();

  @override
  onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      await checkUser();
    });
  }

  checkUser() async {
    try {
      UserData user = await dbService.getUser();
      loginController.setUser = user;
      Get.offAllNamed('/home');
    } catch (e) {
      Get.offAllNamed('/welcome');
    }
  }
}
