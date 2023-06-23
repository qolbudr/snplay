import 'package:snplay/view/entities/custom_banner_entity.dart';

class CustomBannerResponseModel {
  String? id;
  String? title;
  String? banner;
  String? contentType;
  String? contentId;
  String? url;
  String? status;

  CustomBannerResponseModel({this.id, this.title, this.banner, this.contentType, this.contentId, this.url, this.status});

  CustomBannerResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    banner = json['banner'];
    contentType = json['content_type'];
    contentId = json['content_id'];
    url = json['url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['banner'] = banner;
    data['content_type'] = contentType;
    data['content_id'] = contentId;
    data['url'] = url;
    data['status'] = status;
    return data;
  }

  CustomBanner toEntity() => CustomBanner(id: contentId, name: title ?? '-', banner: banner, type: contentType);
}
