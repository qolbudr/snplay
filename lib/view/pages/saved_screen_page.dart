import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/saved_controller.dart';
import 'package:snplay/view/widgets/item_card_widget.dart';

class Saved extends StatelessWidget {
  Saved({super.key});
  final SavedController savedController = Get.put(SavedController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => savedController.status != Status.success
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
                savedController.result.length,
                (index) => ItemCard(
                  poster: savedController.result[index].poster ?? '-',
                  name: savedController.result[index].name ?? '-',
                  onTap: () {
                    if (savedController.result[index].contentType == '1') {
                      Get.toNamed('movie', arguments: savedController.result[index]);
                    } else if (savedController.result[index].contentType == '2') {
                      Get.toNamed('series', arguments: savedController.result[index]);
                    } else {
                      Get.snackbar('Ada Kesalahan', 'Data tidak diketahui');
                    }
                  },
                ),
              ),
            ),
    );
  }
}
