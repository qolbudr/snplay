import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/genre_controller.dart';
import 'package:snplay/view/widgets/item_card_widget.dart';

class GenreScreen extends StatelessWidget {
  GenreScreen({super.key});
  final String genre = Get.arguments;
  final GenreController genreController = Get.put(GenreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genre),
      ),
      body: Obx(
        () => genreController.status != Status.success
            ? const Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
            : GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 5 / 9,
                padding: const EdgeInsets.all(15),
                children: List.generate(
                  genreController.result.length,
                  (index) => ItemCard(
                    poster: genreController.result[index].poster ?? '-',
                    name: genreController.result[index].name ?? '-',
                    onTap: () {
                      if (genreController.result[index].contentType == '1') {
                        Get.toNamed('movie', arguments: genreController.result[index]);
                      } else if (genreController.result[index].contentType == '2') {
                        Get.toNamed('series', arguments: genreController.result[index]);
                      } else {
                        Get.snackbar('Ada Kesalahan', 'Data tidak diketahui');
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
