import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snplay/models/login_response_model.dart';
import 'package:snplay/view/entities/user_data_entity.dart';

class DBService {
  static DBService? _dBService;
  DBService._instance() {
    _dBService = this;
  }
  factory DBService() => _dBService ?? DBService._instance();
  static SharedPreferences? _database;

  Future<SharedPreferences> get database async {
    return _database ?? await _init();
  }

  Future<SharedPreferences> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<void> setUser(LoginResponseModel model) async {
    final db = await database;
    await db.setString('user', jsonEncode(model.toJson()));
  }

  Future<UserData> getUser() async {
    final db = await database;
    String? user = db.getString('user');
    if (user != null) {
      LoginResponseModel model = LoginResponseModel.fromJson(jsonDecode(user));
      return model.toEntity();
    } else {
      throw Exception('Data user tidak ada');
    }
  }
}
