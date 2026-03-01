import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late PopularTvSeriesNotifier provider;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    provider = PopularTvSeriesNotifier(mockGetPopularTvSeries);
  });

  test('should fetch popular tv series data successfully', () async {
    when(
      mockGetPopularTvSeries.execute(),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchPopularTvSeries();

    expect(provider.state, RequestState.Loaded);
    expect(provider.tvSeries, testTvSeriesList);
  });

  test('should return error when request fails', () async {
    when(
      mockGetPopularTvSeries.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Failed')));

    await provider.fetchPopularTvSeries();

    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Failed');
  });
}
