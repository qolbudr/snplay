import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/movie_banner_response_model.dart';
import 'package:snplay/models/movie_response_model.dart';
import 'package:snplay/view/entities/movie_banner_entity.dart';
import 'package:snplay/view/entities/movie_entity.dart';

class MovieController extends GetxController {
  static MovieController instance = Get.find();
  final Rx<Status> _bannerStatus = Rx<Status>(Status.empty);
  final Rx<Status> _recentMovieStatus = Rx<Status>(Status.empty);
  final Rx<int> _bannerActiveIndex = Rx<int>(0);
  final Rx<List<MovieBanner>> _movieBanner = Rx<List<MovieBanner>>([]);
  final Rx<List<Movie>> _recentMovie = Rx<List<Movie>>([]);
  final apiService = ApiService();

  Status get bannerStatus => _bannerStatus.value;
  int get bannerActiveIndex => _bannerActiveIndex.value;
  List<MovieBanner> get movieBanner => _movieBanner.value;
  Status get recentMovieStatus => _recentMovieStatus.value;
  List<Movie> get recentMovie => _recentMovie.value;

  set setBannerActiveIndex(index) {
    _bannerActiveIndex.value = index;
  }

  @override
  onInit() {
    super.onInit();
    getMovieBanner();
    getRecentMovie();
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
      List<Movie> data = response.map((e) => MovieResponseModel.fromJson(e).toEntity()).toList();
      _recentMovie.value = data;
      _recentMovieStatus.value = Status.success;
    } catch (e) {
      _recentMovieStatus.value = Status.error;
    }
  }
}
