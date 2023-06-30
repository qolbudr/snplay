import 'package:snplay/view/entities/download_link_entity.dart';

class DownloadLinkResponseModel {
  String? id;
  String? name;
  String? size;
  String? quality;
  String? linkOrder;
  String? movieId;
  String? url;
  String? type;
  String? downloadType;
  String? status;

  DownloadLinkResponseModel({this.id, this.name, this.size, this.quality, this.linkOrder, this.movieId, this.url, this.type, this.downloadType, this.status});

  DownloadLinkResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    size = json['size'];
    quality = json['quality'];
    linkOrder = json['link_order'];
    movieId = json['movie_id'];
    url = json['url'];
    type = json['type'];
    downloadType = json['download_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['size'] = size;
    data['quality'] = quality;
    data['link_order'] = linkOrder;
    data['movie_id'] = movieId;
    data['url'] = url;
    data['type'] = type;
    data['download_type'] = downloadType;
    data['status'] = status;
    return data;
  }

  DownloadLink toEntity() => DownloadLink(id: id, name: name, size: size, status: status, url: url, movieId: movieId, quality: quality);
}
