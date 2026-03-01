import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailResponse extends Equatable {
  const TvSeriesDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final List<GenreModel> genres;
  final int id;
  final String originalName;
  final String overview;
  final String posterPath;
  final String firstAirDate;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String name;
  final double voteAverage;
  final int voteCount;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) {
    return TvSeriesDetailResponse(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'],
      genres: List<GenreModel>.from(
        (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
      ),
      id: json['id'],
      originalName: json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      firstAirDate: json['first_air_date'] ?? '',
      numberOfEpisodes: json['number_of_episodes'] ?? 0,
      numberOfSeasons: json['number_of_seasons'] ?? 0,
      name: json['name'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
    'id': id,
    'original_name': originalName,
    'overview': overview,
    'poster_path': posterPath,
    'first_air_date': firstAirDate,
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'name': name,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      adult: adult,
      backdropPath: backdropPath,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      name: name,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genres,
    id,
    originalName,
    overview,
    posterPath,
    firstAirDate,
    numberOfEpisodes,
    numberOfSeasons,
    name,
    voteAverage,
    voteCount,
  ];
}
