import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/series_controller.dart';
import 'package:snplay/view/widgets/item_banner_widget.dart';
import 'package:snplay/view/widgets/item_card_loading_widget.dart';
import 'package:snplay/view/widgets/item_card_widget.dart';
import 'package:snplay/view/widgets/section_title_widget.dart';
import 'package:snplay/view/widgets/slider_indicator.dart';

class SeriesScreen extends StatelessWidget {
  SeriesScreen({super.key});
  final SeriesCotroller seriesCotroller = Get.put(SeriesCotroller());

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Obx(
          () => seriesCotroller.bannerStatus != Status.success
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
                      onPageChanged: (index, reason) => seriesCotroller.setBannerActiveIndex = index,
                      autoPlay: true,
                    ),
                    items: List.generate(
                      seriesCotroller.seriesBanner.length,
                      (index) => ItemBannerWidget(
                        banner: seriesCotroller.seriesBanner[index].banner,
                        name: seriesCotroller.seriesBanner[index].name,
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
              seriesCotroller.seriesBanner.length,
              (index) => seriesCotroller.bannerActiveIndex == index ? const SliderIndicator(isActive: true) : const SliderIndicator(isActive: false),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: "Series Baru Ditambahkan", detail: "Series di SnPlay", onTap: () {}),
        const SizedBox(height: 10),
        Obx(
          () => seriesCotroller.recentSeriesStatus != Status.success
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
                    itemCount: seriesCotroller.recentSeries.length,
                    itemBuilder: (context, index) => ItemCard(
                      poster: seriesCotroller.recentSeries[index].poster ?? '-',
                      name: seriesCotroller.recentSeries[index].name ?? '-',
                      onTap: () {
                        Get.toNamed('/series', arguments: seriesCotroller.recentSeries[index]);
                      },
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: "Acak", detail: "Series di SnPlay", onTap: () {}),
        const SizedBox(height: 10),
        Obx(
          () => seriesCotroller.randomSeriesStatus != Status.success
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
                    itemCount: seriesCotroller.randomSeries.length,
                    itemBuilder: (context, index) => ItemCard(
                      poster: seriesCotroller.randomSeries[index].poster ?? '-',
                      name: seriesCotroller.randomSeries[index].name ?? '-',
                      onTap: () {
                        Get.toNamed('/series', arguments: seriesCotroller.randomSeries[index]);
                      },
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
