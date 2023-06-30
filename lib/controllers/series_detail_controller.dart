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
import 'package:snplay/models/episode_response_model.dart';
import 'package:snplay/models/item_response_model.dart';
import 'package:snplay/models/movie_subtitle_response_model.dart';
import 'package:snplay/models/season_response_model.dart';
import 'package:snplay/models/series_detail_response_model.dart';
import 'package:snplay/models/tmdb_series_detail_response.dart';
import 'package:snplay/view/entities/download_link_entity.dart';
import 'package:snplay/view/entities/episode_entity.dart';
import 'package:snplay/view/entities/item_detail_entity.dart';
import 'package:snplay/view/entities/item_entity.dart';
import 'package:snplay/view/entities/movie_subtitle_entity.dart';
import 'package:snplay/view/entities/season_entity.dart';
import 'package:snplay/view/entities/tmdb_series_detail_entity.dart';
import 'package:snplay/view/widgets/custom_player_series_control_widget.dart';

class SeriesDetailController extends GetxController {
  static SeriesDetailController instance = Get.find();
  final LoginController loginController = Get.put(LoginController());
  final SavedController savedController = Get.put(SavedController());
  final DownloadController downloadController = Get.put(DownloadController());
  final apiService = ApiService();
  final Rx<Status> _detailStatus = Rx<Status>(Status.empty);
  final Rx<Status> _episodeStatus = Rx<Status>(Status.empty);
  final Rx<ItemDetail> _seriesDetail = Rx<ItemDetail>(ItemDetail());
  final Rx<TmdbSeriesDetail> _tmdbSeriesDetail = Rx<TmdbSeriesDetail>(TmdbSeriesDetail());
  final Rx<List<Item>> _similarSeries = Rx<List<Item>>([]);
  final Rx<bool> _isFavourite = Rx<bool>(false);
  final Rx<List<Season>> _season = Rx<List<Season>>([]);
  final Rx<String?> _selectedSeason = Rx<String?>(null);
  final Rx<List<Episode>> _episode = Rx<List<Episode>>([]);
  final Map<String, List<MovieSubtitle>> _subs = {};
  final Rx<List<DownloadLink>> _downloadLink = Rx<List<DownloadLink>>([]);

  Status get detailStatus => _detailStatus.value;
  Status get episodeStatus => _episodeStatus.value;
  ItemDetail get seriesDetail => _seriesDetail.value;
  List<Item> get similarSeries => _similarSeries.value;
  TmdbSeriesDetail get tmdbSeriesDetail => _tmdbSeriesDetail.value;
  final Item arguments = Get.arguments;
  bool get isFavourite => _isFavourite.value;
  List<Season> get season => _season.value;
  List<Episode> get episode => _episode.value;
  List<DownloadLink> get downloadLink => _downloadLink.value;
  String? get selectedSeason => _selectedSeason.value;

  set changeSeason(String? id) {
    _selectedSeason.value = id;
    if (_selectedSeason.value != id) {
      getEpisode();
    }
  }

  @override
  void onInit() {
    super.onInit();
    initFunction();
  }

  initFunction() async {
    Future.wait([
      getSeriesDetail(),
      getTmdbSeriesDetail(),
      checkFavourite(),
      getSeason(),
      getSimilarSeries(),
    ]).then((value) {
      getEpisode();
    }).catchError((e) {
      _detailStatus.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    });

    addViewLog();
  }

  Future<void> addViewLog() async {
    try {
      await apiService.post('$baseURL/addviewlog', {
        'user_id': loginController.user.id,
        'content_id': arguments.id,
        'content_type': '2',
      });
    } catch (e) {
      return;
    }
  }

  getEpisode() async {
    try {
      _episodeStatus.value = Status.loading;
      List<dynamic> response = await apiService.get('$baseURL/getEpisodes/$_selectedSeason');
      List<Episode> data = response.map((e) => EpisodeResponseModel.fromJson(e).toEntity()).toList();
      Future.wait(data.map((e) => getSubtitle(e.id)).toList()).then((value) {
        _episode.value = data;
        _episodeStatus.value = Status.success;
        _detailStatus.value = Status.success;
      }).catchError((e) {});
    } catch (e) {
      _episodeStatus.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    }
  }

  Future<void> getSubtitle(String? id) async {
    try {
      List<dynamic> response = await apiService.post('$baseURL/getsubtitle/$id/2', {});
      List<MovieSubtitle> subtitle = response.map((e) => MovieSubtitleResponseModel.fromJson(e).toEntity()).toList();
      _subs[id ?? ''] = subtitle;
    } catch (e) {
      return;
    }
  }

