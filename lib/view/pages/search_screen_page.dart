import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/home_controller.dart';
import 'package:snplay/controllers/search_controller.dart';
import 'package:snplay/controllers/series_controller.dart';
import 'package:snplay/view/widgets/item_card_loading_widget.dart';
import 'package:snplay/view/widgets/item_card_widget.dart';
import 'package:snplay/view/widgets/section_title_widget.dart';

class Search extends StatelessWidget {
  Search({super.key});
  final SearchController searchController = Get.put(SearchController());
  final HomeController homeController = Get.put(HomeController());
  final SeriesCotroller seriesController = Get.put(SeriesCotroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintStyle: h3,
            hintText: "Cari film atau series pilihan anda contoh \"John Wick\"",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
      body: Obx(
        () => searchController.status != Status.success
            ? const Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
            : ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Genre", style: h4),
                        const SizedBox(height: 10),
                        AspectRatio(
                          aspectRatio: Get.width / 40,
                          child: ListView.separated(
                            itemCount: searchController.genre.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 10),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                searchController.genre[index].name,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  SectionTitle(
                    title: 'Acak',
                    detail: 'Film di SnPlay',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => homeController.recentMovieStatus != Status.success
                        ? AspectRatio(
                            aspectRatio: Get.width / 150,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                              itemCount: 5,
                              itemBuilder: (context, index) => const ItemCardLoading(),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: Get.width / 150,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                              itemCount: homeController.recentMovie.length,
                              itemBuilder: (context, index) => ItemCard(
                                poster: homeController.recentMovie[index].poster ?? '-',
                                name: homeController.recentMovie[index].name ?? '-',
                                onTap: () {
                                  Get.toNamed('/movie', arguments: homeController.recentMovie[index]);
                                },
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  SectionTitle(
                    title: 'Acak',
                    detail: 'Series di SnPlay',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => seriesController.recentSeriesStatus != Status.success
                        ? AspectRatio(
                            aspectRatio: Get.width / 150,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                              itemCount: 5,
                              itemBuilder: (context, index) => const ItemCardLoading(),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: Get.width / 150,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                              itemCount: seriesController.recentSeries.length,
                              itemBuilder: (context, index) => ItemCard(
                                poster: seriesController.recentSeries[index].poster ?? '-',
                                name: seriesController.recentSeries[index].name ?? '-',
                                onTap: () {
                                  Get.toNamed('/movie', arguments: seriesController.recentSeries[index]);
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
