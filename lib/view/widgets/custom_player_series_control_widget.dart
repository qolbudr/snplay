// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:better_player/src/controls/better_player_material_progress_bar.dart';
import 'package:better_player/src/core/better_player_utils.dart';
import 'package:snplay/controllers/player_controller.dart';
import 'package:snplay/view/entities/episode_entity.dart';

class CustomPlayerSeriesControl extends StatefulWidget {
  const CustomPlayerSeriesControl(
      {super.key, required this.controller, required this.onControlsVisibilityChanged, required this.playlistLength, required this.keyPlaylist, required this.episode, required this.indexEpisode});
  final BetterPlayerController controller;
  final int playlistLength, indexEpisode;
  final Function(bool visbility) onControlsVisibilityChanged;
  final GlobalKey<BetterPlayerPlaylistState> keyPlaylist;
  final List<Episode> episode;

  @override
  State<CustomPlayerSeriesControl> createState() => _CustomPlayerSeriesControl();
}

class _CustomPlayerSeriesControl extends State<CustomPlayerSeriesControl> {
  final PlayerController _playerController = Get.put(PlayerController());
  bool _isControlShow = true;
  bool _changeToShow = false;
  Timer? _checkBufferTimer;
  bool _isBuffer = false;
  Timer? _timer;
  Map<String, BetterPlayerAsmsTrack> compiledTrack = {};
  bool _enableSubtitle = true;
  bool _isShowPlaylist = false;
  bool _isShowPL = false;
  int _index = 0;

  void _showPlaylist() {
    setState(() {
      _isShowPlaylist = true;
      _isShowPL = true;
    });
  }

  @override
  void initState() {
    widget.controller.addEventsListener((e) {
      if (mounted) {
        _getTrack();
        setState(() {});
      }
    });
    _showControl();
    _checkBuffer();
    _index = widget.indexEpisode;
    super.initState();
  }

  void _getTrack() {
    List<BetterPlayerAsmsTrack> tracks = widget.controller.betterPlayerAsmsTracks;
    for (var track in tracks) {
      if (track.width != 0) {
        compiledTrack['${track.height}p'] = track;
      }
    }
    compiledTrack['Auto'] = BetterPlayerAsmsTrack.defaultTrack();
  }

  void _resetTimer() {
    _timer?.cancel();
    _hideControl();
  }

