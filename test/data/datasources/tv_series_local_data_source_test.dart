import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('save watchlist tv series', () {
    test('should return success message when data saved', () async {
      when(
        mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.insertWatchlist(testTvSeriesTable);

      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when failed', () async {
      when(
        mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable),
      ).thenThrow(Exception('Failed to add watchlist'));

      final call = dataSource.insertWatchlist(testTvSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist tv series', () {
    test('should return success message when remove success', () async {
      when(
        mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testTvSeriesTable);

      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove failed', () async {
      when(
        mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable),
      ).thenThrow(Exception('Failed to remove watchlist'));

      final call = dataSource.removeWatchlist(testTvSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get tv series by id', () {
    test('should return TvSeriesTable when data is found', () async {
      when(
        mockDatabaseHelper.getTvSeriesById(1),
      ).thenAnswer((_) async => testTvSeriesMap);

      final result = await dataSource.getTvSeriesById(1);

      expect(result, testTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getTvSeriesById(1)).thenAnswer((_) async => null);

      final result = await dataSource.getTvSeriesById(1);

      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeriesTable from database', () async {
      when(
        mockDatabaseHelper.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [testTvSeriesMap]);

      final result = await dataSource.getWatchlistTvSeries();

      expect(result, [testTvSeriesTable]);
    });
  });
}
