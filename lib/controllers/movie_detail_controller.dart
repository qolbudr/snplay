import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/movie_detail_response_model.dart';
import 'package:snplay/models/movie_response_model.dart';
import 'package:snplay/models/tmdb_movie_detail_response_model.dart';
import 'package:snplay/view/entities/movie_detail_entity.dart';
import 'package:snplay/view/entities/movie_entity.dart';
import 'package:snplay/view/entities/tmdb_movie_detail_entity.dart';

class MovieDetailController extends GetxController {
  static MovieDetailController instance = Get.find();
  final LoginController loginController = Get.put(LoginController());
  final apiService = ApiService();
  final Rx<Status> _detailStatus = Rx<Status>(Status.empty);
  final Rx<MovieDetail> _movieDetail = Rx<MovieDetail>(MovieDetail());
  final Rx<TmdbMovieDetail> _tmdbMovieDetail = Rx<TmdbMovieDetail>(TmdbMovieDetail());
  final Rx<List<Movie>> _similarMovie = Rx<List<Movie>>([]);
  final Rx<bool> _isFavourite = Rx<bool>(false);

  Status get detailStatus => _detailStatus.value;
  MovieDetail get movieDetail => _movieDetail.value;
  List<Movie> get similarMovie => _similarMovie.value;
  TmdbMovieDetail get tmdbMovieDetail => _tmdbMovieDetail.value;
  final Movie arguments = Get.arguments;
  bool get isFavourite => _isFavourite.value;

  @override
  void onInit() {
    super.onInit();
    initFunction();
  }

  initFunction() async {
    try {
      await getMovieDetail();
      await getTmdbMovieDetail();
      await getSimilarMovie();
      await checkFavourite();
      _detailStatus.value = Status.success;
    } catch (e) {
      _detailStatus.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    }
  }

  checkFavourite() async {
    try {
      String response = await apiService.get('$baseURL/favourite/SEARCH/${loginController.user.id}/${arguments.id}/0');
      if (response != '') {
        _isFavourite.value = true;
      } else {
        _isFavourite.value = false;
      }
    } catch (e) {
      rethrow;
    }
  }

  addFavourite() async {
    await apiService.get('$baseURL/favourite/SET/${loginController.user.id}/${arguments.id}/0');
    _isFavourite.value = true;
    Get.snackbar('Berhasil', 'Film telah ditambahkan ke favorit');
  }

  removeFavourite() async {
    await apiService.get('$baseURL/favourite/REMOVE/${loginController.user.id}/${arguments.id}/0');
    _isFavourite.value = false;
    Get.snackbar('Berhasil', 'Film telah dihapus dari favorit');
  }

  getMovieDetail() async {
    try {
      Map<String, dynamic> response = await apiService.get('$baseURL/getMovieDetails/${arguments.id}');
      MovieDetailResponseModel model = MovieDetailResponseModel.fromJson(response);
      MovieDetail data = model.toEntity();
      _movieDetail.value = data;
    } catch (e) {
      rethrow;
    }
  }

  getTmdbMovieDetail() async {
    try {
      Map<String, dynamic> response = await apiService.get('$tmdbBaseURL/movie/${arguments.tmdbId}?api_key=$tmdbApiKey');
      TmdbMovieDetailResponseModel model = TmdbMovieDetailResponseModel.fromJson(response);
      TmdbMovieDetail data = model.toEntity();
      _tmdbMovieDetail.value = data;
    } catch (e) {
      rethrow;
    }
  }

  getSimilarMovie() async {
    List<dynamic> response = await apiService.post(
      '$baseURL/getRelatedMovies/${arguments.id}/5',
      {
        'genres': arguments.genres,
      },
    );
    List<Movie> data = response.map((e) => MovieResponseModel.fromJson(e).toEntity()).toList();
    _similarMovie.value = data;
  }
}
