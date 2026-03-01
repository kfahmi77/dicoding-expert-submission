import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late WatchlistTvSeriesNotifier provider;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    provider = WatchlistTvSeriesNotifier(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    );
  });

  test(
    'should change tv series data when data is gotten successfully',
    () async {
      when(
        mockGetWatchlistTvSeries.execute(),
      ).thenAnswer((_) async => Right([testWatchlistTvSeries]));

      await provider.fetchWatchlistTvSeries();

      expect(provider.watchlistState, RequestState.Loaded);
      expect(provider.watchlistTvSeries, [testWatchlistTvSeries]);
    },
  );

  test('should return error when data is unsuccessful', () async {
    when(
      mockGetWatchlistTvSeries.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchWatchlistTvSeries();

    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });
}
