import 'package:snplay/models/tmdb_movie_detail_response_model.dart';

class TmdbMovieDetail {
  String? homepage;
  double? popularity;
  String? tagline;
  int? voteCount;
  double? voteAverage;
  String? studio;
  List<Cast>? cast;

  TmdbMovieDetail({this.homepage, this.popularity, this.tagline, this.voteAverage, this.voteCount, this.studio, this.cast});
}
