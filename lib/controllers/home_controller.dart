import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/custom_banner_response_model.dart';
import 'package:snplay/models/item_response_model.dart';
import 'package:snplay/view/entities/custom_banner_entity.dart';
import 'package:snplay/view/entities/item_entity.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  final Rx<Status> _bannerStatus = Rx<Status>(Status.empty);
  final Rx<Status> _recentMovieStatus = Rx<Status>(Status.empty);
  final Rx<Status> _recentSeriesStatus = Rx<Status>(Status.empty);
  final Rx<List<CustomBanner>> _customBanner = Rx<List<CustomBanner>>([]);
  final Rx<List<Item>> _recentMovie = Rx<List<Item>>([]);
  final Rx<List<Item>> _recentSeries = Rx<List<Item>>([]);
  final apiService = ApiService();
  final Rx<int> _bannerActiveIndex = Rx<int>(0);
  final LoginController loginController = Get.put(LoginController());

  Status get bannerStatus => _bannerStatus.value;
  List<CustomBanner> get customBanner => _customBanner.value;
  Status get recentMovieStatus => _recentMovieStatus.value;
  Status get recentSeriesStatus => _recentSeriesStatus.value;
  List<Item> get recentMovie => _recentMovie.value;
  List<Item> get recentSeries => _recentSeries.value;
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
      List<Item> data;

      if (loginController.user.subscriptionType!.contains('2')) {
        data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0' || item.type == '1').toList();
      } else {
        data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0').toList();
      }

      _recentMovie.value = data.where((item) => item.status == '1').toList();
      _recentMovie.value = recentMovie.sublist(0, recentMovie.length >= 5 ? 5 : recentMovie.length);
      _recentMovieStatus.value = Status.success;
    } catch (e) {
      _recentMovieStatus.value = Status.error;
    }
  }

  getRecentSeries() async {
    try {
      _recentSeriesStatus.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getRecentContentList/WebSeries");
      List<Item> data;

      if (loginController.user.subscriptionType!.contains('2')) {
        data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0' || item.type == '1').toList();
      } else {
        data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0').toList();
      }

      _recentSeries.value = data.where((item) => item.status == '1').toList();
      _recentSeries.value = recentSeries.sublist(0, recentSeries.length >= 5 ? 5 : recentSeries.length);
      _recentSeriesStatus.value = Status.success;
    } catch (e) {
      _recentSeriesStatus.value = Status.error;
    }
  }
}
