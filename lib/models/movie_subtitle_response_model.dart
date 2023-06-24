import 'package:snplay/view/entities/movie_subtitle_entity.dart';

class MovieSubtitleResponseModel {
  String? id;
  String? contentId;
  String? contentType;
  String? language;
  String? subtitleUrl;
  String? mimeType;
  String? status;

  MovieSubtitleResponseModel({this.id, this.contentId, this.contentType, this.language, this.subtitleUrl, this.mimeType, this.status});

  MovieSubtitleResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentId = json['content_id'];
    contentType = json['content_type'];
    language = json['language'];
    subtitleUrl = json['subtitle_url'];
    mimeType = json['mime_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content_id'] = contentId;
    data['content_type'] = contentType;
    data['language'] = language;
    data['subtitle_url'] = subtitleUrl;
    data['mime_type'] = mimeType;
    data['status'] = status;
    return data;
  }

  MovieSubtitle toEntity() => MovieSubtitle(id: id, contentId: contentId, contentType: contentType, language: language, subtitleUrl: subtitleUrl);
}
