import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
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

  final tTvSeriesMap = {
    'adult': false,
    'backdrop_path': '/backdrop.jpg',
    'genre_ids': [18, 10765],
    'id': 100,
    'original_name': 'Original Name',
    'overview': 'overview',
    'popularity': 123.4,
    'poster_path': '/poster.jpg',
    'first_air_date': '2020-01-01',
    'name': 'TV Name',
    'vote_average': 8.1,
    'vote_count': 123,
  };

  test('should be a subclass of Equatable', () {
    expect(tTvSeriesModel.props.isNotEmpty, true);
  });

  test('fromJson should return a valid model', () {
    final result = TvSeriesModel.fromJson(tTvSeriesMap);
    expect(result, tTvSeriesModel);
  });

  test('toJson should return a JSON map containing proper data', () {
    final result = tTvSeriesModel.toJson();
    expect(result, tTvSeriesMap);
  });
}
