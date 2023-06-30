class DownloadLink {
  String? id;
  String? name;
  String? size;
  String? quality;
  String? movieId;
  String? url;
  String? status;

  DownloadLink({this.id, this.name, this.size, this.quality, this.movieId, this.url, this.status});

  DownloadLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    size = json['size'];
    quality = json['quality'];
    movieId = json['movie_id'];
    url = json['url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['size'] = size;
    data['quality'] = quality;
    data['movie_id'] = movieId;
    data['url'] = url;
    data['status'] = status;
    return data;
  }
}
