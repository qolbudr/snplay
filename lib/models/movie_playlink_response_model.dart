import 'package:snplay/view/entities/movie_playlink_entity.dart';

class MoviePlaylinkResponseModel {
  String? id;
  String? name;
  String? size;
  String? quality;
  String? linkOrder;
  String? movieId;
  String? url;
  String? type;
  String? status;
  String? skipAvailable;
  String? introStart;
  String? introEnd;
  String? endCreditsMarker;
  String? linkType;
  String? drmUuid;
  String? drmLicenseUri;

  MoviePlaylinkResponseModel(
      {this.id,
      this.name,
      this.size,
      this.quality,
      this.linkOrder,
      this.movieId,
      this.url,
      this.type,
      this.status,
      this.skipAvailable,
      this.introStart,
      this.introEnd,
      this.endCreditsMarker,
      this.linkType,
      this.drmUuid,
      this.drmLicenseUri});

  MoviePlaylinkResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    size = json['size'];
    quality = json['quality'];
    linkOrder = json['link_order'];
    movieId = json['movie_id'];
    url = json['url'];
    type = json['type'];
    status = json['status'];
    skipAvailable = json['skip_available'];
    introStart = json['intro_start'];
    introEnd = json['intro_end'];
    endCreditsMarker = json['end_credits_marker'];
    linkType = json['link_type'];
    drmUuid = json['drm_uuid'];
    drmLicenseUri = json['drm_license_uri'];
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
    data['status'] = status;
    data['skip_available'] = skipAvailable;
    data['intro_start'] = introStart;
    data['intro_end'] = introEnd;
    data['end_credits_marker'] = endCreditsMarker;
    data['link_type'] = linkType;
    data['drm_uuid'] = drmUuid;
    data['drm_license_uri'] = drmLicenseUri;
    return data;
  }

  MoviePlaylink toEntity() => MoviePlaylink(id: id, name: name, quality: quality, movieId: movieId, url: url);
}
