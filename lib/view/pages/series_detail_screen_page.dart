import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/series_detail_controller.dart';
import 'package:snplay/view/entities/series_entity.dart';
import 'package:snplay/view/widgets/item_card_widget.dart';
import 'package:snplay/view/widgets/section_title_widget.dart';

class SeriesDetailScreen extends StatelessWidget {
  SeriesDetailScreen({super.key});
  final Series series = Get.arguments;
  final SeriesDetailController seriesDetailController = Get.put(SeriesDetailController());

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
                                            Text("Mainkan"),
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
                                    SizedBox(
                                      width: Get.width,
                                      height: 300,
                                      child: ListView.separated(
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
                          if (seriesDetailController.similarSeries.isNotEmpty)
                            Column(
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
