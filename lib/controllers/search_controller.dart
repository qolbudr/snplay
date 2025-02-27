import 'dart:async';

import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/genre_response_model.dart';
import 'package:snplay/models/item_response_model.dart';
import 'package:snplay/view/entities/genre_entity.dart';
import 'package:snplay/view/entities/item_entity.dart';

class SearchController extends GetxController {
  static SearchController instance = Get.find();
  final apiService = ApiService();
  final Rx<List<Genre>> _genre = Rx<List<Genre>>([]);
  final Rx<Status> _status = Rx<Status>(Status.empty);
  final Rx<Status> _searchStatus = Rx<Status>(Status.empty);
  final Rx<List<Item>> _result = Rx<List<Item>>([]);
  final Rx<bool> _isSearch = Rx<bool>(false);
  Timer? _debounce;
  final LoginController loginController = Get.put(LoginController());

  Status get status => _status.value;
  List<Genre> get genre => _genre.value;
  Status get searchStatus => _searchStatus.value;
  bool get isSearch => _isSearch.value;
  List<Item> get result => _result.value;

  @override
  void onInit() {
    getGenre();
    super.onInit();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onDelete();
  }

  Future<void> getGenre() async {
    try {
      _status.value = Status.loading;
      List<dynamic> response = await apiService.get('$baseURL/getGenreList');
      List<Genre> data = response.map((e) => GenreResponseModel.fromJson(e).toEntity()).toList();
      _genre.value = data;
      _status.value = Status.success;
    } catch (e) {
      _status.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    }
  }

  void search(String keyword) {
    try {
      if (keyword != '') {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _isSearch.value = true;
        _debounce = Timer(const Duration(milliseconds: 1000), () async {
          _searchStatus.value = Status.loading;
          List<dynamic> response;
          if (loginController.user.subscriptionType!.contains('2')) {
            try {
              response = await apiService.get('$baseURL/searchContent/$keyword/1');
            } catch (e) {
              response = [];
            }
          } else {
            try {
              response = await apiService.get('$baseURL/searchContent/$keyword/0');
            } catch (e) {
              response = [];
            }
          }

          List<Item> data;

          if (loginController.user.subscriptionType!.contains('2')) {
            data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0' || item.type == '1').toList();
          } else {
            data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0').toList();
          }

          _result.value = data.where((item) => item.status == '1').toList();
          _searchStatus.value = Status.success;
        });
      } else {
        _isSearch.value = false;
      }
    } catch (e) {
      _searchStatus.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    }
  }
}
