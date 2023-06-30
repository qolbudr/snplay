import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:get/get.dart';
import 'package:snplay/controllers/services/db_service.dart';
import 'package:snplay/view/entities/download_link_entity.dart';
import 'package:snplay/view/entities/download_task_entity.dart';
import 'package:snplay/view/entities/item_entity.dart';

class DownloadController extends GetxController {
  static DownloadController instance = Get.find();
  final Rx<List<DownloadTaskEntity>> _task = Rx<List<DownloadTaskEntity>>([]);
  final Rx<int> updater = Rx<int>(1);
  final dbService = DBService();
  StreamSubscription<TaskUpdate>? _stream;
  List<DownloadTaskEntity> get task => _task.value;

  @override
  void onInit() {
    _stream = FileDownloader().updates.listen((update) async {
      if (update is TaskStatusUpdate) {
        int index = _task.value.indexWhere((element) => element.taskId == update.task.taskId);
        if (index != -1) {
          _task.value[index].updateStatus(1);
          updater.value += 1;
          dbService.updateDownloadList(_task.value);
        }
      } else if (update is TaskProgressUpdate) {
        int index = _task.value.indexWhere((element) => element.taskId == update.task.taskId);
        if (index != -1) {
          _task.value[index].updateProgress(update.progress);

          if (update.progress == 1) {
            String path = await update.task.filePath();
            _task.value[index].updatePath(path);
          }

          updater.value += 1;
          dbService.updateDownloadList(_task.value);
        }
      }
    });

    getDownload();
    super.onInit();
  }

  @override
  void onClose() {
    _stream?.cancel();
    super.onClose();
  }

  getDownload() async {
    _task.value = await dbService.getDownload();
  }

  void addDownloadTask(Item item, DownloadLink downloadLink) {
    String filename = downloadLink.url!.split('/').last;
    DownloadTaskEntity model = DownloadTaskEntity(taskId: filename, url: downloadLink.url!, item: item, progress: 0, status: 0, filename: filename);
    if (_task.value.where((element) => element.item.id! == item.id).isEmpty) {
      final task = DownloadTask(taskId: model.taskId, url: downloadLink.url!, filename: filename, allowPause: true, updates: Updates.statusAndProgress);
      _task.value.add(model);
      download(task);
    } else {
      Get.snackbar('Ada Kesalahan', 'Data sedang ada di task download');
    }
  }

  void deleteTask(int index) {
    _task.value.removeAt(index);
    dbService.updateDownloadList(_task.value);
    updater.value += 1;
  }

  void download(DownloadTask task) async {
    FileDownloader().configureNotification(running: TaskNotification('Downloading', 'file: ${task.filename}'), progressBar: true);
    await FileDownloader().enqueue(task);
  }
}
