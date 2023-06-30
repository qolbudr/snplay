import 'package:snplay/view/entities/item_entity.dart';

class DownloadTaskEntity {
  late Item item;
  late double progress;
  late String url;
  String? path;
  String? episode;
  late String taskId;
  late String filename;
  late int status;

  void updateProgress(double newProgress) {
    progress = newProgress;
  }

  void updateStatus(int newStatus) {
    status = newStatus;
  }

  void updatePath(String newPath) {
    path = newPath;
  }

  DownloadTaskEntity.fromJson(Map<String, dynamic> json) {
    item = Item.fromJson(json['item']);
    progress = json['progress'];
    url = json['url'];
    path = json['path'];
    episode = json['episode'];
    taskId = json['taskId'];
    filename = json['filename'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item'] = item.toJson();
    data['progress'] = progress;
    data['url'] = url;
    data['path'] = path;
    data['episode'] = episode;
    data['taskId'] = taskId;
    data['filename'] = filename;
    data['status'] = status;
    return data;
  }

  DownloadTaskEntity({required this.item, required this.url, required this.progress, this.path, required this.status, required this.filename, required this.taskId});
}
