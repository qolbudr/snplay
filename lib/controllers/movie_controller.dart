import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/movie_banner_response_model.dart';
import 'package:snplay/models/movie_response_model.dart';
import 'package:snplay/view/entities/movie_banner_entity.dart';
import 'package:snplay/view/entities/item_entity.dart';

class MovieController extends GetxController {
  static MovieController instance = Get.find();
  final Rx<Status> _bannerStatus = Rx<Status>(Status.empty);
  final Rx<Status> _recentMovieStatus = Rx<Status>(Status.empty);
  final Rx<Status> _randomMovieStatus = Rx<Status>(Status.empty);
  final Rx<int> _bannerActiveIndex = Rx<int>(0);
  final Rx<List<MovieBanner>> _movieBanner = Rx<List<MovieBanner>>([]);
  final Rx<List<Item>> _recentMovie = Rx<List<Item>>([]);
  final Rx<List<Item>> _randomMovie = Rx<List<Item>>([]);
  final apiService = ApiService();

  Status get bannerStatus => _bannerStatus.value;
  int get bannerActiveIndex => _bannerActiveIndex.value;
  List<MovieBanner> get movieBanner => _movieBanner.value;
  Status get recentMovieStatus => _recentMovieStatus.value;
  Status get randomMovieStatus => _randomMovieStatus.value;
  List<Item> get recentMovie => _recentMovie.value;
  List<Item> get randomMovie => _randomMovie.value;

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
      _recentMovieStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getRecentContentList/Movies");
      List<Item> data = response.map((e) => MovieResponseModel.fromJson(e).toEntity()).toList();
      _recentMovie.value = data;
      _recentMovieStatus.value = Status.success;
    } catch (e) {
      _recentMovieStatus.value = Status.error;
    }
  }

  getRandomMovie() async {
    try {
      _randomMovieStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getRandMovies");
      List<Item> data = response.map((e) => MovieResponseModel.fromJson(e).toEntity()).toList();
      _randomMovie.value = data;
      _randomMovieStatus.value = Status.success;
    } catch (e) {
      _randomMovieStatus.value = Status.error;
    }
  }
}
