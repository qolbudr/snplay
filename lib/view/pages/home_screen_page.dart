import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/home_controller.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/view/widgets/movie_banner_widget.dart';
import 'package:snplay/view/widgets/slider_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController homeController = Get.put(HomeController());
  final LoginController loginController = Get.put(LoginController());
  final bannerScrollController = ScrollController();

  @override
  void dispose() {
    bannerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: secondaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: 'https://ui-avatars.com/api/?name=${loginController.user.name}&background=ECAC07&color=fff',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(loginController.user.name ?? '-', style: h3),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Beranda"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          AspectRatio(
            aspectRatio: 8 / 5,
            child: Obx(
              () => CarouselSlider(
                options: CarouselOptions(viewportFraction: 1.0, disableCenter: true, aspectRatio: 1, onPageChanged: (index, reason) => homeController.setBannerActiveIndex = index, autoPlay: true),
                items: List.generate(
                  homeController.movieBanner.length,
                  (index) => MovieBannerWidget(
                    banner: homeController.movieBanner[index].banner,
                    name: homeController.movieBanner[index].name,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                homeController.movieBanner.length,
                (index) => homeController.bannerActiveIndex == index ? const SliderIndicator(isActive: true) : const SliderIndicator(isActive: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
