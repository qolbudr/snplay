import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/download_controller.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/series_controller.dart';
import 'package:snplay/controllers/series_detail_controller.dart';
import 'package:snplay/view/entities/item_entity.dart';
import 'package:snplay/view/widgets/item_card_widget.dart';
import 'package:snplay/view/widgets/section_title_widget.dart';

class SeriesDetailScreen extends StatefulWidget {
  const SeriesDetailScreen({super.key});

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  final Item series = Get.arguments;
  final SeriesDetailController seriesDetailController = Get.put(SeriesDetailController());
  final SeriesCotroller seriesController = Get.put(SeriesCotroller());
  final DownloadController downloadController = Get.put(DownloadController());
  final LoginController loginController = Get.put(LoginController());

  Future<void> _showDownloadModal(String episodeId) async {
    showModalBottomSheet<void>(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            const ListTile(
              title: Text("Pilih Unduhan"),
              subtitle: Text('Silahkan pilih link unduhan yang tersedia'),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: List.generate(
                  seriesDetailController.downloadLink.length,
                  (index) => ListTile(
                    title: Text(
                      '${seriesDetailController.downloadLink[index].name} - ${seriesDetailController.downloadLink[index].quality ?? '-'}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      seriesDetailController.download(seriesDetailController.downloadLink[index], episodeId);
                      Get.snackbar("Berhasil", "Unduhan telah dimulai");
                      Navigator.pop(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: Get.width / 300,
                        child: CachedNetworkImage(
                          imageUrl: series.banner ?? '-',
                          fit: BoxFit.cover,
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: Get.width / 300,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CachedNetworkImage(
                                imageUrl: series.poster ?? '-',
                                width: 150,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Obx(
                                  () => seriesDetailController.detailStatus == Status.success
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              seriesDetailController.seriesDetail.name ?? '-',
                                              style: h4.copyWith(fontWeight: FontWeight.w600),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "${seriesDetailController.seriesDetail.releaseDate?.year ?? '0000'} · ${seriesDetailController.seriesDetail.runtime ?? '0min'} · ${'${seriesDetailController.tmdbSeriesDetail.voteCount ?? 0} vote'}",
                                              style: h5.copyWith(
                                                color: Colors.white.withOpacity(0.5),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text('${seriesDetailController.tmdbSeriesDetail.popularity} 🍿'),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: List.generate(5, (index) {
                                                if (index <= (seriesDetailController.tmdbSeriesDetail.voteAverage ?? 0) / 2) {
                                                  return const Icon(Icons.star, color: primaryColor);
                                                } else {
                                                  return const Icon(Icons.star);
                                                }
                                              }),
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Obx(
                () => seriesDetailController.detailStatus == Status.success
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: ElevatedButton(
                                        style: defaultButtonStyle.copyWith(padding: MaterialStateProperty.all(const EdgeInsets.all(8))),
                                        onPressed: () => seriesDetailController.getPlayerSource(0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.play_arrow, size: 30),
                                            SizedBox(width: 5),
                                            Text("Play"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        IconButton(
                                          splashRadius: 20,
                                          onPressed: () {
                                            if (seriesDetailController.isFavourite) {
                                              seriesDetailController.removeFavourite();
                                            } else {
                                              seriesDetailController.addFavourite();
                                            }
                                          },
                                          icon: (seriesDetailController.isFavourite) ? const Icon(Icons.bookmark, color: primaryColor) : const Icon(Icons.bookmark_outline),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  seriesDetailController.seriesDetail.description ?? '-',
                                  style: h5.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        Text(
                                          'HOMEPAGE',
                                          style: h5.copyWith(
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                        Text(seriesDetailController.tmdbSeriesDetail.homepage ?? '-'),
                                      ],
                                    ),
                                    rowSpacer,
                                    TableRow(
                                      children: [
                                        Text(
                                          'TAGLINE',
                                          style: h5.copyWith(
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                        Text(seriesDetailController.tmdbSeriesDetail.tagline ?? '-'),
                                      ],
                                    ),
                                    rowSpacer,
                                    TableRow(
                                      children: [
                                        Text(
                                          'STUDIO',
                                          style: h5.copyWith(
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                        Text(seriesDetailController.tmdbSeriesDetail.studio ?? '-'),
                                      ],
                                    ),
                                    rowSpacer,
                                    TableRow(
                                      children: [
                                        Text(
                                          'GENRE',
                                          style: h5.copyWith(
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                        Text(seriesDetailController.seriesDetail.genre?.replaceAll(',', ', ') ?? '-'),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (seriesDetailController.season.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Season", style: h4),
                                  const SizedBox(height: 15),
                                  AspectRatio(
                                    aspectRatio: Get.width / 40,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                        seriesDetailController.season.length,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () => seriesDetailController.changeSeason = seriesDetailController.season[index].id,
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 10),
                                              color: (seriesDetailController.selectedSeason == seriesDetailController.season[index].id) ? primaryColor : secondaryColor,
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                seriesDetailController.season[index].sessionName ?? '-',
                                                style: h5.copyWith(
                                                  color: (seriesDetailController.selectedSeason == seriesDetailController.season[index].id) ? Colors.black : Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          const SizedBox(height: 15),
                          (seriesDetailController.episodeStatus == Status.success)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Text("Episode", style: h4),
                                    ),
                                    const SizedBox(height: 15),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                      itemCount: seriesDetailController.episode.length,
                                      separatorBuilder: (context, index) => const Divider(color: secondaryColor),
                                      itemBuilder: (context, index) => GestureDetector(
                                        onTap: () => seriesDetailController.getPlayerSource(index),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              child: AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: CachedNetworkImage(
                                                  imageUrl: seriesDetailController.episode[index].episoadeImage ?? '-',
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
                                                    seriesDetailController.episode[index].episoadeName ?? '-',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: h4.copyWith(fontWeight: FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    seriesDetailController.episode[index].episoadeDescription ?? '-',
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
                                            if (series.type == '0' || loginController.user.subscriptionType!.contains('3'))
                                              IconButton(
                                                onPressed: downloadController.task.indexWhere(
                                                            (element) => element.taskId.split('/').last == '${seriesDetailController.selectedSeason}-${seriesDetailController.episode[index].id!}') ==
                                                        -1
                                                    ? () {
                                                        Get.snackbar('Loading', 'Memuat informasi download');
                                                        seriesDetailController.getEpisodeDownloadLink(seriesDetailController.episode[index].id!).then((value) {
                                                          _showDownloadModal('/${seriesDetailController.selectedSeason}-${seriesDetailController.episode[index].id!}');
                                                        }).catchError((e) {
                                                          Get.snackbar('Ada Kesalahan', 'Gagal mendapatkan informasi download');
                                                        });
                                                      }
                                                    : null,
                                                icon: Builder(builder: (context) {
                                                  int isDownload = downloadController.task.indexWhere(
                                                      (element) => element.taskId.split('/').last == '${seriesDetailController.selectedSeason}-${seriesDetailController.episode[index].id!}');
                                                  if (isDownload == -1) {
                                                    return const Icon(
                                                      Icons.download_outlined,
                                                    );
                                                  } else {
                                                    return const Icon(
                                                      Icons.check,
                                                      color: primaryColor,
                                                    );
                                                  }
                                                }),
                                              )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox(
                                  width: Get.width,
                                  height: 300,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    color: primaryColor,
                                  )),
                                ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text("Pemeran", style: h4),
                          ),
                          const SizedBox(height: 10),
                          AspectRatio(
                            aspectRatio: Get.width / 160,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => const SizedBox(width: 20),
                              itemCount: seriesDetailController.tmdbSeriesDetail.cast?.length ?? 0,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: "https://image.tmdb.org/t/p/w276_and_h350_face/${seriesDetailController.tmdbSeriesDetail.cast?[index].profilePath}",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(seriesDetailController.tmdbSeriesDetail.cast?[index].character ?? '-'),
                                  const SizedBox(height: 5),
                                  Text(
                                    seriesDetailController.tmdbSeriesDetail.cast?[index].originalName ?? '-',
                                    style: smallText.copyWith(color: Colors.white.withOpacity(0.8)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          (seriesDetailController.similarSeries.isNotEmpty)
                              ? Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    SectionTitle(title: "Film Serupa", detail: "Film di SnPlay", onTap: () {}),
                                    const SizedBox(height: 10),
                                    AspectRatio(
                                      aspectRatio: Get.width / 150,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                                        itemCount: seriesDetailController.similarSeries.length,
                                        itemBuilder: (context, index) => ItemCard(
                                          poster: seriesDetailController.similarSeries[index].poster ?? '-',
                                          name: seriesDetailController.similarSeries[index].name ?? '-',
                                          onTap: () {
                                            Get.delete<SeriesDetailController>();
                                            Get.toNamed('/series', arguments: seriesDetailController.similarSeries[index], preventDuplicates: false);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    SectionTitle(title: "Acak", detail: "Series di SnPlay", onTap: () {}),
                                    const SizedBox(height: 10),
                                    AspectRatio(
                                      aspectRatio: Get.width / 150,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                                        itemCount: seriesController.randomSeries.length,
                                        itemBuilder: (context, index) => ItemCard(
                                          poster: seriesController.randomSeries[index].poster ?? '-',
                                          name: seriesController.randomSeries[index].name ?? '-',
                                          onTap: () {
                                            Get.toNamed('/movie', arguments: seriesController.randomSeries[index]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 50),
                        ],
                      )
                    : SizedBox(
                        width: Get.width,
                        height: 300,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      ),
              )
            ],
          ),
          Positioned(
            child: Container(
              color: Colors.black.withOpacity(0),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
