import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/on_the_air_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late OnTheAirTvSeriesNotifier provider;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    provider = OnTheAirTvSeriesNotifier(mockGetOnTheAirTvSeries);
  });

  test('should fetch on the air tv series data successfully', () async {
    when(
      mockGetOnTheAirTvSeries.execute(),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchOnTheAirTvSeries();

    expect(provider.state, RequestState.Loaded);
    expect(provider.tvSeries, testTvSeriesList);
  });

  test('should return error when request fails', () async {
    when(
      mockGetOnTheAirTvSeries.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Failed')));

    await provider.fetchOnTheAirTvSeries();

    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Failed');
  });
}
