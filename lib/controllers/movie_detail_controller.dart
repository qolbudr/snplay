import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/download_controller.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/saved_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/download_link_response_model.dart';
import 'package:snplay/models/movie_detail_response_model.dart';
import 'package:snplay/models/movie_playlink_response_model.dart';
import 'package:snplay/models/item_response_model.dart';
import 'package:snplay/models/movie_subtitle_response_model.dart';
import 'package:snplay/models/tmdb_movie_detail_response_model.dart';
import 'package:snplay/view/entities/download_link_entity.dart';
import 'package:snplay/view/entities/item_detail_entity.dart';
import 'package:snplay/view/entities/item_entity.dart';
import 'package:snplay/view/entities/movie_playlink_entity.dart';
import 'package:snplay/view/entities/movie_subtitle_entity.dart';
import 'package:snplay/view/entities/tmdb_movie_detail_entity.dart';
import 'package:snplay/view/widgets/custom_player_control_widget.dart';

class MovieDetailController extends GetxController {
  static MovieDetailController instance = Get.find();
  final LoginController loginController = Get.put(LoginController());
  final SavedController savedController = Get.put(SavedController());
  final DownloadController downloadController = Get.put(DownloadController());
  final apiService = ApiService();
  final Rx<Status> _detailStatus = Rx<Status>(Status.empty);
  final Rx<ItemDetail> _movieDetail = Rx<ItemDetail>(ItemDetail());
  final Rx<TmdbMovieDetail> _tmdbMovieDetail = Rx<TmdbMovieDetail>(TmdbMovieDetail());
  final Rx<List<Item>> _similarMovie = Rx<List<Item>>([]);
  final Rx<bool> _isFavourite = Rx<bool>(false);
  final Rx<List<MoviePlaylink>> _moviePlaylink = Rx<List<MoviePlaylink>>([]);
  final Rx<List<DownloadLink>> _downloadLink = Rx<List<DownloadLink>>([]);
  final List<List<MovieSubtitle>> _subs = [];
  final Map<String, String> _resolution = {};
  final Rx<bool> _isDownloaded = Rx<bool>(false);
  final Rx<String?> _localPath = Rx<String?>(null);

  Status get detailStatus => _detailStatus.value;
  ItemDetail get movieDetail => _movieDetail.value;
  List<Item> get similarMovie => _similarMovie.value;
  TmdbMovieDetail get tmdbMovieDetail => _tmdbMovieDetail.value;
  final Item arguments = Get.arguments;
  bool get isFavourite => _isFavourite.value;
  List<DownloadLink> get downloadLink => _downloadLink.value;
  bool get isDownloaded => _isDownloaded.value;

  @override
  void onInit() {
    super.onInit();
    initFunction();
  }

  initFunction() {
    Future.wait([getTmdbMovieDetail(), getMovieDetail(), getSimilarMovie(), checkFavourite(), getMoviePlayLink(), getDownloadLink(), checkDownload()]).then((value) {
      _detailStatus.value = Status.success;
    }).catchError((e) {
      _detailStatus.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    });
    addViewLog();
  }

  Future<void> checkDownload() async {
    int index = downloadController.task.indexWhere((element) => element.item.id == arguments.id && element.item.type == arguments.type);
    if (index != -1) {
      _isDownloaded.value = true;
      _localPath.value = downloadController.task[index].path;
    }
  }

  void download(DownloadLink item) {
    downloadController.addDownloadTask(arguments, item);
  }

  Future<void> addViewLog() async {
    try {
      await apiService.post('$baseURL/addviewlog', {
        'user_id': loginController.user.id,
        'content_id': arguments.id,
        'content_type': '1',
      });
    } catch (e) {
      return;
    }
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
          _localPath.value == null ? BetterPlayerDataSourceType.network : BetterPlayerDataSourceType.file,
          _localPath.value == null ? _moviePlaylink.value.first.url ?? 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4' : _localPath.value!,
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

  Future<void> getDownloadLink() async {
    try {
      List<dynamic> response = await apiService.get('$baseURL/getMovieDownloadLinks/${arguments.id}');
      List<DownloadLink> data = response.map((e) => DownloadLinkResponseModel.fromJson(e).toEntity()).toList();
      _downloadLink.value = data;
    } catch (e) {
      return;
    }
  }

  Future<void> checkFavourite() async {
    try {
      final str = jsonEncode(arguments.toJson());
      final bytes = utf8.encode(str);
      final submit = base64.encode(bytes).replaceAll('=', '');
      String response = await apiService.get('$baseURL/favourite/SEARCH/${loginController.user.id}/$submit/1');
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
    final str = jsonEncode(arguments.toJson());
    final bytes = utf8.encode(str);
    final submit = base64.encode(bytes).replaceAll('=', '');
    await apiService.get('$baseURL/favourite/SET/${loginController.user.id}/$submit/1');
    _isFavourite.value = true;
    Get.snackbar('Berhasil', 'Film telah ditambahkan ke favorit');
    savedController.getSaved();
  }

  removeFavourite() async {
    final str = jsonEncode(arguments.toJson());
    final bytes = utf8.encode(str);
    final submit = base64.encode(bytes).replaceAll('=', '');
    await apiService.get('$baseURL/favourite/REMOVE/${loginController.user.id}/$submit/1');
    _isFavourite.value = false;
    Get.snackbar('Berhasil', 'Film telah dihapus dari favorit');
    savedController.getSaved();
  }

  Future<void> getMovieDetail() async {
    try {
      Map<String, dynamic> response = await apiService.get('$baseURL/getMovieDetails/${arguments.id}');
      MovieDetailResponseModel model = MovieDetailResponseModel.fromJson(response);
      ItemDetail data = model.toEntity();
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
      List<Item> data;

      if (loginController.user.subscriptionType!.contains('2')) {
        data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0' || item.type == '1').toList();
      } else {
        data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).where((item) => item.type == '0').toList();
      }

      _similarMovie.value = data;
    } catch (e) {
      return;
    }
  }
}