  getPlayerSource(int index) async {
    try {
      if (index >= episode.where((item) => item.url != '' && item.url != null).length) {
        throw Exception();
      }
      GlobalKey<BetterPlayerPlaylistState> keys = GlobalKey();

      final BetterPlayerPlaylist player = BetterPlayerPlaylist(
        key: keys,
        betterPlayerConfiguration: BetterPlayerConfiguration(
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
            customControlsBuilder: (controller, onPlayerVisibilityChanged) => CustomPlayerSeriesControl(
              controller: controller,
              onControlsVisibilityChanged: onPlayerVisibilityChanged,
              episode: episode,
              indexEpisode: index,
              playlistLength: episode.where((item) => item.url != '' && item.url != null).length,
              keyPlaylist: keys,
            ),
          ),
        ),
        betterPlayerDataSourceList: episode.where((item) => item.url != '' && item.url != null).map((e) {
          int indeks = downloadController.task.indexWhere((element) => element.taskId.split('/').last == '$selectedSeason-${e.id}');
          if (indeks == -1) {
            return BetterPlayerDataSource(BetterPlayerDataSourceType.network, e.url!,
                placeholder: CachedNetworkImage(
                  imageUrl: e.episoadeImage!,
                ),
                subtitles: _subs[e.id]
                    ?.map((sub) => BetterPlayerSubtitlesSource(
                          type: BetterPlayerSubtitlesSourceType.network,
                          name: sub.language,
                          selectedByDefault: true,
                          urls: [sub.subtitleUrl],
                        ))
                    .toList());
          } else {
            return BetterPlayerDataSource(BetterPlayerDataSourceType.file, downloadController.task[indeks].path!,
                placeholder: CachedNetworkImage(
                  imageUrl: e.episoadeImage!,
                ),
                subtitles: _subs[e.id]
                    ?.map((sub) => BetterPlayerSubtitlesSource(
                          type: BetterPlayerSubtitlesSourceType.network,
                          name: sub.language,
                          selectedByDefault: true,
                          urls: [sub.subtitleUrl],
                        ))
                    .toList());
          }
        }).toList(),
        betterPlayerPlaylistConfiguration: BetterPlayerPlaylistConfiguration(
          loopVideos: false,
          initialStartIndex: index,
        ),
      );
      Get.toNamed('player/series', arguments: player);
    } catch (e) {
      Get.snackbar('Ada Kesalahan', 'Gagal mendapatkan informasi player');
    }
  }

  Future<void> getSeason() async {
    try {
      List<dynamic> response = await apiService.get('$baseURL/getSeasons/${arguments.id}');
      List<Season> data = response.map((e) => SeasonResponseModel.fromJson(e).toEntity()).toList();
      if (data.isNotEmpty) {
        _selectedSeason.value = data.first.id;
      }
      _season.value = data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getEpisodeDownloadLink(String episodeId) async {
    try {
      List<dynamic> response = await apiService.get('$baseURL/getEpisodeDownloadLinks/$episodeId');
      List<DownloadLink> data = response.map((e) => DownloadLinkResponseModel.fromJson(e).toEntity()).toList();
      _downloadLink.value = data;
    } catch (e) {
      rethrow;
    }
  }

  void download(DownloadLink item, String episodeId) {
    downloadController.addDownloadTask(arguments, item, episode: episodeId);
  }

  Future<void> checkFavourite() async {
    try {
      final str = jsonEncode(arguments.toJson());
      final bytes = utf8.encode(str);
      final submit = Uri.encodeFull(base64.encode(bytes)).replaceAll('=', '');
      String response = await apiService.get('$baseURL/favourite/SEARCH/${loginController.user.id}/$submit/2');
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
    await apiService.get('$baseURL/favourite/SET/${loginController.user.id}/$submit/2');
    _isFavourite.value = true;
    Get.snackbar('Berhasil', 'Series telah ditambahkan ke favorit');
    savedController.getSaved();
  }

  removeFavourite() async {
    final str = jsonEncode(arguments.toJson());
    final bytes = utf8.encode(str);
    final submit = base64.encode(bytes).replaceAll('=', '');
    await apiService.get('$baseURL/favourite/REMOVE/${loginController.user.id}/$submit/2');
    _isFavourite.value = false;
    Get.snackbar('Berhasil', 'Series telah dihapus dari favorit');
    savedController.getSaved();
  }

  Future<void> getSeriesDetail() async {
    try {
      Map<String, dynamic> response = await apiService.get('$baseURL/getWebSeriesDetails/${arguments.id}');
      SeriesDetailResponseModel model = SeriesDetailResponseModel.fromJson(response);
      ItemDetail data = model.toEntity();
      _seriesDetail.value = data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getTmdbSeriesDetail() async {
    try {
      Map<String, dynamic> response = await apiService.get('$tmdbBaseURL/tv/${arguments.tmdbId}?api_key=$tmdbApiKey');
      TmdbSeriesDetailResponseModel model = TmdbSeriesDetailResponseModel.fromJson(response);
      TmdbSeriesDetail data = model.toEntity();
      _tmdbSeriesDetail.value = data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getSimilarSeries() async {
    try {
      List<dynamic> response = await apiService.post(
        '$baseURL/getRelatedWebseries/${arguments.id}/5',
        {
          'genres': arguments.genres,
        },
      );
      List<Item> data = response.map((e) => ItemResponseModel.fromJson(e).toEntity()).toList();
      _similarSeries.value = data;
    } catch (e) {
      return;
    }
  }
}
