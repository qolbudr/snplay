import 'package:snplay/view/entities/genre_entity.dart';

class GenreResponseModel {
  String? id;
  String? name;
  String? icon;
  String? description;
  String? featured;
  String? status;

  GenreResponseModel({this.id, this.name, this.icon, this.description, this.featured, this.status});

  GenreResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    featured = json['featured'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['description'] = description;
    data['featured'] = featured;
    data['status'] = status;
    return data;
  }

  Genre toEntity() => Genre(id: id, name: name ?? '-', description: description ?? '-', featured: featured ?? '0', icon: icon ?? '-');
}
