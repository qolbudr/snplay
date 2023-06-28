import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/genre_response_model.dart';
import 'package:snplay/view/entities/genre_entity.dart';

class SearchController extends GetxController {
  static SearchController instance = Get.find();
  final apiService = ApiService();
  final Rx<List<Genre>> _genre = Rx<List<Genre>>([]);
  final Rx<Status> _status = Rx<Status>(Status.empty);

  Status get status => _status.value;
  List<Genre> get genre => _genre.value;

  @override
  void onInit() {
    getGenre();
    super.onInit();
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

  Future<void> search(String keyword) async {}
}