  void _checkBuffer() {
    _checkBufferTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _isBuffer = ((widget.controller.isBuffering() ?? true));
        });
      }

      if (_isBuffer) {
        if (mounted) {
          setState(() {
            _isControlShow = true;
            _changeToShow = false;
          });
        }
      } else {
        _resetTimer();
        _checkBufferTimer?.cancel();
        Future.delayed(const Duration(seconds: 1), () {
          _checkBuffer();
        });
      }
    });
  }

  void _showControl() {
    if (mounted) {
      setState(() {
        _isControlShow = true;
        _changeToShow = false;
      });
    }
  }

  void _hideControl() {
    _timer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isControlShow = false;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeEventsListener((p0) => {});
    _checkBufferTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (widget.controller.videoPlayerController?.value.hasError ?? false)
          ? Container(
              color: Colors.black.withOpacity(0.5),
              width: Get.width,
              height: Get.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error,
                    size: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Video tidak bisa diputar",
                    style: h4,
                  ),
                ],
              ),
            )
          : _isShowPL
              ? Positioned.fill(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    onEnd: () {
                      setState(() {
                        _isShowPL = false;
                      });
                    },
                    duration: const Duration(milliseconds: 500),
                    opacity: _isShowPlaylist ? 1 : 0,
                    child: Container(
                      color: secondaryColor,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      _isShowPL = false;
                                      _isShowPlaylist = false;
                                    },
                                  );
                                },
                                icon: const Icon(Icons.close),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: widget.playlistLength,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  widget.keyPlaylist.currentState?.betterPlayerPlaylistController?.setupDataSource(index);
                                  setState(() {
                                    _isShowPL = false;
                                    _isShowPlaylist = false;
                                    _index = index;
                                  });
                                },
                                child: Container(
                                  color: _index == index ? primaryColor.withOpacity(0.3) : Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: CachedNetworkImage(
                                              imageUrl: widget.episode[index].episoadeImage ?? '-',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.episode[index].episoadeName ?? '-',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: h4.copyWith(fontWeight: FontWeight.w600),
                                              ),
                                              const SizedBox(height: 15),
                                              Text(
                                                widget.episode[index].episoadeDescription ?? '-',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: h5.copyWith(
                                                  color: Colors.white.withOpacity(0.5),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.download_outlined,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              : _playerController.showControlInit.value
                  ? Positioned.fill(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: !_changeToShow
                          ? AnimatedOpacity(
                              onEnd: () {
                                setState(() {
                                  _changeToShow = true;
                                });
                              },
                              duration: const Duration(milliseconds: 500),
                              opacity: _isControlShow ? 1 : 0,
                              child: Scaffold(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                body: Stack(
                                  children: [
                                    SizedBox(
                                      width: Get.width,
                                      height: Get.height,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(15),
                                            width: Get.width,
                                            child: Row(
                                              children: [
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    // IconButton(
                                                    //   onPressed: () => _showQualityModal(),
                                                    //   icon: Icon(Icons.high_quality, size: Get.width * 0.03),
                                                    // ),
                                                    IconButton(
                                                      onPressed: () {
                                                        if (_enableSubtitle) {
                                                          _enableSubtitle = false;
                                                          widget.controller.setupSubtitleSource(BetterPlayerSubtitlesSource(type: BetterPlayerSubtitlesSourceType.none));
                                                        } else {
                                                          _enableSubtitle = true;
                                                          List<BetterPlayerSubtitlesSource> source =
                                                              widget.controller.betterPlayerSubtitlesSourceList.where((element) => element.selectedByDefault ?? true).toList();
                                                          if (source.isNotEmpty) {
                                                            widget.controller.setupSubtitleSource(source.first);
                                                          } else {
                                                            Get.snackbar('Ada Kesalahan', 'Subtitle tidak ditemukan');
                                                          }
                                                        }
                                                      },
                                                      icon: Icon(_enableSubtitle ? Icons.subtitles : Icons.subtitles_off, size: Get.width * 0.03),
                                                    ),
                                                    IconButton(
                                                      onPressed: () => _showPlaylist(),
                                                      icon: Icon(Icons.playlist_play_outlined, size: Get.width * 0.03),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          (_isBuffer)
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    CircularProgressIndicator(
                                                      color: primaryColor,
                                                    )
                                                  ],
                                                )
                                              : const SizedBox(),
                                          const SizedBox(height: 60),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        height: 146,
                                        width: Get.width,
                                        padding: const EdgeInsets.all(15),
                                        color: secondaryColor.withOpacity(0.5),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 40,
                                              child: BetterPlayerMaterialVideoProgressBar(
                                                widget.controller.videoPlayerController,
                                                widget.controller,
                                                colors: BetterPlayerProgressColors(
                                                  playedColor: primaryColor,
                                                  bufferedColor: const Color.fromARGB(255, 49, 49, 49),
                                                  handleColor: primaryColor,
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(BetterPlayerUtils.formatDuration(widget.controller.videoPlayerController?.value.position ?? const Duration(seconds: 0))),
                                                const Spacer(),
                                                Text(BetterPlayerUtils.formatDuration(widget.controller.videoPlayerController?.value.duration ?? const Duration(seconds: 0))),
                                              ],
                                            ),
                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                          Duration? videoDuration = await widget.controller.videoPlayerController!.position;
                                                          setState(() {
                                                            if (widget.controller.isPlaying()!) {
                                                              Duration rewindDuration = Duration(seconds: (videoDuration!.inSeconds - 10));
                                                              if (rewindDuration < widget.controller.videoPlayerController!.value.duration!) {
                                                                widget.controller.seekTo(const Duration(seconds: 0));
                                                              } else {
                                                                widget.controller.seekTo(rewindDuration);
                                                              }
                                                            }
                                                          });
                                                        },
                                                        icon: Icon(Icons.fast_rewind, size: Get.width * 0.03)),
                                                    IconButton(onPressed: null, icon: Icon(Icons.skip_previous, size: Get.width * 0.03)),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _resetTimer();
                                                        if (widget.controller.isPlaying() ?? false) {
                                                          widget.controller.pause();
                                                        } else {
                                                          widget.controller.play();
                                                        }
                                                      },
                                                      child: Container(
                                                        width: Get.width * 0.065,
                                                        height: Get.width * 0.065,
                                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                                                        child: Center(
                                                          child: Icon(
                                                            ((widget.controller.isPlaying() ?? false)) ? Icons.pause : Icons.play_arrow,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(onPressed: null, icon: Icon(Icons.skip_next, size: Get.width * 0.03)),
                                                    IconButton(
                                                        onPressed: () async {
                                                          Duration? videoDuration = await widget.controller.videoPlayerController!.position;
                                                          setState(() {
                                                            if (widget.controller.isPlaying()!) {
                                                              Duration forwardDuration = Duration(seconds: (videoDuration!.inSeconds + 10));
                                                              if (forwardDuration > widget.controller.videoPlayerController!.value.duration!) {
                                                                widget.controller.seekTo(const Duration(seconds: 0));
                                                                widget.controller.pause();
                                                              } else {
                                                                widget.controller.seekTo(forwardDuration);
                                                              }
                                                            }
                                                          });
                                                        },
                                                        icon: Icon(Icons.fast_forward, size: Get.width * 0.03)),
                                                  ],
                                                ),
                                                const Spacer(),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: _showControl,
                              child: Container(
                                color: Colors.transparent,
                                width: Get.width,
                                height: Get.height,
                              ),
                            ),
                    )
                  : const SizedBox(),
    );
  }
}
