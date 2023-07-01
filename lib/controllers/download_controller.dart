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

  StreamSubscription<TaskUpdate>? get stream => _stream;

  List<DownloadTaskEntity> get removeDupliTask {
    List<DownloadTaskEntity> temp = [];
    for (var element in task) {
      String parsedId = element.taskId.split('/').first;
      if (temp.indexWhere((item) => item.taskId.contains(parsedId)) == -1) {
        temp.add(element);
      }
    }
    return temp;
  }

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
        int newIndex;
        if (_task.value[index].episode != null) {
          String parsedId = _task.value[index].taskId.split('/').first;
          newIndex = _task.value.indexWhere((element) => element.taskId.contains(parsedId));
        } else {
          newIndex = index;
        }

        if (index != -1) {
          _task.value[newIndex].updateProgress(update.progress);

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

  void addDownloadTask(Item item, DownloadLink downloadLink, {String? episode}) {
    String filename = downloadLink.url!.split('/').last;
    DownloadTaskEntity model;
    if (episode == null) {
      model = DownloadTaskEntity(taskId: '${item.name}-${item.id}', url: downloadLink.url!, item: item, progress: 0, status: 0, filename: filename, episode: episode);
    } else {
      model = DownloadTaskEntity(taskId: '${item.name}-${item.id}$episode', url: downloadLink.url!, item: item, progress: 0, status: 0, filename: filename, episode: episode);
    }
    if (_task.value.where((element) => element.taskId == model.taskId).isEmpty && episode == null) {
      final task = DownloadTask(taskId: model.taskId, url: downloadLink.url!, filename: filename, allowPause: true, updates: Updates.statusAndProgress);
      _task.value.add(model);
      download(task);
    } else if (episode != null) {
      final task = DownloadTask(taskId: model.taskId, url: downloadLink.url!, filename: filename, allowPause: true, updates: Updates.statusAndProgress);
      _task.value.add(model);
      download(task);
    } else {
      Get.snackbar('Ada Kesalahan', 'Data sedang ada di task download');
    }
  }

  void deleteTask(int index) {
    String taskId = _task.value[index].taskId;
    _task.value.removeWhere((item) => item.taskId == taskId);
    dbService.updateDownloadList(_task.value);
    updater.value += 1;
  }

  void download(DownloadTask task) async {
    FileDownloader().configureNotification(running: TaskNotification('Downloading', 'file: ${task.filename}'), progressBar: true);
    await FileDownloader().enqueue(task);
  }
}
