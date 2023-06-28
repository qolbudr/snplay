class Item {
  String? id;
  String? tmdbId;
  String? poster;
  String? name;
  String? banner;
  String? genres;
  String type;
  String status;

  Item({this.id, this.tmdbId, this.poster, this.name, this.banner, this.genres, required this.type, required this.status});
}
