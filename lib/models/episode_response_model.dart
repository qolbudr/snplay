import 'package:snplay/view/entities/episode_entity.dart';

class EpisodeResponseModel {
  String? id;
  String? episoadeName;
  String? episoadeImage;
  String? episoadeDescription;
  String? episoadeOrder;
  String? seasonId;
  String? downloadable;
  String? type;
  String? status;
  String? source;
  String? url;
  String? skipAvailable;
  String? introStart;
  String? introEnd;
  String? endCreditsMarker;
  String? drmUuid;
  String? drmLicenseUri;

  EpisodeResponseModel(
      {this.id,
      this.episoadeName,
      this.episoadeImage,
      this.episoadeDescription,
      this.episoadeOrder,
      this.seasonId,
      this.downloadable,
      this.type,
      this.status,
      this.source,
      this.url,
      this.skipAvailable,
      this.introStart,
      this.introEnd,
      this.endCreditsMarker,
      this.drmUuid,
      this.drmLicenseUri});

  EpisodeResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    episoadeName = json['Episoade_Name'];
    episoadeImage = json['episoade_image'];
    episoadeDescription = json['episoade_description'];
    episoadeOrder = json['episoade_order'];
    seasonId = json['season_id'];
    downloadable = json['downloadable'];
    type = json['type'];
    status = json['status'];
    source = json['source'];
    url = json['url'];
    skipAvailable = json['skip_available'];
    introStart = json['intro_start'];
    introEnd = json['intro_end'];
    endCreditsMarker = json['end_credits_marker'];
    drmUuid = json['drm_uuid'];
    drmLicenseUri = json['drm_license_uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Episoade_Name'] = episoadeName;
    data['episoade_image'] = episoadeImage;
    data['episoade_description'] = episoadeDescription;
    data['episoade_order'] = episoadeOrder;
    data['season_id'] = seasonId;
    data['downloadable'] = downloadable;
    data['type'] = type;
    data['status'] = status;
    data['source'] = source;
    data['url'] = url;
    data['skip_available'] = skipAvailable;
    data['intro_start'] = introStart;
    data['intro_end'] = introEnd;
    data['end_credits_marker'] = endCreditsMarker;
    data['drm_uuid'] = drmUuid;
    data['drm_license_uri'] = drmLicenseUri;
    return data;
  }

  Episode toEntity() => Episode(
      id: id,
      episoadeName: episoadeName,
      episoadeDescription: episoadeDescription,
      episoadeImage: episoadeImage,
      seasonId: seasonId,
      downloadable: downloadable,
      type: type,
      source: source,
      url: url,
      skipAvailable: skipAvailable,
      introStart: introStart,
      introEnd: introEnd,
      status: status);
}
