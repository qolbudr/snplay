import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/movie_banner_response_model.dart';
import 'package:snplay/view/entities/movie_banner_entity.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  final Rx<Status> _bannerStatus = Rx<Status>(Status.empty);
  final Rx<List<MovieBanner>> _movieBanner = Rx<List<MovieBanner>>([]);
  final apiService = ApiService();
  final Rx<int> _bannerActiveIndex = Rx<int>(0);

  Status get bannerStatus => _bannerStatus.value;
  List<MovieBanner> get movieBanner => _movieBanner.value;
  int get bannerActiveIndex => _bannerActiveIndex.value;

  set setBannerActiveIndex(index) {
    _bannerActiveIndex.value = index;
  }

  @override
  onInit() {
    super.onInit();
    getMovieBanner();
  }

  getMovieBanner() async {
    try {
      _bannerStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getMovieImageSlider");
      List<MovieBanner> data = response.map((e) => MovieBannerResponseModel.fromJson(e).toEntity()).toList();
      _movieBanner.value = data;
      _bannerStatus.value = Status.success;
    } catch (e) {
      _bannerStatus.value = Status.error;
    }
  }
}
