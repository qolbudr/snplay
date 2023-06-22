import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController instance = Get.find();
  final Rx<bool> _showPassword = Rx<bool>(false);
  final Rx<bool> _buttonEnabled = Rx<bool>(false);
  final Rx<Map<String, dynamic>> _data = Rx<Map<String, dynamic>>({});

  bool get showPassword => _showPassword.value;
  bool get buttonEnabled => _buttonEnabled.value;
  Map<String, dynamic> get postData => _data.value;

  tooglePassword() {
    _showPassword.value = !_showPassword.value;
  }

  onChange(key, value) {
    _data.value[key] = value;
    if (value == '') {
      _data.value.remove(key);
    }
    getButtonState();
  }

  getButtonState() {
    if (_data.value.containsKey('email') && _data.value.containsKey('password')) {
      _buttonEnabled.value = true;
    } else {
      _buttonEnabled.value = false;
    }
  }
}
