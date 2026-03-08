import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetWatchlistTvSeries extends Mock implements GetWatchlistTvSeries {}

void main() {
  late WatchlistTvSeriesCubit cubit;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    cubit = WatchlistTvSeriesCubit(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('fetchWatchlistTvSeries', () {
    blocTest<WatchlistTvSeriesCubit, WatchlistTvSeriesState>(
      'should emit Loading then Loaded when success',
      build: () {
        when(
          () => mockGetWatchlistTvSeries.execute(),
        ).thenAnswer((_) async => Right(testTvSeriesList));
        return cubit;
      },
      act: (cubit) => cubit.fetchWatchlistTvSeries(),
      expect: () => [
        const WatchlistTvSeriesState(
          watchlistState: RequestState.Loading,
          message: '',
        ),
        WatchlistTvSeriesState(
          watchlistState: RequestState.Loaded,
          watchlistTvSeries: testTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(() => mockGetWatchlistTvSeries.execute()).called(1);
      },
    );

    blocTest<WatchlistTvSeriesCubit, WatchlistTvSeriesState>(
      'should emit Loading then Error when fails',
      build: () {
        when(
          () => mockGetWatchlistTvSeries.execute(),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchWatchlistTvSeries(),
      expect: () => [
        const WatchlistTvSeriesState(
          watchlistState: RequestState.Loading,
          message: '',
        ),
        const WatchlistTvSeriesState(
          watchlistState: RequestState.Error,
          message: 'Database Failure',
        ),
      ],
    );
  });
}
