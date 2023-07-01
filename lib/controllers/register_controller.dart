import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/controllers/services/db_service.dart';
import 'package:snplay/models/login_response_model.dart';
import 'package:snplay/view/entities/user_data_entity.dart';

class RegisterController extends GetxController {
  static RegisterController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LoginController loginController = Get.put(LoginController());
  final Rx<Map<String, dynamic>> _data = Rx<Map<String, dynamic>>({});
  final Rx<bool> _showPassword = Rx<bool>(false);
  final Rx<bool> _buttonEnabled = Rx<bool>(false);
  final apiService = ApiService();
  final dbService = DBService();
  final Rx<Status> _status = Rx<Status>(Status.empty);

  bool get showPassword => _showPassword.value;
  bool get buttonEnabled => _buttonEnabled.value;
  Map<String, dynamic> get postData => _data.value;
  Status get status => _status.value;

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

  register() async {
    try {
      String payload = "signup:${postData['username']}:${postData['email']}:${md5.convert(utf8.encode(postData['password']))}";
      _status.value = Status.loading;
      Map<String, dynamic> response = await apiService.post(
        '$baseURL/authentication',
        {
          'encoded': base64Encode(utf8.encode(payload)),
        },
      );
      LoginResponseModel model = LoginResponseModel.fromJson(response);
      if (model.status == 'Email Already Regestered') {
        throw Exception('Email Already Regestered');
      } else {
        dbService.setUser(model);
        UserData data = model.toEntity();
        loginController.setUser = data;
        _status.value = Status.success;
        Get.offAllNamed('/root');
      }
    } catch (e) {
      _status.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    }
  }

  registerWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);
      User? user = authResult.user;

      if (user != null) {
        try {
          loginController.onChange('email', user.email);
          loginController.onChange('password', 'googleSignIn');
          await loginController.login();
        } catch (e) {
          onChange('email', user.email);
          onChange('password', 'googleSignIn');
          onChange('username', user.displayName);
          await register();
        }
      } else {
        Get.snackbar('Ada Kesalahan', 'User tidak ditemukan');
      }
    } else {
      Get.snackbar('Ada Kesalahan', 'User tidak ditemukan');
    }
  }
}
