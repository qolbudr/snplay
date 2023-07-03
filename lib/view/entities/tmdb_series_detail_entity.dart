import 'package:snplay/models/tmdb_series_detail_response.dart';

class TmdbSeriesDetail {
  String? homepage;
  double? popularity;
  String? tagline;
  int? voteCount;
  double? voteAverage;
  String? studio;
  List<Cast>? cast;

  TmdbSeriesDetail({this.homepage, this.popularity, this.tagline, this.voteAverage, this.voteCount, this.studio, this.cast});
}
