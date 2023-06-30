import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/download_controller.dart';

class DownloadScreen extends StatelessWidget {
  DownloadScreen({super.key});
  final DownloadController downloadController = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${downloadController.updater.value}',
            style: const TextStyle(color: Colors.transparent),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: secondaryColor,
                height: 50,
              ),
              itemCount: downloadController.task.length,
              itemBuilder: (context, index) => Stack(
                children: [
                  ListTile(
                    onTap: () {
                      if (downloadController.task[index].item.contentType == '1') {
                        Get.toNamed('/movie', arguments: downloadController.task[index].item);
                      } else {
                        Get.toNamed('/series', arguments: downloadController.task[index].item);
                      }
                    },
                    leading: CachedNetworkImage(
                      imageUrl: downloadController.task[index].item.poster ?? '-',
                      width: 40,
                    ),
                    title: Text(downloadController.task[index].item.name ?? '-'),
                    subtitle: Text(downloadController.task[index].item.genres ?? '-'),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () => downloadController.deleteTask(index),
                    ),
                  ),
                  if (downloadController.task[index].progress < 1)
                    Positioned(
                      bottom: -3,
                      left: 15,
                      right: 15,
                      child: LinearProgressIndicator(
                        value: downloadController.task[index].progress,
                        color: primaryColor,
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
