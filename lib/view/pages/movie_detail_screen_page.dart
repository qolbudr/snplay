import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/movie_controller.dart';
import 'package:snplay/controllers/movie_detail_controller.dart';
import 'package:snplay/view/entities/item_entity.dart';
import 'package:snplay/view/widgets/item_card_widget.dart';
import 'package:snplay/view/widgets/section_title_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Item movie = Get.arguments;
  final MovieDetailController movieDetailController = Get.put(MovieDetailController());
  final MovieController movieController = Get.put(MovieController());
  final LoginController loginController = Get.put(LoginController());

  Future<void> _showDownloadModal() async {
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
                  movieDetailController.downloadLink.length,
                  (index) => ListTile(
                    title: Text(
                      '${movieDetailController.downloadLink[index].name} - ${movieDetailController.downloadLink[index].quality ?? '-'}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      movieDetailController.download(movieDetailController.downloadLink[index]);
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
                          imageUrl: movie.banner ?? '-',
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
                                imageUrl: movie.poster ?? '-',
                                width: 150,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Obx(
                                  () => movieDetailController.detailStatus == Status.success
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              movieDetailController.movieDetail.name ?? '-',
                                              style: h4.copyWith(fontWeight: FontWeight.w600),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "${movieDetailController.movieDetail.releaseDate?.year ?? '0000'} · ${movieDetailController.movieDetail.runtime ?? '0min'} · ${'${movieDetailController.tmdbMovieDetail.voteCount ?? 0} vote'}",
                                              style: h5.copyWith(
                                                color: Colors.white.withOpacity(0.5),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text('${movieDetailController.tmdbMovieDetail.popularity} 🍿'),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: List.generate(5, (index) {
                                                if (index <= (movieDetailController.tmdbMovieDetail.voteAverage ?? 0) / 2) {
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
                () => movieDetailController.detailStatus == Status.success
                    ? Column(
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
                                        onPressed: () => movieDetailController.getPlayerSource(),
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
                                            if (movieDetailController.isFavourite) {
                                              movieDetailController.removeFavourite();
                                            } else {
                                              movieDetailController.addFavourite();
                                            }
                                          },
                                          icon: (movieDetailController.isFavourite) ? const Icon(Icons.bookmark, color: primaryColor) : const Icon(Icons.bookmark_outline),
                                        ),
                                        if (movie.type == '0' || loginController.user.subscriptionType!.contains('3'))
                                          IconButton(
                                            splashRadius: 20,
                                            onPressed: movieDetailController.isDownloaded
                                                ? null
                                                : () {
                                                    if (movieDetailController.downloadLink.isEmpty) {
                                                      Get.snackbar("Ada Kesalahan", "Unduhan tidak tersedia");
                                                    } else {
                                                      _showDownloadModal();
                                                    }
                                                  },
                                            icon: movieDetailController.isDownloaded ? const Icon(Icons.check, color: primaryColor) : const Icon(Icons.download_outlined),
                                          )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  movieDetailController.movieDetail.description ?? '-',
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
                                        Text(movieDetailController.tmdbMovieDetail.homepage ?? '-'),
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
                                        Text(movieDetailController.tmdbMovieDetail.tagline ?? '-'),
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
                                        Text(movieDetailController.tmdbMovieDetail.studio ?? '-'),
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
                                        Text(movieDetailController.movieDetail.genre?.replaceAll(',', ', ') ?? '-'),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text("Pemeran", style: h4),
                                const SizedBox(height: 10),
                                AspectRatio(
                                  aspectRatio: Get.width / 140,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) => const SizedBox(width: 20),
                                    itemCount: movieDetailController.tmdbMovieDetail.cast?.length ?? 0,
                                    itemBuilder: (context, index) => Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: "https://image.tmdb.org/t/p/w276_and_h350_face/${movieDetailController.tmdbMovieDetail.cast?[index].profilePath}",
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(movieDetailController.tmdbMovieDetail.cast?[index].character ?? '-'),
                                        const SizedBox(height: 5),
                                        Text(
                                          movieDetailController.tmdbMovieDetail.cast?[index].originalName ?? '-',
                                          style: smallText.copyWith(color: Colors.white.withOpacity(0.8)),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          (movieDetailController.similarMovie.isNotEmpty)
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
                                        itemCount: movieDetailController.similarMovie.length,
                                        itemBuilder: (context, index) => ItemCard(
                                          poster: movieDetailController.similarMovie[index].poster ?? '-',
                                          name: movieDetailController.similarMovie[index].name ?? '-',
                                          onTap: () {
                                            Get.delete<MovieDetailController>();
                                            Get.toNamed('/movie', arguments: movieDetailController.similarMovie[index], preventDuplicates: false);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    SectionTitle(title: "Acak", detail: "Film di SnPlay", onTap: () {}),
                                    const SizedBox(height: 10),
                                    AspectRatio(
                                      aspectRatio: Get.width / 150,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                                        itemCount: movieController.randomMovie.length,
                                        itemBuilder: (context, index) => ItemCard(
                                          poster: movieController.randomMovie[index].poster ?? '-',
                                          name: movieController.randomMovie[index].name ?? '-',
                                          onTap: () {
                                            Get.toNamed('/movie', arguments: movieController.randomMovie[index]);
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
