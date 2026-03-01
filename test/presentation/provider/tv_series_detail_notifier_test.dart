import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late TvSeriesDetailNotifier provider;
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

    provider = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchlistStatusTvSeries: mockGetWatchlistStatusTvSeries,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
    );
  });

  test('should get tv detail data from usecase', () async {
    when(
      mockGetTvSeriesDetail.execute(100),
    ).thenAnswer((_) async => Right(testTvSeriesDetail));
    when(
      mockGetTvSeriesRecommendations.execute(100),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchTvSeriesDetail(100);

    verify(mockGetTvSeriesDetail.execute(100));
    expect(provider.tvSeries, testTvSeriesDetail);
  });

  test(
    'should update recommendation state when recommendation is loaded',
    () async {
      when(
        mockGetTvSeriesDetail.execute(100),
      ).thenAnswer((_) async => Right(testTvSeriesDetail));
      when(
        mockGetTvSeriesRecommendations.execute(100),
      ).thenAnswer((_) async => Right(testTvSeriesList));

      await provider.fetchTvSeriesDetail(100);

      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, testTvSeriesList);
    },
  );

  test(
    'should update error message when recommendation request fails',
    () async {
      when(
        mockGetTvSeriesDetail.execute(100),
      ).thenAnswer((_) async => Right(testTvSeriesDetail));
      when(
        mockGetTvSeriesRecommendations.execute(100),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));

      await provider.fetchTvSeriesDetail(100);

      expect(provider.message, 'Failed');
    },
  );

  test('should get watchlist status', () async {
    when(
      mockGetWatchlistStatusTvSeries.execute(1),
    ).thenAnswer((_) async => true);

    await provider.loadWatchlistStatus(1);

    expect(provider.isAddedToWatchlist, true);
  });

  test('should execute save watchlist when function called', () async {
    when(
      mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    when(
      mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
    ).thenAnswer((_) async => true);

    await provider.addWatchlist(testTvSeriesDetail);

    verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
  });

  test('should execute remove watchlist when function called', () async {
    when(
      mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Removed from Watchlist'));
    when(
      mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
    ).thenAnswer((_) async => false);

    await provider.removeFromWatchlist(testTvSeriesDetail);

    verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
  });

  test('should update watchlist message when save watchlist success', () async {
    when(
      mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    when(
      mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
    ).thenAnswer((_) async => true);

    await provider.addWatchlist(testTvSeriesDetail);

    expect(provider.watchlistMessage, 'Added to Watchlist');
  });

  test('should update watchlist message when save watchlist failed', () async {
    when(
      mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
    ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
    when(
      mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
    ).thenAnswer((_) async => false);

    await provider.addWatchlist(testTvSeriesDetail);

    expect(provider.watchlistMessage, 'Failed');
  });
}
