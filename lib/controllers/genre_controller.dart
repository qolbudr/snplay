import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/item_response_model.dart';
import 'package:snplay/view/entities/item_entity.dart';

class GenreController extends GetxController {
  final String arguments = Get.arguments;
  static GenreController instance = Get.find();
  final apiService = ApiService();
  final Rx<List<Item>> _result = Rx<List<Item>>([]);
  final Rx<Status> _status = Rx<Status>(Status.empty);
  final LoginController loginController = Get.put(LoginController());

  Status get status => _status.value;
  List<Item> get result => _result.value;

  @override
  void onInit() {
    getGenre();
    super.onInit();
  }

  getGenre() async {
    try {
      _status.value = Status.loading;
      List<dynamic> response = await apiService.get('$baseURL/getContentsReletedToGenre/${Uri.encodeFull(arguments)}');
      List<Item> data;

      if (loginController.user.subscriptionType!.contains('2')) {
        data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0' || item.type == '1').toList();
      } else {
        data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0').toList();
      }

      _result.value = data.where((item) => item.status == '1').toList();
      _status.value = Status.success;
    } catch (e) {
      _status.value = Status.error;
      Get.snackbar('Ada Kesalahan', 'Data tidak ditemukan');
    }
  }
}
