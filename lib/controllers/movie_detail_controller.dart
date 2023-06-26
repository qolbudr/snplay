import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/movie_detail_response_model.dart';
import 'package:snplay/models/movie_playlink_response_model.dart';
import 'package:snplay/models/movie_response_model.dart';
import 'package:snplay/models/movie_subtitle_response_model.dart';
import 'package:snplay/models/tmdb_movie_detail_response_model.dart';
import 'package:snplay/view/entities/movie_detail_entity.dart';
import 'package:snplay/view/entities/movie_entity.dart';
import 'package:snplay/view/entities/movie_playlink_entity.dart';
import 'package:snplay/view/entities/movie_subtitle_entity.dart';
import 'package:snplay/view/entities/tmdb_movie_detail_entity.dart';
import 'package:snplay/view/widgets/custom_player_control_widget.dart';

class MovieDetailController extends GetxController {
  static MovieDetailController instance = Get.find();
  final LoginController loginController = Get.put(LoginController());
  final apiService = ApiService();
  final Rx<Status> _detailStatus = Rx<Status>(Status.empty);
  final Rx<MovieDetail> _movieDetail = Rx<MovieDetail>(MovieDetail());
  final Rx<TmdbMovieDetail> _tmdbMovieDetail = Rx<TmdbMovieDetail>(TmdbMovieDetail());
  final Rx<List<Movie>> _similarMovie = Rx<List<Movie>>([]);
  final Rx<bool> _isFavourite = Rx<bool>(false);
  final Rx<List<MoviePlaylink>> _moviePlaylink = Rx<List<MoviePlaylink>>([]);
  final List<List<MovieSubtitle>> _subs = [];
  final Map<String, String> _resolution = {};

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

  initFunction() {
    Future.wait([getTmdbMovieDetail(), getMovieDetail(), getSimilarMovie(), checkFavourite(), getMoviePlayLink()]).then((value) {
      _detailStatus.value = Status.success;
    }).catchError((e) {
      _detailStatus.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    });
  }

  Future<void> getMoviePlayLink() async {
    try {
      List<dynamic> response = await apiService.get('$baseURL/getMoviePlayLinks/${arguments.id}');
      List<MoviePlaylink> playLink = response.map((e) => MoviePlaylinkResponseModel.fromJson(e).toEntity()).toList();
      _moviePlaylink.value = playLink;
      getMovieSubtitle();
    } catch (e) {
      return;
    }
  }

  Future<void> getMovieSubtitle() async {
    try {
      for (MoviePlaylink item in _moviePlaylink.value) {
        try {
          List<dynamic> response = await apiService.post('$baseURL/getsubtitle/${item.id}/1', {});
          List<MovieSubtitle> subtitle = response.map((e) => MovieSubtitleResponseModel.fromJson(e).toEntity()).toList();
          _resolution[item.quality ?? 'Auto'] = item.url ?? '-';
          _subs.add(subtitle);
        } catch (e) {
          continue;
        }
      }
    } catch (e) {
      return;
    }
  }

  getPlayerSource() async {
    try {
      final BetterPlayerController controller = BetterPlayerController(
        BetterPlayerConfiguration(
          fit: BoxFit.contain,
          autoPlay: true,
          showPlaceholderUntilPlay: true,
          subtitlesConfiguration: const BetterPlayerSubtitlesConfiguration(
            fontSize: 18,
            backgroundColor: Colors.black,
          ),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            playerTheme: BetterPlayerTheme.custom,
            showControlsOnInitialize: false,
            overflowModalColor: secondaryColor,
            overflowModalTextColor: Colors.white,
            overflowMenuIconsColor: Colors.white,
            customControlsBuilder: (controller, onPlayerVisibilityChanged) => CustomControl(
              controller: controller,
              onControlsVisibilityChanged: onPlayerVisibilityChanged,
            ),
          ),
        ),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          _moviePlaylink.value.first.url ?? 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          placeholder: CachedNetworkImage(imageUrl: arguments.poster ?? '-'),
          cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
          resolutions: _resolution,
          subtitles: _subs
              .map(
                (item) => BetterPlayerSubtitlesSource(
                  type: BetterPlayerSubtitlesSourceType.network,
                  name: item.isNotEmpty ? item.first.language : 'Auto',
                  selectedByDefault: true,
                  urls: item.map((e) => e.subtitleUrl).toList(),
                ),
              )
              .toList(),
        ),
      );
      Get.toNamed('/player', arguments: controller);
    } catch (e) {
      Get.snackbar('Ada Kesalahan', 'Gagal mendapatkan informasi player');
    }
  }

  Future<void> checkFavourite() async {
    try {
      String response = await apiService.get('$baseURL/favourite/SEARCH/${loginController.user.id}/${arguments.id}/1');
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
    await apiService.get('$baseURL/favourite/SET/${loginController.user.id}/${arguments.id}/1');
    _isFavourite.value = true;
    Get.snackbar('Berhasil', 'Film telah ditambahkan ke favorit');
  }

  removeFavourite() async {
    await apiService.get('$baseURL/favourite/REMOVE/${loginController.user.id}/${arguments.id}/1');
    _isFavourite.value = false;
    Get.snackbar('Berhasil', 'Film telah dihapus dari favorit');
  }

  Future<void> getMovieDetail() async {
    try {
      Map<String, dynamic> response = await apiService.get('$baseURL/getMovieDetails/${arguments.id}');
      MovieDetailResponseModel model = MovieDetailResponseModel.fromJson(response);
      MovieDetail data = model.toEntity();
      _movieDetail.value = data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getTmdbMovieDetail() async {
    try {
      Map<String, dynamic> response = await apiService.get('$tmdbBaseURL/movie/${arguments.tmdbId}?api_key=$tmdbApiKey');
      TmdbMovieDetailResponseModel model = TmdbMovieDetailResponseModel.fromJson(response);
      TmdbMovieDetail data = model.toEntity();
      _tmdbMovieDetail.value = data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getSimilarMovie() async {
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
      return;
    }
  }
}
