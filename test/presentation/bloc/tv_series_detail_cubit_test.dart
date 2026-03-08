import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTvSeriesDetail extends Mock implements GetTvSeriesDetail {}

class MockGetTvSeriesRecommendations extends Mock
    implements GetTvSeriesRecommendations {}

class MockGetWatchlistStatusTvSeries extends Mock
    implements GetWatchlistStatusTvSeries {}

class MockSaveWatchlistTvSeries extends Mock implements SaveWatchlistTvSeries {}

class MockRemoveWatchlistTvSeries extends Mock
    implements RemoveWatchlistTvSeries {}

void main() {
  late TvSeriesDetailCubit cubit;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchlistStatusTvSeries mockGetWatchlistStatusTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatusTvSeries = MockGetWatchlistStatusTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    cubit = TvSeriesDetailCubit(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchlistStatusTvSeries: mockGetWatchlistStatusTvSeries,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tId = 100;
  final tTvSeriesList = <TvSeries>[testTvSeries];

  group('fetchTvSeriesDetail', () {
    void arrangeSuccess() {
      when(
        () => mockGetTvSeriesDetail.execute(tId),
      ).thenAnswer((_) async => Right(testTvSeriesDetail));
      when(
        () => mockGetTvSeriesRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvSeriesList));
    }

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit Loading then Loaded when detail and recommendations succeed',
      build: () {
        arrangeSuccess();
        return cubit;
      },
      act: (cubit) => cubit.fetchTvSeriesDetail(tId),
      expect: () => [
        const TvSeriesDetailState(
          tvSeriesState: RequestState.Loading,
          recommendationState: RequestState.Empty,
          message: '',
        ),
        TvSeriesDetailState(
          tvSeries: testTvSeriesDetail,
          tvSeriesState: RequestState.Loading,
          recommendationState: RequestState.Loading,
          message: '',
        ),
        TvSeriesDetailState(
          tvSeries: testTvSeriesDetail,
          tvSeriesState: RequestState.Loaded,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: tTvSeriesList,
          message: '',
        ),
      ],
      verify: (_) {
        verify(() => mockGetTvSeriesDetail.execute(tId)).called(1);
        verify(() => mockGetTvSeriesRecommendations.execute(tId)).called(1);
      },
    );

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit Error when getTvSeriesDetail fails',
      build: () {
        when(
          () => mockGetTvSeriesDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          () => mockGetTvSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return cubit;
      },
      act: (cubit) => cubit.fetchTvSeriesDetail(tId),
      expect: () => [
        const TvSeriesDetailState(
          tvSeriesState: RequestState.Loading,
          recommendationState: RequestState.Empty,
          message: '',
        ),
        const TvSeriesDetailState(
          tvSeriesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit recommendation Error when getRecommendations fails',
      build: () {
        when(
          () => mockGetTvSeriesDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvSeriesDetail));
        when(
          () => mockGetTvSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchTvSeriesDetail(tId),
      expect: () => [
        const TvSeriesDetailState(
          tvSeriesState: RequestState.Loading,
          recommendationState: RequestState.Empty,
          message: '',
        ),
        TvSeriesDetailState(
          tvSeries: testTvSeriesDetail,
          tvSeriesState: RequestState.Loading,
          recommendationState: RequestState.Loading,
          message: '',
        ),
        TvSeriesDetailState(
          tvSeries: testTvSeriesDetail,
          tvSeriesState: RequestState.Loaded,
          recommendationState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('addWatchlist', () {
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit watchlistMessage and update status when add succeeds',
      build: () {
        when(
          () => mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testTvSeriesDetail),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Added to Watchlist'),
        const TvSeriesDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit failure message when add fails',
      build: () {
        when(
          () => mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
        ).thenAnswer(
          (_) async => Left(DatabaseFailure('Failed to add watchlist')),
        );
        when(
          () => mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testTvSeriesDetail),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Failed to add watchlist'),
      ],
    );
  });

  group('removeFromWatchlist', () {
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit watchlistMessage and update status when remove succeeds',
      build: () {
        when(
          () => mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          () => mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.removeFromWatchlist(testTvSeriesDetail),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Removed from Watchlist'),
      ],
    );
  });

  group('loadWatchlistStatus', () {
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit isAddedToWatchlist true',
      build: () {
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tId),
        ).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.loadWatchlistStatus(tId),
      expect: () => [const TvSeriesDetailState(isAddedToWatchlist: true)],
    );

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit isAddedToWatchlist false',
      build: () {
        when(
          () => mockGetWatchlistStatusTvSeries.execute(tId),
        ).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.loadWatchlistStatus(tId),
      expect: () => [const TvSeriesDetailState(isAddedToWatchlist: false)],
    );
  });
}
