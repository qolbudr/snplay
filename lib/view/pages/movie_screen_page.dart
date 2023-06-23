import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/movie_controller.dart';
import 'package:snplay/view/widgets/item_banner_widget.dart';
import 'package:snplay/view/widgets/item_card_loading_widget.dart';
import 'package:snplay/view/widgets/item_card_widget.dart';
import 'package:snplay/view/widgets/section_title_widget.dart';
import 'package:snplay/view/widgets/slider_indicator.dart';

class MovieScreen extends StatelessWidget {
  MovieScreen({super.key});
  final MovieController movieController = Get.put(MovieController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Obx(
          () => movieController.bannerStatus != Status.success
              ? AspectRatio(
                  aspectRatio: 8 / 5,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.05),
                    highlightColor: Colors.white.withOpacity(0.2),
                    child: Container(color: Colors.white, width: double.infinity, height: double.infinity),
                  ),
                )
              : AspectRatio(
                  aspectRatio: 8 / 5,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      disableCenter: true,
                      aspectRatio: 1,
                      onPageChanged: (index, reason) => movieController.setBannerActiveIndex = index,
                      autoPlay: true,
                    ),
                    items: List.generate(
                      movieController.movieBanner.length,
                      (index) => ItemBannerWidget(
                        banner: movieController.movieBanner[index].banner,
                        name: movieController.movieBanner[index].name,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 5),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              movieController.movieBanner.length,
              (index) => movieController.bannerActiveIndex == index ? const SliderIndicator(isActive: true) : const SliderIndicator(isActive: false),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: "Film Baru Ditambahkan", detail: "Film di SnPlay", onTap: () {}),
        const SizedBox(height: 10),
        Obx(
          () => movieController.recentMovieStatus != Status.success
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
                    itemCount: movieController.recentMovie.length,
                    itemBuilder: (context, index) => ItemCard(
                      poster: movieController.recentMovie[index].poster ?? '-',
                      name: movieController.recentMovie[index].name ?? '-',
                      onTap: () {},
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 20),
        // SectionTitle(title: "Series Baru Ditambahkan", detail: "Series di SnPlay", onTap: () {}),
        // const SizedBox(height: 10),
        // Obx(
        //   () => homeController.recentSeriesStatus != Status.success
        //       ? AspectRatio(
        //           aspectRatio: Get.width / 150,
        //           child: ListView.separated(
        //             padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        //             shrinkWrap: true,
        //             scrollDirection: Axis.horizontal,
        //             separatorBuilder: (context, index) => const SizedBox(width: 10),
        //             itemCount: 5,
        //             itemBuilder: (context, index) => const ItemCardLoading(),
        //           ),
        //         )
        //       : AspectRatio(
        //           aspectRatio: Get.width / 150,
        //           child: ListView.separated(
        //             padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        //             shrinkWrap: true,
        //             scrollDirection: Axis.horizontal,
        //             separatorBuilder: (context, index) => const SizedBox(width: 10),
        //             itemCount: homeController.recentSeries.length,
        //             itemBuilder: (context, index) => ItemCard(
        //               poster: homeController.recentSeries[index].poster ?? '-',
        //               name: homeController.recentSeries[index].name ?? '-',
        //               onTap: () {},
        //             ),
        //           ),
        //         ),
        // ),
        // const SizedBox(height: 50),
      ],
    );
  }
}
