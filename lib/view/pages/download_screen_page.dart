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
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.5),
                height: 30,
              ),
              itemCount: downloadController.removeDupliTask.length,
              itemBuilder: (context, index) => Stack(
                children: [
                  ListTile(
                    onTap: () {
                      if (downloadController.removeDupliTask[index].item.contentType == '1') {
                        Get.toNamed('/movie', arguments: downloadController.removeDupliTask[index].item);
                      } else {
                        Get.toNamed('/series', arguments: downloadController.removeDupliTask[index].item);
                      }
                    },
                    leading: CachedNetworkImage(
                      imageUrl: downloadController.removeDupliTask[index].item.poster ?? '-',
                      width: 40,
                    ),
                    title: Text(downloadController.removeDupliTask[index].item.name ?? '-'),
                    subtitle: Text(downloadController.removeDupliTask[index].item.genres ?? '-'),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () => downloadController.deleteTask(index),
                    ),
                  ),
                  if (downloadController.removeDupliTask[index].progress < 1)
                    Positioned(
                      bottom: -3,
                      left: 15,
                      right: 15,
                      child: LinearProgressIndicator(
                        value: downloadController.removeDupliTask[index].progress,
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
