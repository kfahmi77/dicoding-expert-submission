import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
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
  final tTvSeriesModelList = [tTvSeriesModel];

  group('on the air tv series', () {
    test(
      'should return remote data when call to remote data source is success',
      () async {
        when(
          mockRemoteDataSource.getOnTheAirTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);

        final result = await repository.getOnTheAirTvSeries();

        verify(mockRemoteDataSource.getOnTheAirTvSeries());
        result.fold(
          (failure) => fail('Expected right result'),
          (tvSeriesList) => expect(tvSeriesList, testTvSeriesList),
        );
      },
    );

    test('should return server failure when call unsuccessful', () async {
      when(
        mockRemoteDataSource.getOnTheAirTvSeries(),
      ).thenThrow(ServerException());

      final result = await repository.getOnTheAirTvSeries();

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when no internet', () async {
      when(
        mockRemoteDataSource.getOnTheAirTvSeries(),
      ).thenThrow(const SocketException('Failed'));

      final result = await repository.getOnTheAirTvSeries();

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('popular tv series', () {
    test('should return tv list when call success', () async {
      when(
        mockRemoteDataSource.getPopularTvSeries(),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getPopularTvSeries();

      result.fold(
        (failure) => fail('Expected right result'),
        (tvSeriesList) => expect(tvSeriesList, testTvSeriesList),
      );
    });
  });

  group('top rated tv series', () {
    test('should return tv list when call success', () async {
      when(
        mockRemoteDataSource.getTopRatedTvSeries(),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getTopRatedTvSeries();

      result.fold(
        (failure) => fail('Expected right result'),
        (tvSeriesList) => expect(tvSeriesList, testTvSeriesList),
      );
    });
  });

  group('tv detail', () {
    test('should return detail data when call success', () async {
      when(
        mockRemoteDataSource.getTvSeriesDetail(100),
      ).thenAnswer((_) async => testTvSeriesDetailResponse);

      final result = await repository.getTvSeriesDetail(100);

      result.fold(
        (failure) => fail('Expected right result'),
        (tvSeriesDetail) => expect(tvSeriesDetail, testTvSeriesDetail),
      );
    });
  });

  group('recommendations', () {
    test('should return recommendations list when call success', () async {
      when(
        mockRemoteDataSource.getTvSeriesRecommendations(100),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getTvSeriesRecommendations(100);

      result.fold(
        (failure) => fail('Expected right result'),
        (tvSeriesList) => expect(tvSeriesList, testTvSeriesList),
      );
    });
  });

  group('search tv series', () {
    test('should return search list when call success', () async {
      when(
        mockRemoteDataSource.searchTvSeries('TV Name'),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.searchTvSeries('TV Name');

      result.fold(
        (failure) => fail('Expected right result'),
        (tvSeriesList) => expect(tvSeriesList, testTvSeriesList),
      );
    });
  });

  group('save watchlist tv series', () {
    test('should return success message when save successful', () async {
      when(
        mockLocalDataSource.insertWatchlist(testTvSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlistTvSeries(testTvSeriesDetail);

      expect(result, equals(const Right('Added to Watchlist')));
    });

    test('should return DatabaseFailure when save unsuccessful', () async {
      when(
        mockLocalDataSource.insertWatchlist(testTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlistTvSeries(testTvSeriesDetail);

      expect(result, equals(Left(DatabaseFailure('Failed to add watchlist'))));
    });
  });

  group('remove watchlist tv series', () {
    test('should return success message when remove successful', () async {
      when(
        mockLocalDataSource.removeWatchlist(testTvSeriesTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlistTvSeries(
        testTvSeriesDetail,
      );

      expect(result, equals(const Right('Removed from Watchlist')));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(
        mockLocalDataSource.removeWatchlist(testTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));

      final result = await repository.removeWatchlistTvSeries(
        testTvSeriesDetail,
      );

      expect(
        result,
        equals(Left(DatabaseFailure('Failed to remove watchlist'))),
      );
    });
  });

  group('watchlist status', () {
    test('should return watchlist status whether data is found', () async {
      when(
        mockLocalDataSource.getTvSeriesById(1),
      ).thenAnswer((_) async => testTvSeriesTable);

      final result = await repository.isAddedToWatchlistTvSeries(1);

      expect(result, true);
    });
  });

  group('watchlist tv series', () {
    test('should return list of tv series', () async {
      when(
        mockLocalDataSource.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [testTvSeriesTable]);

      final result = await repository.getWatchlistTvSeries();

      result.fold(
        (failure) => fail('Expected right result'),
        (tvSeriesList) => expect(tvSeriesList, [testWatchlistTvSeries]),
      );
    });
  });
}
