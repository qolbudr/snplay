import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/movie_banner_response_model.dart';
import 'package:snplay/models/movie_response_model.dart';
import 'package:snplay/view/entities/movie_banner_entity.dart';
import 'package:snplay/view/entities/movie_entity.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  final Rx<Status> _bannerStatus = Rx<Status>(Status.empty);
  final Rx<Status> _recentStatus = Rx<Status>(Status.empty);
  final Rx<Status> _randomStatus = Rx<Status>(Status.empty);
  final Rx<List<MovieBanner>> _movieBanner = Rx<List<MovieBanner>>([]);
  final Rx<List<Movie>> _recentMovie = Rx<List<Movie>>([]);
  final Rx<List<Movie>> _randomMovie = Rx<List<Movie>>([]);
  final apiService = ApiService();
  final Rx<int> _bannerActiveIndex = Rx<int>(0);

  Status get bannerStatus => _bannerStatus.value;
  List<MovieBanner> get movieBanner => _movieBanner.value;
  Status get recentStatus => _recentStatus.value;
  Status get randomStatus => _randomStatus.value;
  List<Movie> get recentMovie => _recentMovie.value;
  List<Movie> get randomMovie => _randomMovie.value;
  int get bannerActiveIndex => _bannerActiveIndex.value;

  set setBannerActiveIndex(index) {
    _bannerActiveIndex.value = index;
  }

  @override
  onInit() {
    super.onInit();
    getMovieBanner();
    getRecentMovie();
    getRandomMovie();
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

  getRecentMovie() async {
    try {
      _recentStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getRecentContentList/Movies");
      List<Movie> data = response.map((e) => MovieResponseModel.fromJson(e).toEntity()).toList();
      _recentMovie.value = data;
      _recentStatus.value = Status.success;
    } catch (e) {
      _recentStatus.value = Status.error;
    }
  }

  getRandomMovie() async {
    try {
      _randomStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getRandMovies");
      List<Movie> data = response.map((e) => MovieResponseModel.fromJson(e).toEntity()).toList();
      _randomMovie.value = data;
      _randomStatus.value = Status.success;
    } catch (e) {
      _randomStatus.value = Status.error;
    }
  }
}
