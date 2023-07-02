import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snplay/view/entities/download_task_entity.dart';
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

  Future<void> setUser(UserData model) async {
    final db = await database;
    await db.setString('user', jsonEncode(model.toJson()));
  }

  Future<UserData> getUser() async {
    final db = await database;
    String? user = db.getString('user');
    if (user != null) {
      UserData model = UserData.fromJson(jsonDecode(user));
      return model;
    } else {
      throw Exception('Data user tidak ada');
    }
  }

  Future<void> deleteUser() async {
    final db = await database;
    db.remove('user');
  }

  Future<void> updateDownloadList(List<DownloadTaskEntity> task) async {
    final db = await database;
    String? check = db.getString('download');
    if (check != null) {
      db.remove('download');
    }

    final List<Map<String, dynamic>> storeTask = task.map((e) => e.toJson()).toList();
    await db.setString('download', jsonEncode(storeTask));
  }

  Future<List<DownloadTaskEntity>> getDownload() async {
    final db = await database;
    String? download = db.getString('download');
    if (download != null) {
      List<dynamic> json = jsonDecode(download);
      List<DownloadTaskEntity> task = json.map((e) => DownloadTaskEntity.fromJson(e)).toList();
      return task;
    } else {
      return [];
    }
  }
}
