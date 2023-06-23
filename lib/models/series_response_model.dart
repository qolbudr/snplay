import 'package:snplay/view/entities/series_entity.dart';

class SeriesResponseModel {
  String? id;
  String? tMDBID;
  String? name;
  String? description;
  String? genres;
  String? releaseDate;
  String? poster;
  String? banner;
  String? youtubeTrailer;
  String? downloadable;
  String? type;
  String? status;
  String? contentType;

  SeriesResponseModel(
      {this.id, this.tMDBID, this.name, this.description, this.genres, this.releaseDate, this.poster, this.banner, this.youtubeTrailer, this.downloadable, this.type, this.status, this.contentType});

  SeriesResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tMDBID = json['TMDB_ID'];
    name = json['name'];
    description = json['description'];
    genres = json['genres'];
    releaseDate = json['release_date'];
    poster = json['poster'];
    banner = json['banner'];
    youtubeTrailer = json['youtube_trailer'];
    downloadable = json['downloadable'];
    type = json['type'];
    status = json['status'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['TMDB_ID'] = tMDBID;
    data['name'] = name;
    data['description'] = description;
    data['genres'] = genres;
    data['release_date'] = releaseDate;
    data['poster'] = poster;
    data['banner'] = banner;
    data['youtube_trailer'] = youtubeTrailer;
    data['downloadable'] = downloadable;
    data['type'] = type;
    data['status'] = status;
    data['content_type'] = contentType;
    return data;
  }

  Series toEntity() => Series(id: id, poster: poster, name: name);
}
