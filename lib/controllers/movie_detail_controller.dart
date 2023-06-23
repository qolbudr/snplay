import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/movie_detail_response_model.dart';
import 'package:snplay/models/movie_response_model.dart';
import 'package:snplay/models/tmdb_movie_detail_response_model.dart';
import 'package:snplay/view/entities/movie_detail_entity.dart';
import 'package:snplay/view/entities/movie_entity.dart';
import 'package:snplay/view/entities/tmdb_movie_detail_entity.dart';

class MovieDetailController extends GetxController {
  static MovieDetailController instance = Get.find();
  final apiService = ApiService();
  final Rx<Status> _detailStatus = Rx<Status>(Status.empty);
  final Rx<MovieDetail> _movieDetail = Rx<MovieDetail>(MovieDetail());
  final Rx<TmdbMovieDetail> _tmdbMovieDetail = Rx<TmdbMovieDetail>(TmdbMovieDetail());
  final Rx<List<Movie>> _similarMovie = Rx<List<Movie>>([]);

  Status get detailStatus => _detailStatus.value;
  MovieDetail get movieDetail => _movieDetail.value;
  List<Movie> get similarMovie => _similarMovie.value;
  TmdbMovieDetail get tmdbMovieDetail => _tmdbMovieDetail.value;
  final Movie arguments = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() async {
      await getMovieDetail();
      await getTmdbMovieDetail();
      await getSimilarMovie();
    }).then((value) {
      _detailStatus.value = Status.success;
    }).catchError((e) {
      _detailStatus.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    });
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
    try {
      List<dynamic> response = await apiService.post(
        '$baseURL/getRelatedMovies/${arguments.id}/5',
        {
          'genres': arguments.genres,
        },
      );
      List<Movie> data = response.map((e) => MovieResponseModel.fromJson(e).toEntity()).toList();
      _similarMovie.value = data;
    } catch (e) {
      rethrow;
    }
  }
}
