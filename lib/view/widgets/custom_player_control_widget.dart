// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:better_player/src/controls/better_player_material_progress_bar.dart';
import 'package:better_player/src/core/better_player_utils.dart';
import 'package:snplay/controllers/player_controller.dart';

class CustomControl extends StatefulWidget {
  const CustomControl({super.key, required this.controller, required this.onControlsVisibilityChanged});
  final BetterPlayerController controller;
  final Function(bool visbility) onControlsVisibilityChanged;

  @override
  State<CustomControl> createState() => _CustomControlState();
}

class _CustomControlState extends State<CustomControl> {
  final PlayerController _playerController = Get.put(PlayerController());
  bool _isControlShow = true;
  bool _changeToShow = false;
  Timer? _checkBufferTimer;
  bool _isBuffer = false;
  Timer? _timer;
  List<Map<String, dynamic>> compiledTracks = [];
  String _selectedTrack = '';
  bool _enableSubtitle = true;

  Future<void> _showQualityModal() async {
    showModalBottomSheet<void>(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            const ListTile(
              title: Text("Pilih Resolusi Video"),
              subtitle: Text('Silahkan pilih resolusi video yang tersedia'),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: List.generate(
                  compiledTracks.length,
                  (index) => ListTile(
                    title: Text(
                      compiledTracks[index]['name'],
                      style: TextStyle(color: _selectedTrack == compiledTracks[index]['name'] ? primaryColor : Colors.white),
                    ),
                    onTap: () {
                      if (_selectedTrack != compiledTracks[index]['name']) {
                        widget.controller.setResolution(compiledTracks[index]['url']);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    widget.controller.addEventsListener((e) {
      if (mounted) {
        setState(() {});
      }
    });
    _getTrack();
    _showControl();
    _checkBuffer();
    super.initState();
  }

  void _getTrack() {
    Map<String, String> tracks = widget.controller.betterPlayerDataSource?.resolutions ?? {};
    tracks.forEach((key, value) {
      if (compiledTracks.isEmpty) {
        _selectedTrack = key;
      }

      compiledTracks.add(
        {
          'name': key,
          'url': value,
        },
      );
    });
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
                                                IconButton(
                                                  onPressed: () => _showQualityModal(),
                                                  icon: Icon(Icons.high_quality, size: Get.width * 0.03),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    if (_enableSubtitle) {
                                                      _enableSubtitle = false;
                                                      widget.controller.setupSubtitleSource(BetterPlayerSubtitlesSource(type: BetterPlayerSubtitlesSourceType.none));
                                                    } else {
                                                      _enableSubtitle = true;
                                                      BetterPlayerSubtitlesSource source = widget.controller.betterPlayerSubtitlesSourceList.where((element) => element.selectedByDefault!).first;
                                                      widget.controller.setupSubtitleSource(source);
                                                    }
                                                  },
                                                  icon: Icon(_enableSubtitle ? Icons.subtitles : Icons.subtitles_off, size: Get.width * 0.03),
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
