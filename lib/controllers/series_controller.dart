import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/models/series_banner_response_model.dart';
import 'package:snplay/models/series_response_model.dart';
import 'package:snplay/view/entities/item_entity.dart';
import 'package:snplay/view/entities/series_banner_entity.dart';
import 'services/api_service.dart';

class SeriesCotroller extends GetxController {
  static SeriesCotroller instance = Get.find();

  final Rx<Status> _bannerStatus = Rx<Status>(Status.empty);
  final Rx<Status> _recentSeriesStatus = Rx<Status>(Status.empty);
  final Rx<Status> _randomSeriesStatus = Rx<Status>(Status.empty);
  final Rx<int> _bannerActiveIndex = Rx<int>(0);
  final Rx<List<SeriesBanner>> _seriesBanner = Rx<List<SeriesBanner>>([]);
  final Rx<List<Item>> _recentSeries = Rx<List<Item>>([]);
  final Rx<List<Item>> _randomSeries = Rx<List<Item>>([]);
  final apiService = ApiService();

  Status get bannerStatus => _bannerStatus.value;
  int get bannerActiveIndex => _bannerActiveIndex.value;
  List<SeriesBanner> get seriesBanner => _seriesBanner.value;
  Status get recentSeriesStatus => _recentSeriesStatus.value;
  Status get randomSeriesStatus => _randomSeriesStatus.value;
  List<Item> get recentSeries => _recentSeries.value;
  List<Item> get randomSeries => _randomSeries.value;

  set setBannerActiveIndex(index) {
    _bannerActiveIndex.value = index;
  }

  @override
  onInit() {
    super.onInit();
    getSeriesBanner();
    getRecentSeries();
    getRandomSeries();
  }

  getSeriesBanner() async {
    try {
      _bannerStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getWebSeriesImageSlider");
      List<SeriesBanner> data = response.map((e) => SeriesBannerResponseModel.fromJson(e).toEntity()).toList();
      _seriesBanner.value = data;
      _bannerStatus.value = Status.success;
    } catch (e) {
      _bannerStatus.value = Status.error;
    }
  }

  getRecentSeries() async {
    try {
      _recentSeriesStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getRecentContentList/WebSeries");
      List<Item> data = response.map((e) => SeriesResponseModel.fromJson(e).toEntity()).toList();
      _recentSeries.value = data;
      _recentSeriesStatus.value = Status.success;
    } catch (e) {
      _recentSeriesStatus.value = Status.error;
    }
  }

  getRandomSeries() async {
    try {
      _randomSeriesStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getRandWebSeries");
      List<Item> data = response.map((e) => SeriesResponseModel.fromJson(e).toEntity()).toList();
      _randomSeries.value = data;
      _randomSeriesStatus.value = Status.success;
    } catch (e) {
      _randomSeriesStatus.value = Status.error;
    }
  }
}
