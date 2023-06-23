import 'package:get/get.dart';

class RootController extends GetxController {
  static RootController instance = Get.find();
  final Rx<int> _selectedIndex = Rx<int>(0);

  int get selectedIndex => _selectedIndex.value;

  set setSelectedIndex(int index) {
    _selectedIndex.value = index;
    Get.back();
  }
}
