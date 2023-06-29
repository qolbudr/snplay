import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/view/entities/item_entity.dart';

class SavedController extends GetxController {
  static SavedController instance = Get.find();
  final apiService = ApiService();
  final LoginController loginController = Get.put(LoginController());
  final Rx<List<Item>> _result = Rx<List<Item>>([]);
  final Rx<Status> _status = Rx<Status>(Status.empty);

  Status get status => _status.value;
  List<Item> get result => _result.value;

  @override
  void onInit() {
    getSaved();
    super.onInit();
  }

  getSaved() async {
    try {
      _status.value = Status.loading;
      String? userId = loginController.user.id;
      List<dynamic> response;
      try {
        response = await apiService.get('$baseURL/getFavouriteList/$userId');
      } catch (e) {
        response = [];
      }
      List<Item> data = [];
      for (Map<String, dynamic> item in response) {
        int length = item['content_type'].length % 4;
        String additional;

        if (length == 1) {
          additional = "===";
        } else if (length == 2) {
          additional = "==";
        } else if (length == 3) {
          additional = "=";
        } else {
          additional = "";
        }

        Uint8List submit = base64.decode(item['content_type'] + additional);
        String str = utf8.decode(submit);
        Item add = Item.fromJson(jsonDecode(str));
        data.add(add);
      }
      _result.value = data;
      _status.value = Status.success;
    } catch (e) {
      _status.value = Status.success;
    }
  }
}
