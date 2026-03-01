import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvSeries = TvSeries(
  adult: false,
  backdropPath: '/backdrop.jpg',
  genreIds: [18, 10765],
  id: 100,
  originalName: 'Original Name',
  overview: 'overview',
  popularity: 123.4,
  posterPath: '/poster.jpg',
  firstAirDate: '2020-01-01',
  name: 'TV Name',
  voteAverage: 8.1,
  voteCount: 123,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: '/backdrop.jpg',
  genres: [Genre(id: 18, name: 'Drama')],
  id: 100,
  originalName: 'Original Name',
  overview: 'overview',
  posterPath: '/poster.jpg',
  firstAirDate: '2020-01-01',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  name: 'TV Name',
  voteAverage: 8.1,
  voteCount: 123,
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 100,
  name: 'TV Name',
  posterPath: '/poster.jpg',
  overview: 'overview',
);

final testTvSeriesTable = TvSeriesTable(
  id: 100,
  name: 'TV Name',
  posterPath: '/poster.jpg',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 100,
  'overview': 'overview',
  'posterPath': '/poster.jpg',
  'name': 'TV Name',
};

final testTvSeriesDetailResponse = TvSeriesDetailResponse(
  adult: false,
  backdropPath: '/backdrop.jpg',
  genres: [GenreModel(id: 18, name: 'Drama')],
  id: 100,
  originalName: 'Original Name',
  overview: 'overview',
  posterPath: '/poster.jpg',
  firstAirDate: '2020-01-01',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  name: 'TV Name',
  voteAverage: 8.1,
  voteCount: 123,
);
