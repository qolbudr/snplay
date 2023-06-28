import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/root_controller.dart';
import 'package:snplay/view/pages/home_screen_page.dart';
import 'package:snplay/view/pages/movie_screen_page.dart';
import 'package:snplay/view/pages/series_screen_page.dart';
import 'package:snplay/view/widgets/drawer_menu_widget.dart';

class Root extends StatelessWidget {
  Root({super.key});
  final LoginController loginController = Get.put(LoginController());
  final RootController rootController = Get.put(RootController());
  final List<String> appBarText = ["Beranda", "Film", "Series"];
  final List<Widget> screen = [Home(), MovieScreen(), SeriesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        child: Obx(
          () => Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: DrawerHeader(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: secondaryColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: 'https://ui-avatars.com/api/?name=${loginController.user.name}&background=ECAC07&color=fff&size=512',
                          width: 70,
                          height: 70,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(loginController.user.name ?? '-', style: h4.copyWith(fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerMenu(
                      onTap: () => rootController.setSelectedIndex = 0,
                      name: "Beranda",
                      icon: Icons.home_outlined,
                      isActive: rootController.selectedIndex == 0,
                    ),
                    DrawerMenu(
                      onTap: () => rootController.setSelectedIndex = 1,
                      name: "Film",
                      icon: Icons.movie_outlined,
                      isActive: rootController.selectedIndex == 1,
                    ),
                    DrawerMenu(
                      onTap: () => rootController.setSelectedIndex = 2,
                      name: "Series",
                      icon: Icons.tv_outlined,
                      isActive: rootController.selectedIndex == 2,
                    ),
                    DrawerMenu(
                      onTap: () => rootController.setSelectedIndex = 3,
                      name: "Tersimpan",
                      icon: Icons.bookmark_outline,
                      isActive: rootController.selectedIndex == 3,
                    ),
                    DrawerMenu(
                      onTap: () => rootController.setSelectedIndex = 4,
                      name: "Download",
                      icon: Icons.downloading_outlined,
                      isActive: rootController.selectedIndex == 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Obx(
          () => Text(appBarText[rootController.selectedIndex]),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/search'),
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: Obx(
        () => screen[rootController.selectedIndex],
      ),
    );
  }
}
