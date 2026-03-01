import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late TvSeriesListNotifier provider;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();

    provider = TvSeriesListNotifier(
      getOnTheAirTvSeries: mockGetOnTheAirTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  test('initial state should be empty', () {
    expect(provider.onTheAirState, RequestState.Empty);
    expect(provider.popularTvSeriesState, RequestState.Empty);
    expect(provider.topRatedTvSeriesState, RequestState.Empty);
  });

  test('should fetch on the air tv series successfully', () async {
    when(
      mockGetOnTheAirTvSeries.execute(),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchOnTheAirTvSeries();

    expect(provider.onTheAirState, RequestState.Loaded);
    expect(provider.onTheAirTvSeries, testTvSeriesList);
  });

  test('should return error when on the air request fails', () async {
    when(
      mockGetOnTheAirTvSeries.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchOnTheAirTvSeries();

    expect(provider.onTheAirState, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });

  test('should fetch popular tv series successfully', () async {
    when(
      mockGetPopularTvSeries.execute(),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchPopularTvSeries();

    expect(provider.popularTvSeriesState, RequestState.Loaded);
    expect(provider.popularTvSeries, testTvSeriesList);
  });

  test('should fetch top rated tv series successfully', () async {
    when(
      mockGetTopRatedTvSeries.execute(),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchTopRatedTvSeries();

    expect(provider.topRatedTvSeriesState, RequestState.Loaded);
    expect(provider.topRatedTvSeries, testTvSeriesList);
  });
}
