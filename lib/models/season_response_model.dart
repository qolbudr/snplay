import 'package:snplay/view/entities/season_entity.dart';

class SeasonResponseModel {
  String? id;
  String? sessionName;
  String? seasonOrder;
  String? webSeriesId;
  String? status;

  SeasonResponseModel({this.id, this.sessionName, this.seasonOrder, this.webSeriesId, this.status});

  SeasonResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionName = json['Session_Name'];
    seasonOrder = json['season_order'];
    webSeriesId = json['web_series_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Session_Name'] = sessionName;
    data['season_order'] = seasonOrder;
    data['web_series_id'] = webSeriesId;
    data['status'] = status;
    return data;
  }

  Season toEntity() => Season(id: id, sessionName: sessionName, webSeriesId: webSeriesId);
}
