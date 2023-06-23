import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/custom_banner_response_model.dart';
import 'package:snplay/models/movie_response_model.dart';
import 'package:snplay/models/series_response_model.dart';
import 'package:snplay/view/entities/custom_banner_entity.dart';
import 'package:snplay/view/entities/movie_entity.dart';
import 'package:snplay/view/entities/series_entity.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  final Rx<Status> _bannerStatus = Rx<Status>(Status.empty);
  final Rx<Status> _recentMovieStatus = Rx<Status>(Status.empty);
  final Rx<Status> _recentSeriesStatus = Rx<Status>(Status.empty);
  final Rx<List<CustomBanner>> _customBanner = Rx<List<CustomBanner>>([]);
  final Rx<List<Movie>> _recentMovie = Rx<List<Movie>>([]);
  final Rx<List<Series>> _recentSeries = Rx<List<Series>>([]);
  final apiService = ApiService();
  final Rx<int> _bannerActiveIndex = Rx<int>(0);

  Status get bannerStatus => _bannerStatus.value;
  List<CustomBanner> get customBanner => _customBanner.value;
  Status get recentMovieStatus => _recentMovieStatus.value;
  Status get recentSeriesStatus => _recentSeriesStatus.value;
  List<Movie> get recentMovie => _recentMovie.value;
  List<Series> get recentSeries => _recentSeries.value;
  int get bannerActiveIndex => _bannerActiveIndex.value;

  set setBannerActiveIndex(index) {
    _bannerActiveIndex.value = index;
  }

  @override
  onInit() {
    super.onInit();
    getCustomBanner();
    getRecentMovie();
    getRecentSeries();
  }

  getCustomBanner() async {
    try {
      _bannerStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getCustomImageSlider");
      List<CustomBanner> data = response.map((e) => CustomBannerResponseModel.fromJson(e).toEntity()).toList();
      _customBanner.value = data;
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

  getRecentSeries() async {
    try {
      _recentSeriesStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getRecentContentList/WebSeries");
      List<Series> data = response.map((e) => SeriesResponseModel.fromJson(e).toEntity()).toList();
      _recentSeries.value = data;
      _recentSeriesStatus.value = Status.success;
    } catch (e) {
      _recentSeriesStatus.value = Status.error;
    }
  }
}
