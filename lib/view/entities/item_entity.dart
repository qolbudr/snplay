class Item {
  String? id;
  String? tmdbId;
  String? poster;
  String? name;
  String? banner;
  String? genres;
  late String type;
  late String status;
  late String contentType;

  Item({this.id, this.tmdbId, this.poster, this.name, this.banner, this.genres, required this.type, required this.status, required this.contentType});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tmdbId = json['tmdbId'];
    name = json['name'];
    genres = json['genres'];
    poster = json['poster'];
    banner = json['banner'];
    type = json['type'] ?? '1';
    contentType = json['content_type'] ?? '1';
    status = json['status'] ?? '1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tmdbId'] = tmdbId;
    data['name'] = name;
    data['genres'] = genres;
    data['poster'] = poster;
    data['banner'] = banner;
    data['type'] = type;
    data['content_type'] = contentType;
    data['status'] = status;
    return data;
  }
}
