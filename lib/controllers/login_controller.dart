import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/download_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/controllers/services/db_service.dart';
import 'package:snplay/models/login_response_model.dart';
import 'package:snplay/view/entities/user_data_entity.dart';

class LoginController extends GetxController {
  static LoginController instance = Get.find();
  final DownloadController downloadController = Get.put(DownloadController());
  final Rx<bool> _showPassword = Rx<bool>(false);
  final Rx<bool> _buttonEnabled = Rx<bool>(false);
  final Rx<Map<String, dynamic>> _data = Rx<Map<String, dynamic>>({});
  final Rx<String> _errorMessage = Rx<String>('');
  final Rx<UserData> _user = Rx<UserData>(UserData());
  final apiService = ApiService();
  final dbService = DBService();
  final Rx<Status> _status = Rx<Status>(Status.empty);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool get showPassword => _showPassword.value;
  bool get buttonEnabled => _buttonEnabled.value;
  Map<String, dynamic> get postData => _data.value;
  String get errorMessage => _errorMessage.value;
  UserData get user => _user.value;
  Status get status => _status.value;

  set setUser(UserData user) {
    _user.value = user;
  }

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

  loginWithGoogle() async {
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
          onChange('email', user.email);
          onChange('password', 'googleSignIn');
          await login();
        } catch (e) {
          onChange('email', user.email);
          onChange('password', 'googleSignIn');
          onChange('username', user.displayName);
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
              setUser = data;
              _status.value = Status.success;
              Get.offAllNamed('/root');
            }
          } catch (e) {
            _status.value = Status.error;
            Get.snackbar('Ada Kesalahan', getError(e));
          }
        }
      } else {
        Get.snackbar('Ada Kesalahan', 'User tidak ditemukan');
      }
    } else {
      Get.snackbar('Ada Kesalahan', 'User tidak ditemukan');
    }
  }

  login() async {
    try {
      String payload = "login:${postData['email']}:${md5.convert(utf8.encode(postData['password']))}";
      _status.value = Status.loading;
      Map<String, dynamic> response = await apiService.post(
        '$baseURL/authentication',
        {
          'encoded': base64Encode(utf8.encode(payload)),
        },
      );
      LoginResponseModel model = LoginResponseModel.fromJson(response);
      if (model.status == 'Invalid Credential') {
        throw Exception('Email/Password salah');
      } else {
        dbService.setUser(model);
        UserData data = model.toEntity();
        _user.value = data;
        _status.value = Status.success;
        Get.offAllNamed('/root');
      }
    } catch (e) {
      _status.value = Status.error;
      rethrow;
    }
  }

  logout() async {
    downloadController.stream?.cancel();
    dbService.deleteUser();
    Get.offAllNamed('/welcome');
  }
}
